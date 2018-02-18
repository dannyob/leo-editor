<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="vitalije.20170803125850.3"><vh>@clean README.md</vh>
<v t="vitalije.20170803130406.1"><vh>leo</vh>
<v t="vitalije.20170803130406.2"><vh>Requirements</vh>
<v t="vitalije.20170803130406.3"><vh>(if you don't install grunt yet.)</vh></v>
</v>
<v t="vitalije.20170803130406.4"><vh>Help</vh></v>
<v t="vitalije.20170803130406.5"><vh>display latest version</vh></v>
<v t="vitalije.20170803130406.6"><vh>New project from leiningen template</vh>
<v t="vitalije.20170803130406.7"><vh>Minimum project</vh></v>
<v t="vitalije.20170803130406.8"><vh>[Om](https://github.com/omcljs/om) based project</vh></v>
<v t="vitalije.20170803130406.9"><vh>[reagent](https://github.com/reagent-project/reagent) based project</vh></v>
</v>
<v t="vitalije.20170803130406.10"><vh>Project Directory</vh></v>
<v t="vitalije.20170803130406.11"><vh>Usage</vh>
<v t="vitalije.20170803130406.12"><vh>step 1</vh>
<v t="vitalije.20170803130406.13"><vh>OSX/Linux user</vh></v>
<v t="vitalije.20170803130406.14"><vh>Windows user</vh></v>
</v>
<v t="vitalije.20170803130406.15"><vh>step 2</vh></v>
<v t="vitalije.20170803130406.16"><vh>step 3</vh></v>
<v t="vitalije.20170803130406.17"><vh>step 4</vh>
<v t="vitalije.20170803130406.18"><vh>development mode</vh></v>
<v t="vitalije.20170803130406.19"><vh>production mode</vh></v>
</v>
</v>
<v t="vitalije.20170803130406.20"><vh>Package App</vh>
<v t="vitalije.20170803130406.21"><vh>(If not already installed Electron-packager.)</vh></v>
<v t="vitalije.20170803130406.22"><vh>run command</vh>
<v t="vitalije.20170803130406.23"><vh>for OSX</vh></v>
<v t="vitalije.20170803130406.24"><vh>for OSX app store</vh></v>
<v t="vitalije.20170803130406.25"><vh>for windows 32bit app</vh></v>
<v t="vitalije.20170803130406.26"><vh>for windows 64bit app</vh></v>
<v t="vitalije.20170803130406.27"><vh>for linux</vh></v>
</v>
</v>
<v t="vitalije.20170803130406.28"><vh>How to Upgrade to new Electron version</vh></v>
<v t="vitalije.20170803130406.29"><vh>Aliases</vh></v>
<v t="vitalije.20170803130406.30"><vh>License</vh></v>
</v>
</v>
<v t="vitalije.20170803131231.1"><vh>@edit package.json</vh></v>
<v t="vitalije.20170803130553.1"><vh>@file Gruntfile.coffee</vh></v>
<v t="vitalije.20170803134700.1"><vh>@file project.clj</vh></v>
<v t="vitalije.20170803150219.1"><vh>@file src_tools/figwheel_middleware.clj</vh></v>
<v t="vitalije.20170803150340.1"><vh>APP src</vh>
<v t="vitalije.20170803142716.1"><vh>@file src/leo/core.cljs</vh></v>
</v>
<v t="vitalije.20170803150403.1"><vh>FRONT</vh>
<v t="vitalije.20170804153253.1"><vh>SCSS</vh>
<v t="vitalije.20170804153321.1"><vh>@file src_front/scss/main.scss</vh></v>
</v>
<v t="vitalije.20170803145447.1"><vh>@file src_front/leo_front/core.cljs</vh></v>
</v>
<v t="vitalije.20170804153700.1"><vh>HTML</vh>
<v t="vitalije.20170804153728.1"><vh>@edit app/dev/index.html</vh></v>
</v>
<v t="vitalije.20170803150413.1"><vh>CONF</vh>
<v t="vitalije.20170803150421.1"><vh>DEV</vh>
<v t="vitalije.20170803145658.1"><vh>@file src_front_profile/leo_front/dev/init.cljs</vh></v>
<v t="vitalije.20170803145827.1"><vh>@file src_front_profile/leo_front/dev/conf.cljs</vh></v>
</v>
<v t="vitalije.20170803150428.1"><vh>PROD</vh>
<v t="vitalije.20170803150004.1"><vh>@file src_front_profile/leo_front/prod/init.cljs</vh></v>
<v t="vitalije.20170803150055.1"><vh>@file src_front_profile/leo_front/prod/conf.cljs</vh></v>
</v>
</v>
</vnodes>
<tnodes>
<t tx="vitalije.20170803125850.3">@language md
@others
</t>
<t tx="vitalije.20170803130406.1">
This project build by descjop v0.7.2

Leo editor re-implemented as electron application

</t>
<t tx="vitalije.20170803130406.10">
  see your app dir. looks like

```
.
+-- Gruntfile.js
+-- README.md
+-- app
|   +-- dev // deveropment mode dir
|   |   +-- index.html // entry html file
|   |   +-- js
|   |   |   +-- externs_front.js
|   |   |   +-- externs.js
|   |   |   +-- main.js
|   |   +-- package.json // for Desktop app
|   +-- prod // production mode dir
|       +-- index.html // entry html file
|       +-- js
|       |   +-- externs_front.js
|       |   +-- externs.js
|       |   +-- main.js
|       +-- package.json // for Desktop app
+-- package.json // for Compile
+-- project.clj // compile settings desktop app
+-- resources
+-- src
|   +-- NAMESPACE
|       +-- core.cljs // ClojureScript for Electron in here
+-- src_front
|   +--NAMESPACE_front
|      +-- core.cljs // Frontend clojureScript in here
+-- src_front_profile
    +--NAMESPACE_front
       +-- dev
       |   +-- conf.cljs
       |   +-- init.cljs
       +-- prod
           +-- conf.cljs
           +-- init.cljs
```

</t>
<t tx="vitalije.20170803130406.11">
</t>
<t tx="vitalije.20170803130406.12">
run `descjop-init` (windows user should use `descjop-init-win`) alias below.

</t>
<t tx="vitalije.20170803130406.13">
```
$ lein descjop-init
 ...
 
Running "download-electron" task
 
Done, without errors.
```

</t>
<t tx="vitalije.20170803130406.14">
```
$ lein descjop-init-win
 ...
 
Running "download-electron" task
 
Done, without errors.
```

</t>
<t tx="vitalije.20170803130406.15">
you have to change `src/PROJECT_NAME/core.cljs` about `:companyName` and `submitURL`.

```
(defn -main []
  (.start crash-reporter (clj-&gt;js {:companyName "Your Company Name"
                                   :submitURL   "http://example.com/"}))
  ...
```

</t>
<t tx="vitalije.20170803130406.16">
and run extern alias `descjop-externs`,

```
$ lein descjop-externs
```

run cljsbuild `lein descjop-once`.

```
$ lein descjop-once

Compiling ClojureScript.
Compiling "app/js/cljsbuild-main.js" from ["src"]...
Successfully compiled "app/js/cljsbuild-main.js" in 10.812 seconds.
...
Successfully compiled "app/dev/js/front.js" in 10.588 seconds.
...
Successfully compiled "app/prod/js/cljsbuild-main.js" in 19.333 seconds.
...
Successfully compiled "app/prod/js/front.js" in 29.94 seconds.
```

</t>
<t tx="vitalije.20170803130406.17">
You can run Desctop application.

</t>
<t tx="vitalije.20170803130406.18">
development mode use figwheel. run alias `descjop-figwheel`.  before run application.
Open other terminal window.

```
$ lein descjop-figwheel
```

and you can run Electron(Atom-Shell) app.

On Windows:

```
$ .\electron\electron.exe app/dev
```

On Linux:

```
$ ./electron/electron app/dev
```

On OS X:

```
$ ./electron/Electron.app/Contents/MacOS/Electron app/dev
```

</t>
<t tx="vitalije.20170803130406.19">
you can run Electron(Atom-Shell) app.

On Windows:

```
$ .\electron\electron.exe app/prod
```

On Linux:

```
$ ./electron/electron app/prod
```

On OS X:

```
$ ./electron/Electron.app/Contents/MacOS/Electron app/prod
```

</t>
<t tx="vitalije.20170803130406.2">
* leiningen 2.6.x +
* node v0.12.x +
* grunt v0.1.13 +

</t>
<t tx="vitalije.20170803130406.20">
</t>
<t tx="vitalije.20170803130406.21">
```
$ npm install -g electron-packager
```

</t>
<t tx="vitalije.20170803130406.22">
</t>
<t tx="vitalije.20170803130406.23">
```
$ lein descjop-uberapp-osx
```

</t>
<t tx="vitalije.20170803130406.24">
```
$ descjop-uberapp-app-store
```

</t>
<t tx="vitalije.20170803130406.25">
```
$ descjop-uberapp-win32
```

</t>
<t tx="vitalije.20170803130406.26">
```
$ descjop-uberapp-win64
```

</t>
<t tx="vitalije.20170803130406.27">
```
$ descjop-uberapp-linux
```

</t>
<t tx="vitalije.20170803130406.28">
You can change Electron version in Gruntfile.js.

```
module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        "download-electron": {
            version: "1.3.2", // change Electron version 1.3.2 -&gt; 1.3.3
            outputDir: "./electron", 
            rebuild: true
        }
    });

    grunt.loadNpmTasks('grunt-download-electron');

};
```

and re-run

for linux / mac

```
$ lein descjop-init
```

for windows

```
$ lein descjop-init-win
```

</t>
<t tx="vitalije.20170803130406.29">
you can use aliases in project directory.

```
$ lein descjop-version       # descjop version
$ lein descjop-help          # descjop help
$ lein descjop-init          # init project
$ lein descjop-init-win      # init project for windows user
$ lein descjop-externs       # output externs for develop and production
$ lein descjop-externs-dev   # output externs for develop
$ lein descjop-externs-prod  # output externs for production
$ lein descjop-figwheel      # start figwheel
$ lein descjop-once          # build JavaScript for develop and production
$ lein descjop-once-dev      # build JavaScript for develop
$ lein descjop-once-prod     # build JavaScript for production
```

</t>
<t tx="vitalije.20170803130406.3">
```
$ npm install -g grunt-cli
```


</t>
<t tx="vitalije.20170803130406.30">
Copyright ©  FIXME

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
</t>
<t tx="vitalije.20170803130406.4">
You can display help how to use descjop.

```
$ lein new descjop help
```

and you can use alias in project directory.

```
$ lein descjop-help
```

</t>
<t tx="vitalije.20170803130406.5">
You can display latest version.

```
$ lein new descjop version
```

</t>
<t tx="vitalije.20170803130406.6">
</t>
<t tx="vitalije.20170803130406.7">
```
$ lein new descjop YOUR_APP_NAME
$ cd YOUR_APP_NAME
```

</t>
<t tx="vitalije.20170803130406.8">
```
$ lein new descjop YOUR_APP_NAME +om
$ cd YOUR_APP_NAME
```

</t>
<t tx="vitalije.20170803130406.9">
```
$ lein new descjop YOUR_APP_NAME +reagent
$ cd YOUR_APP_NAME
```

</t>
<t tx="vitalije.20170803150340.1"></t>
<t tx="vitalije.20170803150403.1"></t>
<t tx="vitalije.20170803150413.1"></t>
<t tx="vitalije.20170803150421.1"></t>
<t tx="vitalije.20170803150428.1"></t>
<t tx="vitalije.20170804153253.1"></t>
<t tx="vitalije.20170804153700.1"></t>
</tnodes>
</leo_file>
