module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-bower-concat"

  # Change base only after loading npm tasks
  buildDir = grunt.option('buildDir')

  grunt.initConfig

    #Compile coffeescript files
    coffee:
      front:
        sourcemap: true
        files: [{
          expand: true
          cwd: "src/coffee/"
          src: ["*.coffee"]
          dest: "build/coffee/"
          ext: ".js"
        }]

    #Compile SASS files
    sass:
      front:
        sourcemap: false
        style: 'compressed'
        files:[{
          expand: true
          cwd: "src/sass/"
          src: ["*.sass"]
          dest: "build/sass/"
          ext: ".css"
        }]

    #Compile LESS files
    less:
      front:
        sourcemap: false
        style: 'compressed'
        files:[{
          expand: true
          cwd: "src/less/"
          src: ["*.less"]
          dest: "build/less/"
          ext: ".css"
        }]

    bower_concat:
      all:
        dest: "build/bower.js"
        cssDest: "build/bower.css"
        mainFiles:
          'bootstrap': [ "dist/css/bootstrap.css", "dist/js/bootstrap.js"]

    copy:
      bootstrapFonts:
        expand: true
        cwd: "bower_components/bootstrap/dist"
        src: ["fonts/*"]
        dest: "#{buildDir}"

    #Assumes individual files are already minified (no further uglification/minification)
    concat:
      options:
        separator: ';'
        stripBanners: true

      js:
        src: [
          "build/bower.js",
          "build/coffee/**/*.js"
        ]
        dest: "#{buildDir}/js/front.js"

      css:
        src: [
          "build/bower.css",
          "build/less/*.css",
          "build/sass/*.css"
        ]
        dest: "#{buildDir}/css/front.css"


    #Published uglified version of compiled app.js
    uglify:
      options:
        mangle: false
        compress: true
        beautify: false

      front:
        files: [{
          expand: true
          cwd: "#{buildDir}"
          src: [ "js/front.js" ]
          dest: "#{buildDir}"
          ext: ".min.js"
        }]

    # Watch relevant source files and perform tasks when they change
    watch:
      coffee:
        files: [ "src/coffee/**" ]
        tasks: [ "coffee:front", "concat:js" ]

      sass:
        files: [ "src/sass/**" ]
        tasks: [ "sass:front", "concat:css" ]

      less:
        files: [ "src/less/**" ]
        tasks: [ "less:front", "concat:css" ]

      js:
        files: [ "#{buildDir}/**.js" ]
        tasks: [ "concat:js", 'uglify:front']

      css:
        files: [ "#{buildDir}/**.css" ]
        tasks: [ "concat:css" ]

  grunt.registerTask "default", ['coffee', 'sass', 'less', 'bower_concat', 'concat', 'uglify', 'copy']
