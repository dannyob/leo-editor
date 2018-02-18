;@+leo-ver=5-thin
;@+node:vitalije.20170803145447.1: * @file src_front/leo_front/core.cljs
;@@language clojure
(ns leo-front.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [cljs.core.async :refer [put! <! chan]]
            [goog.dom.xml :as gxml]
            [ajax.core :refer [GET POST]]
            [cljsjs.codemirror :as cm]
            ;[cljsjs.codemirror.mode.css]
            [cljsjs.codemirror.mode.javascript]))
;@+others
;@+node:vitalije.20170804114747.1: ** extend-types NodeList HTMLCollection
(extend-type js/NodeList
  ISeqable
  (-seq [array] (array-seq array 0)))

(extend-type js/HTMLCollection
  ISeqable
  (-seq [array] (array-seq array 0)))
;@+node:vitalije.20170804114755.1: ** app-state
(defonce app-state (atom {
    :message "A place for Leo body..."
    :selected-position -1
    :editors {
        :root {
            :keyboard-channel (chan)
            :body "A place for Leo body..."}}}))
;@+node:vitalije.20170804203753.1: ** icons
(defn draw-icon [n ctx x y sz]
    (let   [  w (* sz 35)
              h (* sz 15)
              h1 (/ h 3)
              sw sz]
        (set! (.-lineWidth ctx) sw)
        (set! (.-strokeStyle ctx) (if (bit-test n 3) "black" "#c7c7c7"))
        (.clearRect ctx x y w h)
        (.strokeRect ctx x y w h)
        (when (bit-test n 0)
            (set! (.-strokeStyle ctx) "#0000ff")
            (.strokeRect ctx (+ x (* w 0.66)) (+ y h1) h1 h1))
        (when (bit-test n 1)
            (set! (.-strokeStyle ctx) "#ff0000")
            (.strokeRect ctx (- (+ x (/ w 2)) sw) (+ y (* 2 sw)) sw (- h (* 4 sw))))
        (when (bit-test n 2)
            (.beginPath ctx)
            (set! (.-strokeStyle ctx) "#ff0000")
            (set! (.-lineWidth ctx) (* 0.5 sw))
            (.arc ctx (+ x (* w 0.25)) (+ y (* h 0.5)) (* 0.20 h) -1.5 3.4)
            (.moveTo ctx (+ x (* w 0.25)) (+ y (* h 0.5)))
            (.lineTo ctx (+ x (* w 0.25)) (+ y (* h 0.25)))
            (.lineTo ctx (+ x (* w 0.37)) (+ y (* h 0.25)))
            (.stroke ctx))
            ))

(defn draw-icon-at-canvas [n canv x y sz]
    (draw-icon n (.getContext canv "2d") x y sz))
;@+node:vitalije.20170808153300.1: ** all-parent-indexes
(defn all-parent-indexes [child]
    (let [parents (:parents @app-state)]
        (loop [acc []
               i child]
               (if (= i 0)
                   acc
                   (let [par (nth parents i)]
                     (recur (conj acc par) par))))))
