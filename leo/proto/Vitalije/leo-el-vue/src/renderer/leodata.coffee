electron = require('electron')
fs = electron.remote.require('fs')
ROOTGNX = 'hidden-root-vnode-gnx'
get_bodies = (doc) ->
    res = {}
    f = (t) -> res[t.getAttribute('tx')] = t.textContent
    doc.querySelectorAll('leo_file>tnodes t').forEach f
    res

get_heads = (doc) ->
    res = {}
    nonClonedNodes doc,
        (v) ->
            res[v.getAttribute('t')] = v.firstChild.textContent
    res

get_children = (doc) ->
    res = {}
    toplevels = []
    res[ROOTGNX] = toplevels
    doc.querySelectorAll('leo_file>vnodes>v').forEach (v) ->
        toplevels.push v.getAttribute('t')
    nonClonedNodes doc,
        (v) ->
            cs = []
            [].forEach.apply(v.children, [
                (v2, i) ->
                    if i > 0
                        cs.push v2.getAttribute('t')])
            res[v.getAttribute('t')] = cs
    res

get_levels = (indexes) ->
    m = {lev: 0}
    res = [0]
    indexes.forEach ([l, r, gnx], i) ->
        if i is 0
            m.last = [l, r, gnx]
        else
            if l is m.last[0] + 1
                m.lev++
                res.push m.lev
            else
                dl = m.last[1] - l + 1
                m.lev += dl
                res.push m.lev
            m.last = [l, r, gnx]

    res

nonClonedNodes = (doc, f) ->
    doc.querySelectorAll('leo_file>vnodes v').forEach (v) ->
        f(v) if v.firstChild?

loadfile = (fname) ->
    parser = new DOMParser()
    parser.parseFromString(fs.readFileSync(fname, 'utf8'), 'text/xml')

loadfileAsync = (fname) ->
    new Promise (res, rej) ->
        fs.readFile fname, 'utf8', (err, data) ->
            return rej(err) if err
            parser = new DOMParser()
            res parser.parseFromString(data, 'text/xml')
get_indexes = (doc, children) ->
    res =
        l: []
        r: []
        g: []
        push: (a) ->
            @l.push a[0]
            @r.push a[1]
            @g.push a[2]
            @l.length - 1
        forEach: (f) ->
            {l,r,g} = this
            l.forEach (_l, i) ->
                f([_l, r[i], g[i]], i)

    do_index_node = (lft, gnx) ->
        childs = children[gnx]
        if childs.length > 0
            i = res.push [lft, 0, gnx]
            rgt = do_index_list_of_nodes lft + 1, childs
            res.r[i] = rgt
            return rgt
        else
            res.push [lft, lft + 1, gnx]
            return lft + 1
    do_index_list_of_nodes = (lft, childs) ->
        m = {lft}
        childs.forEach (v) ->
            m.lft = 1 + do_index_node m.lft, v
        m.lft
    do_index_node 0, ROOTGNX
    res

get_parents = (indexes) ->
    acc = []
    stack = [0]
    indexes.forEach ([l, r, gnx], i) ->
        if i is 0
            acc.push -1
        else
            par = stack[0]
            while l > indexes.r[par]
                stack.shift()
                par = stack[0]
            acc.push par
            if r - l > 1
                stack.unshift i
    acc
get_parents2 = (levels) ->
    acc = [0]
    stack = [0]
    i = 1
    lev0 = 0
    while i < levels.length
        par = stack[stack.length - 1]
        lev1 = levels[i]
        inclev = lev1 > lev0
        samelev = lev1 is lev0
        switch
            when inclev
                acc.push i
                stack.push i
            when samelev
                acc.push stack[lev0]
            else
                acc.push stack[lev1 - 1]
                stack.splice(lev1, stack.length, i)
        lev0 = lev1
        i += 1
    acc

get_parent_gnxes = (indexes, parents) ->
    res = {}
    add = (gnx, pari) ->
        res[gnx] ?= []
        res[gnx].push indexes.g[pari]
    indexes.g.forEach (gnx, i) ->
        add gnx, parents[i]
    res

computeIcon = (ldata, i) ->
    gnx = ldata.indexes.g[i]
    n = if ldata.bodies[gnx].length then 1 else 0
    n += if ldata.marks[gnx] then 2 else 0
    n += if ldata.pgnxes[gnx].length > 1 then 4 else 0
    if ldata.dirty[gnx] then n + 8 else n

getBody = (ldata, i) ->
    gnx = ldata.indexes.g[i]
    ldata.bodies[gnx] ? ''

treeItemData = (ldata, i) ->
    {indexes, expanded, heads, levels, bodies, marks, pgnxes} = ldata
    gnx = indexes.g[i]
    h = heads[gnx]
    lev = levels[i]
    exp = expanded[i]
    icnum = computeIcon ldata, i
    leaf = indexes.r[i] - indexes.l[i] is 1
    [h, lev, icnum, leaf, exp]
language = (ldata, i) ->
    return 'javascript' unless ldata.doc and i > 0
    rx = /^@language\s+(\w+)$/m
    m = rx.exec(getBody(ldata, i))
    while not m and ldata.parents[i] != 0
        i = ldata.parents[i]
        m = rx.exec getBody(ldata, i)
    return 'javascript' unless m
    if ['javascript', 'coffeescript', 'python', 'markdown', 'clojure',
        'css', 'sass', 'pug'].includes(m[1])
        return m[1]
    switch m[1]
        when 'clojurescript' then 'clojure'
        when 'java' then 'clike'
        else 'javascript'

updateBody = (ldata, i, b, j) ->
    g1 = ldata.indexes.g[i]
    g2 = ldata.indexes.g[j]
    if g1?
        _b = ldata.bodies[g1]
        ldata.bodies[g1] = b
        ldata.dirty[g1] or= _b isnt b
    ldata.bodies[g2]

getData = (fname, a_sync) ->
    if a_sync
        loadfileAsync(fname).then (doc) ->
            getDataFromDoc(doc)
    else
        doc = loadfile fname

getDataFromDoc = (doc) ->
    bodies = get_bodies(doc)
    heads = get_heads(doc)
    children = get_children(doc)
    indexes = get_indexes(doc, children)
    levels = get_levels(indexes)
    expanded = levels.map (lev) -> lev is 0
    parents = get_parents indexes
    pgnxes = get_parent_gnxes indexes, parents
    marks = {}
    dirty = {}
    {
        bodies
        heads
        children
        indexes
        levels
        expanded
        parents
        pgnxes
        marks
        dirty
        doc
        selectedIndex: -1
    }

export default {
    getData
    treeItemData
    getBody
    language
    computeIcon
}

