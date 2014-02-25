# # Web-App Gruntfile -- *Task Runner Definitions*
#
# TODO: Formal task docs -- JR
# > This file defines the build tasks associated with the Web-App project.

# Set up a wrapper function to encapsulate the Grunt configuration. When Grunt
# runs it will call this function and pass it a Grunt object.
module.exports = (grunt) ->

  _ = require 'lodash'

  toQuotedString = (array, separator = ', ', quoter = (str) -> "'#{str}'") ->
    _.map(array, quoter).join separator

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
    pkg: grunt.file.readJSON userConfig.file.manifest.node

    # Generate a changelog from git metadata, using the AngularJS commit
    # conventions. View CONVENTIONS.md for a synposis of the conventions with
    # commit examples.
    # TODO: Test this after a commit w/properly formatted comments -- JR
    changelog:
      options:
        dest: '<%= file.changelog.dest %>'
        template: '<%= file.changelog.template %>'

    # Increments the version number, etc.
    bump:
      options:
        files: [
          '<%= file.manifest.node %>'
          '<%= file.manifest.bower %>'
        ]
        commit: false
        commitMessage: 'chore(release): <%= bump.options.tagName %>'
        commitFiles: [
          '<%= file.manifest.node %>'
          '<%= file.manifest.bower %>'
        ]
        createTag: false
        tagName: '<%= meta.git.tagName %>'
        tagMessage: '<%= meta.git.tagMessage %>'
        push: false
        pushTo: '<%= meta.git.branch %>'

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

      bower_install:
        command: 'bower install'

      bower_update:
        command: 'bower update'

      npm_install:
        command: 'npm install'

      npm_update:
        command: 'npm update'

    connect:
      options:
        base: '<%= path.build.target %>'
        port: '<%= port.release %>'

      develop:
        options:
          base: '<%= path.build.develop %>'
          port: '<%= port.develop %>'

      release:
        options:
          base: '<%= path.build.release %>'
          keepalive: true
          port: '<%= port.release %>'

      test:
        options:
          base: '<%= path.build.develop %>'
          port: '<%= port.test %>'

      coverage:
        options:
          base: '<%= path.base.coverage %>'
          keepalive: true
          port: '<%= port.coverage %>'


    open:
      develop:
        path: 'http://localhost:<%= port.develop %>'

      release:
        path: 'http://localhost:<%= port.release %>'

      coverage:
        path: 'http://localhost:<%= port.coverage %>'


    # `docco` produces an HTML document that displays your comments
    # intermingled with your code. All prose is passed through Markdown, and
    # code is passed through Highlight.js syntax highlighting.
    docco:
      build:
        src: '<%= files.app.doc %>'
        options: {
          layout: 'linear'
          output: '<%= path.base.docs %>'
        }

    # The directories to delete when `grunt clean` is executed.
    clean: [
      '<%= path.build.target %>*'
    ]

    # HTML2JS is a Grunt plugin that takes all of your template files and
    # places them into JavaScript files as strings that are added to
    # AngularJS's template cache. This means that the templates too become
    # part of the initial payload as one JavaScript file. Neat!
    html2js:
      # These are the templates from `src/app`.
      app:
        options:
          base: '<%= path.base.app %>'
        src: [ '<%= files.app.atpl %>' ]
        dest: '<%= path.build.develop %>templates-app.js'

      # These are the templates from `src/common`.
      common:
        options:
          base: '<%= path.base.app %><%= path.app.common %>'
        src: [ '<%= files.app.ctpl %>' ]
        dest: '<%= path.build.develop %>templates-common.js'

    # `jshint` defines the rules of our linter as well as which files we
    # should check. This file, all javascript sources, and all our unit tests
    # are linted based on the policies listed in `options`. But we can also
    # specify exclusionary patterns by prefixing them with an exclamation
    # point (!); this is useful when code comes from a third party but is
    # nonetheless inside `src/`.
    jshint:
      app: [
        '<%= files.app.js %>'
      ]
      test: [
        '<%= files.app.jsunit %>'
      ]
      gruntfile: [
        'Gruntfile.js'
        'config/build.conf.js'
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
      app:
        files:
          src: [ '<%= files.app.coffee %>' ]
      test:
        files:
          src: [ '<%= files.app.coffeeunit %>' ]
      gruntfile: [
        'Gruntfile.coffee'
        'config/build.conf.coffee'
      ]

    # `grunt coffee` compiles the CoffeeScript sources. To work well with the
    # rest of the build, we have a separate compilation task for sources and
    # specs so they can go to different places. For example, we need the
    # sources to live with the rest of the copied JavaScript so we can include
    # it in the final build, but we don't want to include our specs there.
    coffee:
      develop:
        options:
          bare: true
          sourceMap: true
        expand: true
        cwd: '.'
        src: [ '<%= files.app.coffee %>' ]
        dest: '<%= path.build.develop %>'
        ext: '.js'
      release:
        options:
          bare: true
          join: true
        expand: true
        cwd: '.'
        files:
          '<%= path.build.release %><%= file.concat.js %>':
            '<%= files.app.coffee %>'
        ext: '.js'


    # `less` handles our LESS compilation and uglification automatically.
    # Only our `main.less` file is included in compilation; all other files
    # must be imported from this file.
    # TODO: If *less* will do the `css` concat, remove `concat:css_develop`,
    # *less* can compress! -- JR
    less:
      develop:
        files:
          '<%= path.build.develop %><%= file.less.css %>': [
            '<%= files.app.less %>'
            # '<%= files.vendor.css %>'
          ]
        options:
          compress: false
      release:
        files:
          '<%= path.build.release %><%= file.less.css %>': [
            '<%= files.app.less %>'
            '<%= files.vendor.css %>'
          ]
        options:
          compress: true
          cleancss: true

    # `grunt concat` concatenates multiple source files into a single file.
    concat:
      # The `build_css` target concatenates compiled CSS and vendor CSS
      # together.
      css_release:
        src: [
          '<%= files.vendor.css %>'
          '<%= path.build.release %><%= file.less.css %>'
        ]
        dest: '<%= path.build.release %><%= file.less.css %>'

      # The `compile_js` target is the concatenation of our application source
      # code and all specified vendor source code into a single file.
      js_release:
        options:
          banner: '<%= meta.banner %>'
        src: [
          '<%= files.vendor.js %>'
          '<%= path.base.config %>module.prefix'
          # '<%= path.build.develop %><%= path.app.app %>**/*.js'
          # TODO: If this works, remove the line above this note -- JR
          '<%= path.build.release %><%= file.concat.js %>'
          '<%= html2js.app.dest %>'
          '<%= html2js.common.dest %>'
          '<%= path.base.config %>module.suffix'
        ]
        dest: '<%= path.build.release %><%= file.concat.js %>'

    # The `copy` task just copies files from A to B. We use it here to copy
    # our project assets (images, fonts, etc.) and javascripts into
    # `app.develop`, and then to copy the assets to `app.release`.
    copy:
      assets_app_develop:
        files: [
          {
            src: [ '**' ]
            dest: '<%= path.build.develop %><%= path.app.assets %>'
            cwd: '<%= path.base.app %><%= path.app.assets %>'
            expand: true
          }
          {
            src: [ '<%= files.app.assets %>' ]
            dest: '<%= path.build.develop %><%= path.app.assets %>'
            cwd: '.'
            expand: true
            flatten: true
          }
        ]
      assets_vendor_develop:
        files: [
          {
            src: [ '<%= files.vendor.assets %>' ]
            dest: '<%= path.build.develop %><%= path.app.assets %>'
            cwd: '.'
            expand: true
            flatten: true
          }
        ]
      js_app_develop:
        files: [
          {
            src: [ '<%= files.app.js %>' ]
            dest: '<%= path.build.develop %>'
            cwd: '.'
            expand: true
          }
        ]
      js_vendor_develop:
        files: [
          {
            src: [ '<%= files.vendor.js %>' ]
            dest: '<%= path.build.develop %>'
            cwd: '.'
            expand: true
          }
        ]
      js_test_develop:
        files: [
          {
            src: [ '<%= files.test.js %>' ]
            dest: '<%= path.build.develop %>'
            cwd: '.'
            expand: true
          }
        ]

      assets_release:
        files: [
          {
            src: [ '**' ]
            dest: '<%= path.build.release %><%= path.app.assets %>'
            cwd: '<%= path.base.app %><%= path.app.assets %>'
            expand: true
          }
          {
            src: [ '<%= files.app.assets %>' ]
            dest: '<%= path.build.release %><%= path.app.assets %>'
            cwd: '.'
            expand: true
            flatten: true
          }
          {
            src: [ '<%= files.vendor.assets %>' ]
            dest: '<%= path.build.develop %><%= path.app.assets %>'
            cwd: '.'
            expand: true
            flatten: true
          }
        ]

    # The `index` task compiles the `index.html` file as a Grunt template. CSS
    # and JS files co-exist here but they get split apart later.
    index:
      options:
        index: '<%= file.base.html %>'
        base: '<%= path.base.app %>'

      # During development, we don't want to have wait for compilation,
      # concatenation, minification, etc. So to avoid these steps, we simply
      # add all script files directly to the `<head>` of `index.html`. The
      # `src` property contains the list of included files.
      develop:
        dest: '<%= path.build.develop %>'
        src: [
          '<%= files.vendor.js %>'
          '<%= path.build.develop %><%= path.base.app %>**/*.js'
          '<%= html2js.common.dest %>'
          '<%= html2js.app.dest %>'
          '<%= files.vendor.css %>'
          '<%= file.less.css %>'
        ]

      # When it is time to have a completely compiled application, we can
      # alter the above to include only a single JavaScript and a single CSS
      # file. Now we're back!
      release:
        dest: '<%= path.build.release %>'
        src: [
          '<%= concat.js_release.dest %>'
          '<%= file.less.css %>'
        ]

    # `ng-min` annotates the sources before minifying. That is, it allows us
    # to code without the array syntax.
    ngmin:
      release:
        files: [
          {
            src: [ '<%= path.build.release %><%= file.concat.js %>' ]
            dest: '<%= path.build.release %><%= file.concat.js %>'
          }
        ]

    # Minify the sources!
    uglify:
      release:
        options:
          banner: '<%= meta.banner %>'
          compress: true
          mangle: true
          preserveComments: false
          report: 'min'
        files: [
          {
            src: [ '<%= path.build.release %><%= file.concat.js %>' ]
            dest: '<%= path.build.release %><%= file.concat.js %>'
          }
        ]

    # This task compiles the karma template so that changes to its file array
    # don't have to be managed manually.
    karmaconfig:
      options:
        base: '<%= path.build.develop %>'
        specs: '<%= files.app.coffeeunit %>'
        template: '<%= file.karma.template %>'

      unit:
        dest: '<%= file.karma.config %>'
        src: [
          '<%= files.vendor.js %>'
          '<%= html2js.app.dest %>'
          '<%= html2js.common.dest %>'
          '<%= files.test.js %>'
        ]

    # The Karma configurations.
    karma:
      unit:
        configFile: '<%= file.karma.config %>'
        autoWatch: false
        singleRun: true

      unit_auto:
        configFile: '<%= file.karma.config %>'
        autoWatch: true
        singleRun: false

      unit_coverage:
        configFile: '<%= file.karma.config %>'
        autoWatch: false
        singleRun: true
        reporters: [
          'progress'
          'coverage'
        ]
        preprocessors:
          '<%= files.app.js %>': [ 'coverage' ]
          '<%= files.app.coffee %>': [ 'coverage' ]

        coverageReporter:
          type: 'html'
          dir: '<%= path.base.coverage %>'

    # The Protractor configurations.
    protractor:
      options:
        keepAlive: true
        configFile: '<%= file.protractor.config %>'

      singlerun: {}

      auto:
        keepAlive: true
        options:
          args:
            seleniumPort: '<%= port.protractor %>'


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
        files: [
          '<%= files.grunt %>'
        ]
        tasks: [
          'jshint:gruntfile'
          'docs'
        ]
        options:
          livereload: false

      # When our JavaScript source files change, we want to run lint them and
      # run our unit tests.
      jssrc:
        files: [
          '<%= files.app.js %>'
        ]
        tasks: [
          'jshint:app'
          'test:unit:run'
          'copy:js_app_develop'
          'docs'
        ]

      # When our CoffeeScript source files change, we want to run lint them and
      # run our unit tests.
      coffeesrc:
        files: [
          '<%= files.app.coffee %>'
        ]
        tasks: [
          'coffeelint:app'
          'coffee:develop'
          'test:unit:run'
          'copy:js_app_develop'
          'docs'
        ]

      # When assets are changed, copy them. Note that this will *not* copy new
      # files, so this is probably not very useful.
      assets:
        files: [
          '<%= path.base.app %><%= path.app.assets %>**/*'
        ]
        tasks: [
          'copy:assets_app_develop'
        ]

      # When index.html changes, we need to compile it.
      html:
        files: [
          '<%= files.app.html %>'
        ]
        tasks: [
          'index:develop'
        ]

      # When our templates change, we only rewrite the template cache.
      tpls:
        files: [
          '<%= files.app.atpl %>'
          '<%= files.app.ctpl %>'
        ]
        tasks: [
          'html2js'
        ]

      # When the CSS files change, we need to compile and minify them.
      less:
        files: [
          '<%= path.base.app %>**/*.less'
        ]
        tasks: [
          'less:develop'
        ]

      # When a JavaScript unit test file changes, we only want to lint it and
      # run the unit tests. We don't want to do any live reloading.
      jsunit:
        files: [
          '<%= files.app.jsunit %>'
        ]
        tasks: [
          'jshint:test'
          'test:unit:run'
        ]
        options:
          livereload: false

      # When a CoffeeScript unit test file changes, we only want to lint it and
      # run the unit tests. We don't want to do any live reloading.
      coffeeunit:
        files: [
          '<%= files.app.coffeeunit %>'
        ]
        tasks: [
          'coffeelint:test'
          'test:unit:run'
        ]
        options:
          livereload: false

  grunt.initConfig grunt.util._.extend taskConfig, userConfig

  grunt.option 'target', "web" if not grunt.option('target')?

  # In order to make it safe to just compile or copy *only* what was changed,
  # we need to ensure we are starting from a clean, fresh build. So we rename
  # the `watch` task to `delta` (that's why the configuration var above is
  # `delta`) and then add a new task called `watch` that does a clean build
  # before watching for changes.
  grunt.renameTask 'watch', 'delta'
  grunt.registerTask 'watch', [
    'build:develop'
    'delta'
  ]

  # installation-related
  grunt.registerTask 'init', [
    'shell:bower_install'
    'shell:protractor_install'
  ]
  grunt.registerTask 'update', [
    # 'shell:npm_update'
    'shell:bower_update'
    'shell:protractor_install'
  ]

  # The `build` task gets your app ready to run for development and testing.
  grunt.registerTask 'build:common', [
    'clean'
    'html2js'
    'jshint'
    'coffeelint'
  ]

  # The `build` task gets your app ready to run for development and testing.
  grunt.registerTask 'build:develop', [
    'build:common'
    'coffee:develop'
    'less:develop'
    'copy:assets_app_develop'
    'copy:assets_vendor_develop'
    'copy:js_app_develop'
    'copy:js_vendor_develop'
    'copy:js_test_develop'
    'index:develop'
    'test:unit'
  ]

  # The `build` task gets your app ready to run for development and testing.
  grunt.registerTask 'build:release', [
    'build:common'
    'coffee:release'
    'less:release'
    'concat:css_release'
    'copy:assets_release'
    'ngmin'
    'concat:js_release'
    'uglify'
    'index:release'
  ]

  grunt.registerTask 'build', [
    # 'update'
    'build:develop'
    'build:release'
  ]

  # single run tests
  grunt.registerTask 'test', [
    'jshint'
    'test:unit'
    'test:e2e'
  ]
  grunt.registerTask 'test:unit', [
    'karmaconfig'
    'karma:unit'
  ]
  grunt.registerTask 'test:e2e', [
    'connect:test'
    'shell:selenium'
    'protractor:singlerun'
    'shell:selenium:kill'
  ]

  # autotest and watch tests
  grunt.registerTask 'autotest', [
    'karma:unit_auto'
  ]
  grunt.registerTask 'autotest:unit', [
    'karma:unit_auto'
  ]
  grunt.registerTask 'autotest:e2e', [
    'connect:test'
    'shell:selenium'
    'watch:protractor'
    'shell:selenium:kill'
  ]

  # coverage testing
  grunt.registerTask 'test:coverage', [
    'karma:unit_coverage'
  ]
  grunt.registerTask 'coverage', [
    'karma:unit_coverage'
    'open:coverage'
    'connect:coverage'
  ]

  # development
  grunt.registerTask 'develop', [
    'connect:develop'
    'watch'
  ]

  grunt.registerTask 'develop:serve', [
    'build:develop'
    'connect:develop'
    'open:develop'
    'watch'
  ]

  # documentation
  grunt.registerTask 'docs', [
    'docco'
  ]

  # The default task is to `update` and `build` all versions.
  grunt.registerTask 'default', [
    'build'
    'docs'
    'open:release'
    'connect:release'
  ]


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
    options = @options
      base: ''
      index: 'index.html'

    path = grunt.config "path.build.#{@target}"
    dirRE = new RegExp "^#{path}", 'g'
    jsFiles = filterForJS(@filesSrc).map (file) -> file.replace dirRE, ''
    cssFiles = filterForCSS(@filesSrc).map (file) -> file.replace dirRE, ''

    jsFiles.push 'phonegap.js' if grunt.option('target')?

    grunt.file.copy "#{options.base}#{options.index}",
      "#{@data.dest}#{options.index}",
      process: (contents, path) ->
        grunt.template.process contents,
          _.extend grunt.config.data,
            scripts: jsFiles

  # In order to avoid having to manually specify the files needed for karma to
  # run, we use grunt to manage the list for us. The `karma/*` files are
  # compiled as grunt templates for use by Karma. Yay!
  grunt.registerMultiTask 'karmaconfig', 'Process karma config templates', ->
    options = @options
      base: ''
      config: 'karma-unit.js'
      template: 'karma-unit.tpl.js'

    options = _.assign @options(), @data

    options.scripts = filterForJS(_.flatten @filesSrc).map (file) ->
      file.replace new RegExp("^#{options.base}", 'g'), ''

    options.toQuotedString = toQuotedString
    options = _.assign grunt.config.data, options

    grunt.file.copy options.template, @data.dest,
      process: (contents, path) ->
        grunt.template.process contents, options

