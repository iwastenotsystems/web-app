module.exports = (grunt) ->

  # Load required Grunt tasks. These are installed based on the versions listed
  # in `package.json` when you do `npm install` in this directory.
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Load in our build configuration file.
  userConfig = require './config/build.conf.coffee'

  # This is the configuration object Grunt uses to give each plugin its
  # instructions.
  taskConfig =
    # We read in our `package.json` file so we can access the package name and
    # version. It's already there, so we don't repeat ourselves here.
    pkg: grunt.file.readJSON 'package.json'

    # The banner is the comment that is placed at the top of our compiled
    # source files. It is first processed as a Grunt template, where the `<%=`
    # pairs are evaluated based on this very configuration object.
    meta:
      banner:
        """
        /**
         * <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>
         * <%= pkg.homepage %>
         *
         * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
         * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>
         */
        """

    # Creates a changelog on a new version.
    changelog:
      options:
        dest: 'CHANGELOG.md'
        template: 'changelog.tpl'

    # Increments the version number, etc.
    bump:
      options:
        files: [
          'package.json'
          'bower.json'
        ]
        commit: false
        commitMessage: 'chore(release): v%VERSION%'
        commitFiles: [
          'package.json'
          'client/bower.json'
        ]
        createTag: false
        tagName: 'v%VERSION%'
        tagMessage: 'Version %VERSION%'
        push: false
        pushTo: 'origin'

    # The directories to delete when `grunt clean` is executed.
    clean: [
      '<%= build_dir %>'
      '<%= compile_dir %>'
    ]

    shell:
      options:
        stdout: true

      selenium:
        # command: './selenium/start'
        command: 'node_modules/protractor/bin/webdriver-manager start'
        options:
          stdout: false
          async: true

      protractor_install:
        command: 'node_modules/protractor/bin/webdriver-manager update'

      npm_install:
        command: 'npm install'

    connect:
      options:
        port: 8888
        base: 'build/debug'

      webserver:
        options:
          port: 8001
          base: 'build/debug'
          keepalive: true

      devserver:
        options:
          port: 8001

      testserver:
        options:
          port: 9001

      coverage:
        options:
          base: 'coverage/'
          port: 5001
          keepalive: true


    # The Protractor configurations.
    protractor:
      options:
        keepAlive: true
        configFile: 'config/protractor-e2e.conf.js'
        # args:
        #   seleniumServerJar: 'node_modules/protractor/selenium/selenium-server-standalone-2.39.0.jar'

      singlerun: {}

      auto:
        keepAlive: true
        options:
          args:
            seleniumPort: 4444

    open:
      devserver:
        path: 'http://localhost:8001'

      coverage:
        path: 'http://localhost:5001'

    # The Karma configurations.
    karma:
      unit:
        configFile: '<%= build_dir %>/karma-unit.coffee'
        autoWatch: false
        singleRun: true

      unit_auto:
        configFile: '<%= build_dir %>/karma-unit.coffee'
        autoWatch: true
        singleRun: false

      unit_coverage:
        configFile: '<%= build_dir %>/karma-unit.coffee'
        autoWatch: false
        singleRun: true
        reporters: [ 'progress', 'coverage' ]
        preprocessors:
          '<%= app_files.js %>': [ 'coverage' ]
          '<%= app_files.coffee %>': [ 'coverage' ]

        coverageReporter:
          type: 'html'
          dir: 'coverage/'

    # The `copy` task just copies files from A to B. We use it here to copy
    # our project assets (images, fonts, etc.) and javascripts into
    # `build_dir`, and then to copy the assets to `compile_dir`.
    copy:
      build_app_assets:
        files: [
          {
            src: [ '**' ]
            dest: '<%= build_dir %>/assets/'
            cwd: 'src/assets'
            expand: true
          }
        ]
      build_vendor_assets:
        files: [
          {
            src: [ '<%= vendor_files.assets %>' ]
            dest: '<%= build_dir %>/assets/'
            cwd: '.'
            expand: true
            flatten: true
          }
        ]
      build_appjs:
        files: [
          {
            src: [ '<%= app_files.js %>' ]
            dest: '<%= build_dir %>/'
            cwd: '.'
            expand: true
          }
        ]
      build_vendorjs:
        files: [
          {
            src: [ '<%= vendor_files.js %>' ]
            dest: '<%= build_dir %>/'
            cwd: '.'
            expand: true
          }
        ]
      build_testjs:
        files: [
          {
            src: [ '<%= test_files.js %>' ]
            dest: '<%= build_dir %>/'
            cwd: '.'
            expand: true
          }
        ]
      compile_assets:
        files: [
          {
            src: [ '**' ]
            dest: '<%= compile_dir %>/assets'
            cwd: '<%= build_dir %>/assets'
            expand: true
          }
        ]

    # `grunt concat` concatenates multiple source files into a single file.
    concat:
      # The `build_css` target concatenates compiled CSS and vendor CSS
      # together.
      build_css:
        src: [
          '<%= vendor_files.css %>'
          '<%= recess.build.dest %>'
        ]
        dest: '<%= recess.build.dest %>'

      # The `compile_js` target is the concatenation of our application source
      # code and all specified vendor source code into a single file.
      compile_js:
        options:
          banner: '<%= meta.banner %>'
        src: [
          '<%= vendor_files.js %>'
          'config/module.prefix'
          '<%= build_dir %>/src/**/*.js'
          '<%= html2js.app.dest %>'
          '<%= html2js.common.dest %>'
          'config/module.suffix'
        ]
        dest: '<%= compile_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.js'

    # `grunt coffee` compiles the CoffeeScript sources. To work well with the
    # rest of the build, we have a separate compilation task for sources and
    # specs so they can go to different places. For example, we need the
    # sources to live with the rest of the copied JavaScript so we can include
    # it in the final build, but we don't want to include our specs there.
    coffee:
      source:
        options:
          bare: true
          sourceMap: true
        expand: true
        cwd: '.'
        src: [ '<%= app_files.coffee %>' ]
        dest: '<%= build_dir %>'
        ext: '.js'

    # `docco` produces an HTML document that displays your comments
    # intermingled with your code. All prose is passed through Markdown, and
    # code is passed through Highlight.js syntax highlighting.
    docco:
      build:
        src: [
          'README.md'
          'Gruntfile.js'
          'Gruntfile.coffee'
          '<%= app_files.js %>'
          '<%= app_files.coffee %>'
        ]
        options: {
          layout: 'linear'
          output: '<%= docs_dir %>'
        }

    # `ng-min` annotates the sources before minifying. That is, it allows us
    # to code without the array syntax.
    ngmin:
      compile:
        files: [
          {
            src: [ '<%= app_files.js %>' ]
            cwd: '<%= build_dir %>'
            dest: '<%= build_dir %>'
            expand: true
          }
        ]

    # Minify the sources!
    uglify:
      compile:
        options:
          banner: '<%= meta.banner %>'
        files:
          '<%= concat.compile_js.dest %>': '<%= concat.compile_js.dest %>'

    # `recess` handles our LESS compilation and uglification automatically.
    # Only our `main.less` file is included in compilation; all other files
    # must be imported from this file.
    recess:
      build:
        src: [ '<%= app_files.less %>' ]
        dest: '<%= build_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.css'
        options:
          compile: true
          compress: false
          noUnderscores: false
          noIDs: false
          zeroUnits: false
      compile:
        src: [ '<%= recess.build.dest %>' ]
        dest: '<%= recess.build.dest %>'
        options:
          compile: true
          compress: true
          noUnderscores: false
          noIDs: false
          zeroUnits: false

    # `jshint` defines the rules of our linter as well as which files we
    # should check. This file, all javascript sources, and all our unit tests
    # are linted based on the policies listed in `options`. But we can also
    # specify exclusionary patterns by prefixing them with an exclamation
    # point (!); this is useful when code comes from a third party but is
    # nonetheless inside `src/`.
    jshint:
      src: [
        '<%= app_files.js %>'
      ]
      test: [
        '<%= app_files.jsunit %>'
      ]
      gruntfile: [
        'Gruntfile.js'
      ]
      options:
        curly: true
        immed: true
        newcap: true
        noarg: true
        sub: true
        boss: true
        eqnull: true
      globals: {}

    # `coffeelint` does the same as `jshint`, but for CoffeeScript.
    # CoffeeScript is not the default in ngBoilerplate, so we're just using
    # the defaults here.
    coffeelint:
      src:
        files:
          src: [ '<%= app_files.coffee %>' ]
      test:
        files:
          src: [ '<%= app_files.coffeeunit %>' ]

    # HTML2JS is a Grunt plugin that takes all of your template files and
    # places them into JavaScript files as strings that are added to
    # AngularJS's template cache. This means that the templates too become
    # part of the initial payload as one JavaScript file. Neat!
    html2js:
      # These are the templates from `src/app`.
      app:
        options:
          base: 'src'
        src: [ '<%= app_files.atpl %>' ]
        dest: '<%= build_dir %>/templates-app.js'

      # These are the templates from `src/common`.
      common:
        options:
          base: 'src/common'
        src: [ '<%= app_files.ctpl %>' ]
        dest: '<%= build_dir %>/templates-common.js'

    # The `index` task compiles the `index.html` file as a Grunt template. CSS
    # and JS files co-exist here but they get split apart later.
    index:

      # During development, we don't want to have wait for compilation,
      # concatenation, minification, etc. So to avoid these steps, we simply
      # add all script files directly to the `<head>` of `index.html`. The
      # `src` property contains the list of included files.
      build:
        dir: '<%= build_dir %>'
        src: [
          '<%= vendor_files.js %>'
          '<%= build_dir %>/src/**/*.js'
          '<%= html2js.common.dest %>'
          '<%= html2js.app.dest %>'
          '<%= vendor_files.css %>'
          '<%= recess.build.dest %>'
        ]

      # When it is time to have a completely compiled application, we can
      # alter the above to include only a single JavaScript and a single CSS
      # file. Now we're back!
      compile:
        dir: '<%= compile_dir %>'
        src: [
          '<%= concat.compile_js.dest %>'
          '<%= vendor_files.css %>'
          '<%= recess.compile.dest %>'
        ]

    # This task compiles the karma template so that changes to its file array
    # don't have to be managed manually.
    karmaconfig:
      unit:
        dir: '<%= build_dir %>'
        src: [
          '<%= vendor_files.js %>'
          '<%= html2js.app.dest %>'
          '<%= html2js.common.dest %>'
          '<%= test_files.js %>'
        ]

    # And for rapid development, we have a watch set up that checks to see if
    # any of the files listed below change, and then to execute the listed
    # tasks when they do. This just saves us from having to type "grunt" into
    # the command-line every time we want to see what we're working on; we can
    # instead just leave "grunt watch" running in a background terminal. Set it
    # and forget it, as Ron Popeil used to tell us.
    #
    # But we don't need the same thing to happen for all the files.
    delta:
      # By default, we want the Live Reload to work for all tasks; this is
      # overridden in some tasks (like this file) where browser resources are
      # unaffected. It runs by default on port 35729, which your browser
      # plugin should auto-detect.
      options:
        livereload: true

      # When the Gruntfile changes, we just want to lint it. In fact, when
      # your Gruntfile changes, it will automatically be reloaded!
      gruntfile:
        files: 'Gruntfile.js'
        tasks: [ 'jshint:gruntfile' ]
        options:
          livereload: false

      # When our JavaScript source files change, we want to run lint them and
      # run our unit tests.
      jssrc:
        files: [
          '<%= app_files.js %>'
        ]
        tasks: [ 'jshint:src', 'karma:unit:run', 'copy:build_appjs' ]

      # When our CoffeeScript source files change, we want to run lint them and
      # run our unit tests.
      coffeesrc:
        files: [
          '<%= app_files.coffee %>'
        ]
        tasks: [ 'coffeelint:src', 'coffee:source', 'karma:unit:run', 'copy:build_appjs' ]

      # When assets are changed, copy them. Note that this will *not* copy new
      # files, so this is probably not very useful.
      assets:
        files: [
          'src/assets/**/*'
        ]
        tasks: [ 'copy:build_assets' ]

      # When index.html changes, we need to compile it.
      html:
        files: [ '<%= app_files.html %>' ]
        tasks: [ 'index:build' ]

      # When our templates change, we only rewrite the template cache.
      tpls:
        files: [
          '<%= app_files.atpl %>'
          '<%= app_files.ctpl %>'
        ]
        tasks: [ 'html2js' ]

      # When the CSS files change, we need to compile and minify them.
      less:
        files: [ 'src/**/*.less' ]
        tasks: [ 'recess:build' ]

      # When a JavaScript unit test file changes, we only want to lint it and
      # run the unit tests. We don't want to do any live reloading.
      jsunit:
        files: [
          '<%= app_files.jsunit %>'
        ]
        tasks: [ 'jshint:test', 'karma:unit:run' ]
        options:
          livereload: false

      # When a CoffeeScript unit test file changes, we only want to lint it and
      # run the unit tests. We don't want to do any live reloading.
      coffeeunit:
        files: [
          '<%= app_files.coffeeunit %>'
        ]
        tasks: [ 'coffeelint:test', 'karma:unit:run' ]
        options:
          livereload: false

  grunt.initConfig grunt.util._.extend taskConfig, userConfig

  # In order to make it safe to just compile or copy *only* what was changed,
  # we need to ensure we are starting from a clean, fresh build. So we rename
  # the `watch` task to `delta` (that's why the configuration var above is
  # `delta`) and then add a new task called `watch` that does a clean build
  # before watching for changes.
  grunt.renameTask 'watch', 'delta'
  grunt.registerTask 'watch', [
    'build'
    'karma:unit'
    'delta'
  ]

  # The default task is to build and compile.
  grunt.registerTask 'default', [
    'build'
    'compile'
  ]

  # The `build` task gets your app ready to run for development and testing.
  grunt.registerTask 'build', [
    'clean'
    'html2js'
    'jshint'
    'coffeelint'
    'coffee'
    'recess:build'
    'concat:build_css'
    'copy:build_app_assets'
    'copy:build_vendor_assets'
    'copy:build_appjs'
    'copy:build_vendorjs'
    'copy:build_testjs'
    'index:build'
    'karmaconfig'
    'autotest'
  ]

  # The `compile` task gets your app ready for deployment by concatenating and
  # minifying your code.
  grunt.registerTask 'compile', [
    'recess:compile'
    'copy:compile_assets'
    'ngmin'
    'concat:compile_js'
    'uglify'
    'index:compile'
  ]

  # single run tests
  grunt.registerTask 'test', ['jshint','test:unit', 'test:e2e']
  grunt.registerTask 'test:unit', ['karma:unit']
  grunt.registerTask 'test:e2e', ['connect:testserver','protractor:singlerun']

  # autotest and watch tests
  grunt.registerTask 'autotest', ['karma:unit_auto']
  grunt.registerTask 'autotest:unit', ['karma:unit_auto']
  grunt.registerTask 'autotest:e2e', ['connect:testserver','shell:selenium','watch:protractor']

  # coverage testing
  grunt.registerTask 'test:coverage', ['karma:unit_coverage']
  grunt.registerTask 'coverage', ['karma:unit_coverage','open:coverage','connect:coverage']

  # installation-related
  grunt.registerTask 'install', ['update','shell:protractor_install']
  grunt.registerTask 'update', ['shell:npm_install', 'concat']

  # defaults
  grunt.registerTask 'default', ['dev']

  # development
  grunt.registerTask 'dev', ['update', 'connect:devserver', 'open:devserver', 'watch:assets']

  # server daemon
  grunt.registerTask 'serve', ['connect:webserver']

  # A utility function to get all app JavaScript sources.
  filterForJS = (files) ->
    files.filter (file) ->
      file.match /\.js$/

  # A utility function to get all app CSS sources.
  filterForCSS = (files) ->
    files.filter (file) ->
      file.match /\.css$/

  # The index.html template includes the stylesheet and javascript sources
  # based on dynamic names calculated in this Gruntfile. This task assembles
  # the list into variables for the template to use and then runs the
  # compilation.
  grunt.registerMultiTask 'index', 'Process index.html template', ->
    dirRE = new RegExp "^(#{grunt.config 'build_dir'}|#{grunt.config 'compile_dir'})\/", 'g'
    jsFiles = filterForJS(@filesSrc).map (file) -> file.replace dirRE, ''
    cssFiles = filterForCSS(@filesSrc).map (file) -> file.replace dirRE, ''

    grunt.file.copy 'src/index.html', "#{@data.dir}/index.html",
      process: (contents, path) ->
        grunt.template.process contents,
          data:
            scripts: jsFiles
            styles: cssFiles
            version: grunt.config 'pkg.version'

  # In order to avoid having to specify manually the files needed for karma to
  # run, we use grunt to manage the list for us. The `karma/*` files are
  # compiled as grunt templates for use by Karma. Yay!
  grunt.registerMultiTask 'karmaconfig', 'Process karma config templates', ->
    dirRE = new RegExp "^(#{@files[0].dir})\/", 'g'
    jsFiles = filterForJS(@filesSrc).map (file) -> file.replace dirRE, ''

    grunt.file.copy 'config/karma-unit.tpl.coffee', "#{grunt.config 'build_dir'}/karma-unit.coffee",
      process: (contents, path) ->
        grunt.template.process contents,
          data:
            specs: grunt.config 'app_files.coffeeunit'
            scripts: jsFiles
