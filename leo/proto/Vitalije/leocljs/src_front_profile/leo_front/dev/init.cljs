;@+leo-ver=5-thin
;@+node:vitalije.20170803145658.1: * @file src_front_profile/leo_front/dev/init.cljs
;@@language clojure
(ns leo-front.init
  (:require [figwheel.client :as fw :include-macros true]
            [leo-front.core :as core]
            [leo-front.conf :as conf]))

(enable-console-print!)

(fw/watch-and-reload
 :websocket-url   "ws://localhost:3449/figwheel-ws"
 :jsload-callback 'start-descjop!)

(defn start-descjop! []
  (core/init! conf/setting)
  (core/tree-test))

(start-descjop!)
;@-leo
