<template lang="pug">
.leo-window
    .tree-wrap
        canvas#tree(v-on:mousedown="clickOutline",
                    :height="treeHeight",
                    :width="treeWidth")
    .body-editor
        textarea(v-model="body")
</template>

<script lang="coffee">
import leodata from '../leodata.coffee'
import leodraw from '../leodraw.coffee'
# basic imports
import CodeMirror from 'codemirror'
import 'codemirror/lib/codemirror.css'

# modes
import 'codemirror/mode/javascript/javascript.js'
import 'codemirror/mode/coffeescript/coffeescript.js'
import 'codemirror/mode/python/python.js'
import 'codemirror/mode/clike/clike.js'
import 'codemirror/mode/clojure/clojure.js'
import 'codemirror/mode/css/css.js'
import 'codemirror/mode/sass/sass.js'
import 'codemirror/mode/markdown/markdown.js'
import 'codemirror/mode/pug/pug.js'

# themes
import 'codemirror/theme/midnight.css'

export default {
    name: 'leo-editor'
    data: -> {
        treeWidth: 300
        treeHeight: window.innerHeight - 1
        mode: 'javascript'
        theme: 'elegant'
        treeSkip: 0
        treeCount: 40
        editorOptions: {
            tabSize: 8
        }
        themes: '3024-day
                3024-night
                abcdef
                ambiance
                ambiance-mobile
                base16-dark
                base16-light
                bespin
                blackboard
                cobalt
                colorforth
                dracula
                duotone-dark
                duotone-light
                eclipse
                elegant
                erlang-dark
                hopscotch
                icecoder
                isotope
                lesser-dark
                liquibyte
                material
                mbo
                mdn-like
                midnight
                monokai
                neat
                neo
                night
                oceanic-next
                panda-syntax
                paraiso-dark
                paraiso-light
                pastel-on-dark
                railscasts
                rubyblue
                seti
                shadowfox
                solarized
                the-matrix
                tomorrow-night-bright
                tomorrow-night-eighties
                ttcn
                twilight
                vibrant-ink
                xq-dark
                xq-light
                yeti
                zenburn'.split(' ')

    }

    computed:
        tree_body_ratio: ->
            (@treeWidth / (window.innerWidth - 20) * 100).toFixed(2)
        tree_percent_width: -> "width: #{@tree_body_ratio}%;"
        body_percent_width: ->"width: #{100 - @tree_body_ratio}%;"
        visIndexes: ->
            leodraw.visibleIndexes @leoData, @treeSkip, @treeCount
        leoData: ->
            @$store.state.leo
        selectedIndex: ->
            @$store.state.leo.selectedIndex
        languageMode: ->
            mode = leodata.language @leoData, @selectedIndex
        body: ->
            leodata.getBody @leoData, @selectedIndex
        dirty: ->
            @leoData.dirty
        marks: ->
            @leoData.marks

    methods:
        clickOutline: (e) ->
            row = (e.offsetY - 17) // 17
            vi = @visIndexes
            si = vi[row]
            lev = @leoData.levels[si]
            x2 = lev * 28
            if x2 - 28 <= e.offsetX <= x2
                @$store.commit('TOGGLE_NODE', si)
            else
                @$store.commit('SELECT_INDEX', si)

        bodyKeyDown: (e) ->
            console.log e

    mounted: ->
        self = this
        @$store.dispatch('loadLeoFile', 'leo-el-vue.leo')
        t = document.getElementById('tree')
        t.style.height = @treeHeight + 'px'
        a = @$el.querySelector('.body-editor textarea')
        console.log a
        @cminst = CodeMirror.fromTextArea a,
            lineNumbers: true
            mode: 'javascript'
            theme: 'midnight'
        cm = @$el.querySelector('.CodeMirror')
        cm.style.height = (@treeHeight - 15) + 'px'
        cm.style.maxWidth = (window.innerWidth - 20 - @treeWidth) + 'px'
        store = @$store
        @cminst.on 'change', (e, ch) ->
            return if ch.origin is 'setValue'
            b = e.getValue()
            store.commit 'SET_BODY', b

    watch:
        body: (val, oldval) ->
            if @cminst.getValue() != val
                @cminst.setValue val

        visIndexes: (val, oldval) ->
            leodraw.showTree @leoData, val

        selectedIndex: ->
            leodraw.showTree @leoData, @visIndexes
        dirty: ->
            leodraw.showTree @leoData, @visIndexes
        marks: ->
            leodraw.showTree @leoData, @visIndexes
        languageMode: (val) ->
            console.log val, 'mode'
            @cminst.setOption 'mode', val

}

</script>
<style>
body {
    background-color: #113333;
}
.leo-window {
    background-color: #113333;
    display:flex;
    overflow-y:hidden;
}
.leo-window .tree-wrap {
    width: 300px;
}
#tree {
    position:fixed;
    left:0;
    top:0px;
    width: 300px;
    height: 530px;
    overflow-x: auto;
    background: #071717;
}
.leo-window .body-editor {
    flex-grow:1;
    flex: 1 1 auto;
}
.CodeMirror {
    font-size: 20px;
    flex: 1 1 auto;
}
</style>

