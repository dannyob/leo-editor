#@+leo-ver=5-thin
#@+node:vitalije.20170803130553.1: * @file Gruntfile.coffee
#@@language coffeescript
module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        "download-electron":
            version: "1.6.11",
            outputDir: "./electron",
            # if you want to download electron into project directory
            # downloadDir: ".electron-download",
            rebuild: true
        sass:
            main:
                style: 'compressed'
                files:
                    'app/dev/main.css': 'src_front/scss/main.scss'
                    'app/prod/main.css': 'src_front/scss/main.scss'
        watch:
            files: 'src_front/scss/**'
            tasks: ['sass']
    grunt.loadNpmTasks('grunt-download-electron')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-watch')
#@-leo
