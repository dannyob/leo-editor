//@+leo-ver=5-thin
//@+node:ekr.20180216133454.1: * @file ../proto/Terry/leoserver/leoserver.js
jQ = jQuery
//@+others
//@+node:ekr.20180216151656.1: ** key press
// Somehow this prevents the Tree button from working!

if (false) {
    var console = document.getElementById("console");
    
    console.addEventListener("keyup", function(event) {
      // event.preventDefault();
      if (event.keyCode === 13) {
        document.getElementById("go").click();
      }
    });
}
//@+node:ekr.20180216133513.1: ** go
function go() {
    let console_txt = jQ('#console').val()
    jQ('#console').val('')
    jQ('#results').append('>>> '+console_txt+'\n')
    let data = {cmd: console_txt}
    fetch('/exec', {
        method: 'POST',
        body: JSON.stringify(data),
    // FIXME: test reponse.ok for failed requests
    }).then(response => response.json().then(show_result))
}
//@+node:ekr.20180216133513.2: ** show_result
function show_result(data) {
    jQ('#results').append(data.answer)
}
//@+node:ekr.20180216133513.3: ** show_tree
function show_tree(data) {
    // FIXME should recurse nodes
    console.log(data)
    for (let node of data.nodes) {
        jQ('#results').append(node.h+'\n')
    }
}

jQ('#go').click(go)
jQ('#update').click(update)
jQ('#clear').click(() => jQ('#results').text(''))
//@+node:ekr.20180216133513.4: ** update
function update() {
    fetch('/get_tree').then(resp => resp.json().then(show_tree))
}
//@-others
//@@language javascript
//@@tabwidth -4
//@-leo