;@+node:vitalije.20170808153322.1: ** all-parents-expanded?
(defn all-parents-expanded? [child]
    (let [{:keys [expanded]} @app-state]
        (not (some #(= false (nth expanded % false)) (all-parent-indexes child)))))
;@+node:vitalije.20170808153358.1: ** visible-index?
(defn visible-index? [i]
    (if (= i -1) false
        (or (= (nth (:parents @app-state) i) 0)
            (all-parents-expanded? i))))
;@+node:vitalije.20170806185629.1: ** visible-indexes
(defn visible-indexes []
    (keep-indexed #(if(visible-index? %1) %1 nil) (:expanded @app-state)))
;@+node:vitalije.20170808152050.1: ** select-position
(defn select-position [i]
    (let [  bodies (:bodies @app-state)
            b (-> @app-state 
                    :indexes
                    (nth i [])
                    last
                    bodies)
           editors (assoc-in (:editors @app-state) [:root :body] b)]
        (swap! app-state assoc
            :selected-position i
            :editors editors)))
;@+node:vitalije.20170808152649.1: ** expand-contract-item
(defn expand-contract-item [i]
    (let [expanded (:expanded @app-state)
          exp-st (nth expanded i :not-found)]
        (when-not (= exp-st :not-found)
            (swap! app-state assoc-in [:expanded i] (not exp-st))
            (when-not (visible-index? (:selected-position @app-state))
                (select-position i)))))
;@+node:vitalije.20170808161852.1: ** update-body
(defn update-body [b]
    (let [i (:selected-position @app-state)
          gnx (-> @app-state :indexes (nth i nil) (nth 2 nil))]
       (when gnx
            (swap! app-state assoc-in [:bodies gnx] b))))
;@+node:vitalije.20170805195520.1: ** draw-tree
;@+others
;@+node:vitalije.20170806185559.1: *3* draw-plus-minus
(defn draw-plus-minus [ctx x y exp selected?]
    (let [xa (- x 20)]
        (set! (.-lineWidth ctx) 1)
        (set! (.-strokeStyle ctx) (if selected? "#ffffce" "black"))
        (.strokeRect ctx xa y 12 12)
        (.strokeRect ctx (+ xa 3) (+ y 6) 6 1)
        (when-not exp
            (.strokeRect ctx (+ xa 6) (+ y 3) 1 6))))
;@+node:vitalije.20170806185616.1: *3* draw-tree-item
(defn draw-tree-item [ctx x y h lev dy ic-num leaf exp selected?]
    (let [xa (+ x (* lev 28) -5)]
        (when selected?
            (set! (.-fillStyle ctx) "#336699")
            (.fillRect ctx 0 (- y 5) 1024 dy))
        (set! (.-fillStyle ctx) (if selected? "#ffffce" "#000000"))
        (set! (.-font ctx) "12pt DejaVu Sans Mono")
        (.fillText ctx h (+ (* lev 28) x 35) (+ (* dy 0.5) y))
        (draw-icon ic-num ctx xa y 0.8)
        (when-not leaf (draw-plus-minus ctx xa y exp selected?))))
;@+node:vitalije.20170806185642.1: *3* screen-items
(defn screen-items [i n]
    (take n (drop i (visible-indexes))))
;@+node:vitalije.20170806185655.1: *3* tree-item-data
(defn tree-item-data [i]
    (let [{:keys [indexes expanded heads levels status]} @app-state
          [a b gnx] (nth indexes i)
          h (get heads gnx)
          lev (nth levels i)
          exp (nth expanded i)
          ic-num (nth status i)]
        [h lev ic-num (= (- b a) 1) exp]))
;@-others
(defn draw-tree [ctx i x dy]
    (let [sel-item (:selected-position @app-state)
          vis-ind (screen-items i 40)]
        (doseq [
            [y h lev leaf exp ic-num sel] (map 
                (fn [j k] 
                    (let [[h lev ic-num leaf exp] (tree-item-data j)]
                        [(* dy k) h lev leaf exp ic-num (= sel-item j)]))
                vis-ind (range))]
            (draw-tree-item ctx x (+ y 5) h lev dy ic-num leaf exp sel))))

(defn tree-test []
    (let [   canv (js/document.getElementById "tree")
             ctx (.getContext canv "2d")]
        (.setAttribute canv "height" (- (.-innerHeight js/window) 20))
        (.clearRect ctx 0 0 1024 1024)
        (draw-tree ctx 1 1 19)))

(defn time-tree-draw [n]
    (js/console.time "tree-draw")
    (loop [i 1]
        (tree-test)
        (if (> n i)
            (recur (inc i))
            (js/console.timeEnd "tree-draw"))))

(set! (.-treeTestDraw js/window) time-tree-draw)
;@+node:vitalije.20170806194736.1: ** canvas-mouse-down
(defn canvas-mouse-down [e]
    (let [canv (.-currentTarget e)
          ne (.-nativeEvent e)
          y (.-offsetY ne)
          row (quot y 19)
          actual-ind (nth (screen-items 1 40) row -1)
          lev (nth (:levels @app-state) actual-ind 0)
          xa (- (* lev 28) 11)
          exp-contr (and (< (.-offsetX ne) xa)
                         (< (- xa (.-offsetX ne)) 12))
         ]
        (cond
            (= actual-ind -1) nil
            exp-contr (expand-contract-item actual-ind)
            :else (select-position actual-ind)))
    (tree-test))
;@+node:vitalije.20170804114832.1: ** loading Leo document
(def ROOTGNX "hidden-root-vnode-gnx")
(enable-console-print!)
;@+others
;@+node:vitalije.20170804115236.1: *3* get-indexes doc children
(declare do-index-list-of-nodes)
(defn do-index-vnode [lft gnx children]
    (let [childs (get children gnx)]
        (if (seq childs)
            (let [  [rgt a] 
                        (do-index-list-of-nodes 
                            children 
                            (inc lft) 
                            childs
                            [])]
                (concat [[lft rgt gnx]] a))
            [[lft (inc lft) gnx]])))

(defn do-index-list-of-nodes [children lft childs acc]
    (loop [ acc []
            i lft
            v (first childs)
            nodes (rest childs)]

        (let [  a (do-index-vnode i v children)
                rgt (-> a first second inc)]

            (if (seq nodes)
                (recur (concat acc a) rgt
                       (first nodes)
                       (rest nodes))
                [rgt (concat acc a)]))))

(defn get-indexes [doc children]
    (do-index-vnode 0 ROOTGNX children))
;@+node:vitalije.20170804114917.1: *3* get-bodies doc
(defn get-bodies [doc]
    (let [  f (fn [t] (list (.getAttribute t "tx") (.-textContent t)))
            con (.querySelectorAll doc "leo_file>tnodes t")]
        (apply hash-map (mapcat f con))))
;@+node:vitalije.20170804114928.1: *3* get-children doc
(defn non-cloned-vnodes [doc]
    (for [v (.querySelectorAll doc "leo_file>vnodes v")
          :when (.-firstChild v)] v))
(defn get-children [doc]
    (let [  gnx (fn [v] (.getAttribute v "t"))
            chgnxes (fn [v] (mapv gnx (drop 1 (.-children v)))) 
            f (fn [v] (list (gnx v) (chgnxes v))) 
            toplevels (mapv gnx (.querySelectorAll doc "leo_file>vnodes>v"))]
        (apply hash-map ROOTGNX toplevels
            (mapcat f (non-cloned-vnodes doc)))))
;@+node:vitalije.20170804114935.1: *3* get-heads doc
(defn get-heads [doc]
    (apply hash-map
        (let [  gnx (fn [v] (.getAttribute v "t"))
                h (fn [v] (-> v .-firstChild .-textContent))
                f (fn [v] (list (gnx v) (h v))) ]
            (mapcat f
                (for [  v (.querySelectorAll doc "leo_file>vnodes v")
                        :when (.-firstChild v)] v)))))
;@+node:vitalije.20170804114956.1: *3* get-parents
(defn get-parents [levels]
    (loop [ i 0
            acc [0]
            levs (rest levels)
            lev0 (first levels)
            stack [0]]
      (if (seq levs)
          (let [  par (last stack)
                  lev1 (first levs)
                  inclev (> lev1 lev0)
                  samelev (= lev0 lev1)]
            (recur
                (inc i)
                (conj acc (cond
                            inclev i
                            samelev (nth stack lev0)
                            :else (nth stack (dec lev1))))
                (rest levs)
                lev1
                (cond 
                    inclev (conj stack i)
                    samelev stack
                    :else (conj (subvec stack 0 lev1) i))))
          acc)))
;@+node:vitalije.20170805194050.1: *3* get-levels
(defn get-levels [indexes]
    (loop [  acc [0]
             [a b gnx] (first indexes)
             nodes (rest indexes)
             lev 0]
        (if (seq nodes)
            (let [
                   [a2 b2 gnx2] (first nodes)
                   lev1 (+ lev 
                            (if (= (- a2 a) 1)
                                1
                            (- b a2 -1)))
                   nodes2 (rest nodes)]
                (recur
                    (conj acc lev1)
                    [a2 b2 gnx2]
                    (rest nodes)
                    lev1))
            acc)))
;@-others
(defn parse-leo-xml [d]
    (let
          [ doc (gxml/loadXml d)
            bodies (get-bodies doc)
            allgnxes (keys bodies)
            heads (get-heads doc)
            children (get-children doc)
            indexes (get-indexes doc children)
            levels (get-levels indexes)
            expanded (mapv #(= % 0) levels)
            parents (get-parents levels)]
        (swap! app-state assoc
            :bodies bodies
            :heads heads
            :children children
            :parents parents
            :indexes indexes
            :levels levels
            :expanded expanded
            :status (mapv (fn [[a b gnx]] (if (seq (get bodies gnx)) 1 0)) indexes)
            :leo-xml d
            :leo-doc doc)))
;@+node:vitalije.20170804114849.1: ** get-leo-doc ajax
(defn get-leo-doc [fname]
    (GET 
        fname
        {
            :handler parse-leo-xml
            :keywords? true
            :response-format :text}))
(defn load-leo-document [fname]
    (GET
        fname
        {
            :handler (fn [txt]
                        (parse-leo-xml txt)
                        (tree-test))
            :keywords? true
            :response-format :text}))
;@+node:vitalije.20170808094658.1: ** editor
;@+others
;@+node:vitalije.20170808094725.1: *3* map-hotkey
(defn  map-hotkey [e]
  (when (and (.-ctrlKey e) (.-shiftKey e))
   (cond
    (= (.-keyCode e) 88) :eval-tlf
    (= (.-keyCode e) 90) :load-buf)))
;@+node:vitalije.20170808161927.1: *3* editors atom
(def editors (atom {}))
;@+node:vitalije.20170808161936.1: *3* get-code-mirror
(defn get-code-mirror [elem]
    (get @editors elem))
;@+node:vitalije.20170808161946.1: *3* new-code-mirror
(defn new-code-mirror [elem]
    (let [  cminst (js/CodeMirror
                elem
                #js {
                    :matchBrackets true
                    :autoCloseBrackets true})]
        (swap! editors assoc elem cminst)
        (.on cminst "change"
            (fn [e]
                (update-body (.getValue e))))
        cminst))
;@-others
(defn resize-body-editor [elem]
    (let [h (- (.-innerHeight js/window) 20)]
        (.setAttribute elem "style" (str "height:" h "px;"))))
(defn editor [data owner]
  (reify
    om/IRenderState
    (render-state [this {:keys [keyboard-channel body]}]
      (dom/div #js {:onKeyDown (fn [e]
                                 (some->> (map-hotkey e)
                                          (put! keyboard-channel)))}))
    om/IWillUpdate
    (will-update [this next-props next-state]
        (let [cminst (get-code-mirror (om/get-node owner))]
            (.setValue cminst (:body next-props))))
    om/IDidMount
    (did-mount [_]
        (let [  elem (om/get-node owner)
                cminst (new-code-mirror elem)]
            (.setValue cminst (:body data))
            (resize-body-editor elem)
            (set! (.-mode cminst) "python")))))
;@-others
(get-leo-doc "leocljs-ref.leo")
(defn mount-root [setting]
  (om/root
   (fn [state owner]
     (reify om/IRender
       (render [_]
         (dom/div nil
            (dom/canvas #js {:id 'tree
                :onMouseDown #(canvas-mouse-down %) } nil)
            (om/build editor (-> state :editors :root))
            #_(dom/div #js {:id "editor_1"}
                 (:message state)
                 (dom/br nil)
                 #_(:my-env setting)
                 )))))
   app-state
   {:target (. js/document
               (getElementById "app"))}))
(set! (.-onresize js/window)
    (fn []
        (doseq [elem (keys @editors)]
            (resize-body-editor elem))
        (tree-test)))
(defn init! [setting]
  (mount-root setting))
;@-leo
