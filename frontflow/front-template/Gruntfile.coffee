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
          dest: "#{buildDir}/front/coffee/"
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
          dest: "#{buildDir}/front/sass/"
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
          dest: "#{buildDir}/front/less/"
          ext: ".css"
        }]

    bower_concat:
      all:
        dest: "#{buildDir}/front/bower/build.js"
        cssDest: "#{buildDir}/front/bower/build.css"
        mainFiles:
          'bootstrap': [ "dist/css/bootstrap.css", "dist/js/bootstrap.js"]

    copy:
      bootstrapFonts:
        expand: true
        cwd: "bower_components/bootstrap/dist/fonts/"
        src: ["*"]
        dest: "#{buildDir}/front/fonts"

    #Assumes individual files are already minified (no further uglification/minification)
    concat:
      options:
        separator: ';'
        stripBanners: true

      compiledjs:
        src: [ "#{buildDir}/front/coffee/**/*.js" ]
        dest: "#{buildDir}/front/compiled.js"

      compiledcss:
        src: [
          "#{buildDir}/front/sass/*.css",
          "#{buildDir}/front/less/*.css"
        ]
        dest: "#{buildDir}/front/compiled.css"

      alljs:
        src: [
          "#{buildDir}/front/bower/build.js",
          "#{buildDir}/front/include/*.js",
          "#{buildDir}/front/coffee/**/*.js"
        ]
        dest: "#{buildDir}/front/all.js"

      allcss:
        src: [
          "#{buildDir}/front/bower/build.css",
          "#{buildDir}/front/compiled.css"
        ]
        dest: "#{buildDir}/front/all.css"


    #Published uglified version of compiled app.js
    uglify:
      options:
        mangle: false
        compress: true
        beautify: false

      front:
        files: [{
          expand: true
          cwd: "#{buildDir}/front"
          src: [ "compiled.js", "all.js" ]
          dest: "#{buildDir}/front"
          ext: ".min.js"
        }]

    # Watch relevant source files and perform tasks when they change
    watch:
      coffee:
        files: [ "src/coffee/**" ]
        tasks: [ "coffee:front", "concat:compiledjs", "concat:alljs"]

      sass:
        files: [ "src/sass/**" ]
        tasks: [ "sass:front", "concat:compiledcss", "concat:allcss" ]

      less:
        files: [ "src/less/**" ]
        tasks: [ "less:front", "concat:compiledcss", "concat:allcss" ]

      alljs:
        files: [ "#{buildDir}/**.js" ]
        tasks: [ "concat:alljs", 'uglify:front']

      allcss:
        files: [ "#{buildDir}/**.css" ]
        tasks: [ "concat:allcss" ]

  grunt.registerTask "default", ['coffee', 'sass', 'less', 'bower_concat', 'concat', 'uglify', 'copy']
