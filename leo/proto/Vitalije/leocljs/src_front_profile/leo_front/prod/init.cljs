;@+leo-ver=5-thin
;@+node:vitalije.20170803150004.1: * @file src_front_profile/leo_front/prod/init.cljs
;@@language clojure
(ns leo-front.init
    (:require [leo-front.core :as core]
              [leo-front.conf :as conf]))

(enable-console-print!)

(defn start-descjop! []
  (core/init! conf/setting))

(start-descjop!)
;@-leo
