import leodata from '../../leodata.coffee'
state = {
    indexes:
        l: []
        r: []
        g: []
    bodies: {}
    heads: {}
    children: {}
    parents:[]
    pgnxes: {}
    expanded: []
    levels: []
    marks: []
    dirty: {}
    doc: null
    fname: ''
    selectedIndex: -1
}

mutations = {
    LOAD_LEO_FILE: (state, {fname, ldata}) ->
        Object.assign state, {...ldata, fname}

    SELECT_INDEX: (state, i) ->
        state.selectedIndex = i

    TOGGLE_NODE: (state, i) ->
        e = state.expanded.slice()
        e[i] = not e[i]
        state.expanded = e

    TOGGLE_MARKED_NODE: (state, i) ->
        e = {...state.marks}
        g = state.indexes.g[i]
        e[g] = not e[g]
        state.marks = e

    SET_BODY: (state, b) ->
        g = state.indexes.g[state.selectedIndex]
        if g and b isnt state.bodies[g]
            state.bodies = {...state.bodies}
            state.bodies[g] = b
            unless state.dirty[g]
                state.dirty = {...state.dirty}
                state.dirty[g] = true

}

actions = {
    loadLeoFile: ({ commit }, fname) ->
        leodata.getData(fname, true).then (ldata) ->
            commit('LOAD_LEO_FILE', {fname, ldata})
}

export default {
  state,
  mutations,
  actions
}
