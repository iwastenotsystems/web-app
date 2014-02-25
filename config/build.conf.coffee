# This file/module contains all configuration for the build process.

module.exports =
  # TODO: Rewrite comment to reflect changes in the code. -- JR
  # The `build_dir` folder is where our projects are compiled during
  # development and the `compile_dir` folder is where our app resides once it's
  # completely built.
  path:
    base:
      app: 'app/'
      build: 'build/'
      config: 'config/'
      docs: 'docs/'
      spec: 'spec/'
      vendor: 'vendor/'
      vendorPrivate: 'vendor-private/'

    # TODO: Determine whether `coverage` is global or app specific -- JR
    app:
      assets: 'assets/'
      common: 'common/'
      coverage: 'coverage/'
      less: 'less/'
      spec:
        unit: 'unit/'
        e2e: 'e2e/'
      target:
        web: 'web/'
        phonegap: 'phonegap/'

    build:
      target:
        '<%= path.base.build %><%= path.app.target[grunt.option("target")] %>'
      develop: '<%= path.build.target %>develop/'
      release: '<%= path.build.target %>release/'


  file:
    gruntfile: 'Gruntfile.coffee'
    readme: 'README.md'

    manifest:
      node: 'package.json'
      bower: 'bower.json'

    base:
      html: 'index.html'
      less: 'main.less'

    less:
      css: '<%= path.app.assets %><%= pkg.name %>-<%= pkg.version %>.css'

    concat:
      js: '<%= path.app.assets %><%= pkg.name %>-<%= pkg.version %>.js'


    changelog:
      dest: 'CHANGELOG.md'
      template: '<%= path.base.config %>changelog.tpl'

    karma:
      config: '<%= path.build.develop %>karma-unit.coffee'
      template: '<%= path.base.config %>karma-unit.tpl.coffee'

    protractor:
      config: '<%= path.build.develop %>protractor-e2e.conf.js'
      template: '<%= path.base.config %>protractor-e2e.tpl.js'


  # The banner is the comment that is placed at the top of our compiled
  # source files. It is first processed as a Grunt template, where the `<%=`
  # pairs are evaluated based on this very configuration object.
  meta:
    banner:
      """
      /**
       * <%= pkg.name %>
       * v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>
       * <%= pkg.homepage %>
       *
       * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
       * Licensed <%= pkg.license %>
       */
      """

    git:
      branch: 'origin'
      tagName: 'v%VERSION%'
      tagMessage: 'Version %VERSION%'

  port:
    develop: 8001
    release: 8001
    test: 9001
    coverage: 5001
    karma: 9876
    protractor: 4444

  files:
    grunt: [
      '<%= file.gruntfile %>'
      'build.conf.coffee'
    ]
    # This is a collection of file patterns that refer to our app code (the
    # stuff in `app/`). These file paths are used in the configuration of
    # build tasks. `js` is all project javascript, less tests. `ctpl` contains
    # our reusable components' (`app/common`) template HTML files, while
    # `templates.app` contains the same, but for our app's code. `html` is
    # just our
    # main HTML file, `less` is our main stylesheet, and `unit` contains our
    # app's unit tests.
    app:
      js: [
        '<%= path.base.app %>**/*.js'
        '!<%= path.base.app %>/**/*.spec.js'
        '!<%= path.base.app %><%= path.app.assets %>**/*.js'
      ]
      coffee: [
        '<%= path.base.app %>**/*.coffee'
        '!<%= path.base.app %>**/*.spec.coffee'
      ]
      assets: [
        '<%= file.readme %>'
        'bower.json'
      ]

      spec:
        unit:
          js: [
            '<%= path.base.app %>**/*.unit.spec.js'
            '<%= path.base.spec %><%= path.app.spec.unit %>**/*.spec.js'
          ]
          coffee: [
            '<%= path.base.app %>**/*.unit.spec.coffee'
            '<%= path.base.spec %><%= path.app.spec.unit %>**/*.spec.coffee'
          ]
        e2e:
          js: [
            '<%= path.base.app %>**/*.e2e.spec.js'
            '<%= path.base.spec %><%= path.app.spec.e2e %>**/*.spec.js'
          ]
          coffee: [
            '<%= path.base.app %>**/*.e2e.spec.coffee'
            '<%= path.base.spec %><%= path.app.spec.e2e %>**/*.spec.coffee'
          ]

      templates:
        app: [
          '<%= path.base.app %>**/*.tpl.html'
          '!<%= files.app.templates.common %>'
        ]
        common: [
          '<%= path.base.app %><%= path.app.common %>**/*.tpl.html'
        ]

      html: [
        '<%= path.base.app %><%= file.base.html %>'
      ]
      less: '<%= path.base.app %><%= path.app.less %><%= file.base.less %>'

      doc: [
        '<%= file.readme %>'
        '<%= file.gruntfile %>'
        '<%= files.app.js %>'
        '<%= files.app.coffee %>'
      ]



    # This is the same as `app_files`, except it contains patterns that
    # reference vendor code (`vendor/`) that we need to place into the build
    # process somewhere. While the `app_files` property ensures all
    # standardized files are collected for compilation, it is the user's job
    # to ensure non-standardized (i.e. vendor-related) files are handled
    # appropriately in `vendor_files.js`.
    #
    # The `vendor_files.js` property holds files to be automatically
    # concatenated and minified with our project source files.
    #
    # The `vendor_files.css` property holds any CSS files to be automatically
    # included in our app.
    #
    # The `vendor_files.assets` property holds any assets to be copied along
    # with our app's assets. This structure is flattened, so it is not
    # recommended that you use wildcards.
    vendor:
      js: [
        '<%= path.base.vendor %>angular/angular.js'
        '<%= path.base.vendor %>angular-ui-bootstrap3/ui-bootstrap-tpls.js'
        '<%= path.base.vendor %>angular-animate/angular-animate.js'
        '<%= path.base.vendor %>angular-resource/angular-resource.js'
        '<%= path.base.vendor %>angular-route/angular-route.js'
        '<%= path.base.vendor %>angular-sanitize/angular-sanitize.js'
        '<%= path.base.vendor %>marked/lib/marked.js'
        '<%= path.base.vendor_private %>yaml.js/yaml.js'
      ]
      css: [
      ]
      assets: [
      ]


    # This is a collection of files used during testing only.
    spec:
      unit: [
        '<%= path.base.vendor %>angular-mocks/angular-mocks.js'
        '<%= files.app.spec.unit.js %>'
        '<%= files.app.spec.unit.coffee %>'
      ]
      e2e: [
        '<%= files.app.spec.e2e.js %>'
        '<%= files.app.spec.e2e.coffee %>'
      ]

  # PhoneGap configuration
  phonegap:
    config:
      root: '<%= path.build.develop %>'
      config: 'tmp/www/config.xml'
      cordova: '.cordova'
      path: '<%= path.build.release %>'
      plugins: []
      # platforms: [ 'android' ]
      platforms: [ 'ios' ]
      verbose: true
      releases: 'releases'
      releaseName: ->
        pkg = grunt.file.readJSON 'package.json'
        "#{pkg.name}-#{pkg.version}"

      # Set an app icon at various sizes (optional)
      # icons:
      #   android:
      #     ldpi: 'icon-36-ldpi.png'
      #     mdpi: 'icon-48-mdpi.png'
      #     hdpi: 'icon-72-hdpi.png'
      #     xhdpi: 'icon-96-xhdpi.png'
      #   wp8:
      #     app: 'icon-62-tile.png'
      #     tile: 'icon-173-tile.png'

      # Set a splash screen at various sizes (optional)
      # Only works for Android now
      # screens:
      #   android:
      #     ldpi: 'screen-ldpi-portrait.png'
      #     # landscape version
      #     ldpiLand: 'screen-ldpi-landscape.png'
      #     mdpi: 'screen-mdpi-portrait.png'
      #     # landscape version
      #     mdpiLand: 'screen-mdpi-landscape.png'
      #     hdpi: 'screen-hdpi-portrait.png'
      #     # landscape version
      #     hdpiLand: 'screen-hdpi-landscape.png'
      #     xhdpi: 'screen-xhdpi-portrait.png'
      #     # landscape version
      #     xhdpiLand: 'www/screen-xhdpi-landscape.png'

      # Android-only integer version to increase with each release.
      # See http://developer.android.com/tools/publishing/versioning.html
      versionCode: -> 1
