extend = (base, other) ->
  Object.keys(other).forEach (key) ->
    base[key] = other[key]
  base

module.exports = (grunt) ->
  require('time-grunt')(grunt)

  tasks =
    express:
      serve:
        options:
          port: 3000
          hostname: '0.0.0.0'
          bases: [ __dirname ]
    coffeelint: [ 'coffee/**/*.coffee' ]
    coffee:
      dist:
        options:
          sourceMap: true
        files:
          'dist/<%= pkg.name %>.js': [ 'coffee/**/*.coffee' ]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> compiled on
        <%= grunt.template.today("dd-mm-yyyy") %> */\n'
      files:
        'dist/<%= pkg.name %>.min.js': [ 'dist/<%= coffee.dist.dest %>' ]
    sass:
      options:
        compass: false
      dist:
        style: 'compressed'
        files:
          'css/flickrstream.css': 'sass/flickrstream.scss'
      dev:
        style: 'expanded'
        files:
          'css/flickrstream.css': 'sass/flickrstream.scss'
    watch:
      options:
        livereload: true
      files:
        [ 'coffee/**/*.coffee', 'sass/*.scss', 'index.html',
          'bower_components/**', 'assets/**' ]
      tasks:
        [ 'coffeelint', 'coffee', 'sass:dev' ]

  grunt.initConfig extend({ pkg: grunt.file.readJSON 'package.json' }, tasks)
  
  Object.keys(tasks).forEach (task) ->
    if (task is 'coffeelint' or task is 'express')
      grunt.loadNpmTasks 'grunt-' + task
    else
      grunt.loadNpmTasks 'grunt-contrib-' + task
  
  grunt.registerTask 'make-dev', [ 'coffeelint', 'coffee', 'sass:dev' ]
  grunt.registerTask 'make-dist', [
    'coffeelint', 'coffee', 'uglify', 'sass:dist' ]
  grunt.registerTask 'default', [ 'express', 'make-dev', 'watch' ]
