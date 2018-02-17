;@+leo-ver=5-thin
;@+node:vitalije.20170803150219.1: * @file src_tools/figwheel_middleware.clj
;@@language clojure
(ns figwheel-middleware
  (:require [ring.middleware.resource :refer (wrap-resource)]))

(defn handler [request]
  {:status  404
   :headers {"Content-Type" "text/html"}
   :body    (str "Cannot find:" (:uri request))})

(def app
  ;; static resources in resources/public
  ;; (wrap-resource "public")
  ;; static resources from webjars dependencies
  (wrap-resource handler "/META-INF/resources"))
;@-leo
