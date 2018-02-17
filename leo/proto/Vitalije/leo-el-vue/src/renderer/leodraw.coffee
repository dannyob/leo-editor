import leodata from './leodata.coffee'
treeItemData = leodata.treeItemData
ROOTGNX = 'hidden-root-vnode-gnx'
allParentIndexes = (ldata, i) ->
    parents = ldata.parents
    res = []
    return res unless parents.length
    while i != 0
        i = parents[i]
        res.push i
    res

areAllParentsExpanded = (ldata, i) ->
    f = (j) -> (j is 0) or ldata.expanded[j]
    allParentIndexes(ldata, i).every f

isItemVisible = (ldata, i) ->
    i > 0 and areAllParentsExpanded(ldata, i)

visibleIndexes = (ldata, skip, count) ->
    res = []
    for i in [1...ldata.levels.length]
        if isItemVisible(ldata, i)
            if skip
                skip--
            else
                res.push i
                count--
                break unless count
    res

drawTree = (ctx, ldata, skip, count, x, dy) ->
    items = visibleIndexes(ldata, skip, count)
    drawTree_visible ctx, ldata, items, x, dy

drawTree_visible = (ctx, ldata, items, x, dy) ->
    y0 = dy
    W = ctx.canvas.width
    H = ctx.canvas.height
    ctx.clearRect 0, 0, W, H
    items.forEach (i, j) ->
        drawTreeItem ctx, x, y0 + j * dy, dy, ldata, i
    items

drawIcon = (n, ctx, x, y, sz) ->
    w = sz * 35
    h = sz * 15
    h1 = h / 3
    sw = sz
    sw2 = sw / 2
    ctx.lineWidth = sw
    ctx.strokeStyle = if n & 8 then 'black' else '#77ffff'
    ctx.clearRect x, y, w, h
    ctx.fillStyle = '#80b0b0'
    ctx.fillRect x - sw, y - sw, w + 2 * sw, h + 2 * sw
    ctx.strokeRect x + sw2, y + sw2, w - sw, h - sw
    if n & 1
        ctx.strokeStyle = '#1111ff'
        ctx.strokeRect x + 0.66 * w, y + h1, h1, h1
    if n & 2
        ctx.strokeStyle = '#ff0000'
        ctx.strokeRect x + w / 2 - sw, y + 2 * sw, sw, h - 4 * sw
    if n & 4
        ctx.strokeStyle = '#ff000'
        ctx.lineWidth = sw2
        ctx.beginPath()
        ctx.arc x + 0.25 * w, y + h / 2, 0.2 * h, -1.5, 3.4
        ctx.lineTo x + w * 0.25,  y + h * 0.25
        ctx.lineTo x + w * 0.37,  y + h * 0.25
        ctx.stroke()

drawPlusMinus = (ctx, x, y, exp, selected) ->
    xa = x - 20
    ctx.lineWidth = 1
    ctx.strokeStyle = if selected then '#ffffce' else '#c7c7c7'
    ctx.strokeRect xa, y, 12, 12
    ctx.strokeRect xa + 3, y + 6, 6, 1
    if not exp
        ctx.strokeRect xa + 6, y + 3, 1, 6
_drawTreeItem = (ctx, x, y, h, lev, dy, icnum, leaf, exp, selected) ->
    xa = x + 28 * lev - 5
    if selected
        ctx.fillStyle = '#336699'
        ctx.fillRect 0, y - 5, 1024, dy
        ctx.fillStyle = '#ffffce'
    else
        ctx.fillStyle = '#E7E7c7'
    ctx.font = '12pt DejaVu Sans Mono'
    ctx.fillText h, 28 * lev + x + 35, y + 0.5 * dy
    drawIcon icnum, ctx, xa, y, 0.8
    if not leaf
        drawPlusMinus ctx, xa, y, exp, selected

drawTreeItem = (ctx, x, y, dy, ldata, i) ->
    [h, lev, icnum, leaf, exp] = treeItemData ldata, i
    selected = ldata.selectedIndex is i
    _drawTreeItem ctx, x, y, h, lev, dy, icnum, leaf, exp, selected

window.di = (ldata, items) ->
    showTree ldata, items

showTree = (ldata, items) ->
    canv = document.getElementById('tree')
    h = canv.offsetHeight
    canv.height = h
    ctx = canv.getContext('2d')
    drawTree_visible ctx, ldata, items, 0, 17

export default {
    drawIcon
    showTree
    visibleIndexes
}

