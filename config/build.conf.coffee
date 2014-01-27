## This file/module contains all configuration for the build process.

module.exports =
  ## The `build_dir` folder is where our projects are compiled during
  ## development and the `compile_dir` folder is where our app resides once it's
  ## completely built.
  build_dir: 'build/debug'
  compile_dir: 'build/release'
  docs_dir: 'docs/'

  ## This is a collection of file patterns that refer to our app code (the
  ## stuff in `src/`). These file paths are used in the configuration of
  ## build tasks. `js` is all project javascript, less tests. `ctpl` contains
  ## our reusable components' (`src/common`) template HTML files, while
  ## `atpl` contains the same, but for our app's code. `html` is just our
  ## main HTML file, `less` is our main stylesheet, and `unit` contains our
  ## app's unit tests.
  app_files:
    js: [ 'src/**/*.js', '!src/**/*.spec.js', '!src/assets/**/*.js', '!src/common/vendor/**/*.js' ]
    jsunit: [ 'src/**/*.spec.js','tests/unit/**/*.spec.js' ]

    coffee: [ 'src/**/*.coffee', '!src/**/*.spec.coffee', '!src/common/vendor/**/*.spec.coffee' ]
    coffeeunit: [ 'src/**/*.spec.coffee', 'tests/unit/**/*.spec.coffee' ]

    ctpl: [ 'src/common/**/*.tpl.html' ]
    atpl: [ 'src/**/*.tpl.html', '!<%= app_files.ctpl %>' ]

    html: [ 'src/index.html' ]
    less: 'src/less/main.less'

  ## This is the same as `app_files`, except it contains patterns that
  ## reference vendor code (`vendor/`) that we need to place into the build
  ## process somewhere. While the `app_files` property ensures all
  ## standardized files are collected for compilation, it is the user's job
  ## to ensure non-standardized (i.e. vendor-related) files are handled
  ## appropriately in `vendor_files.js`.
  ##
  ## The `vendor_files.js` property holds files to be automatically
  ## concatenated and minified with our project source files.
  ##
  ## The `vendor_files.css` property holds any CSS files to be automatically
  ## included in our app.
  ##
  ## The `vendor_files.assets` property holds any assets to be copied along
  ## with our app's assets. This structure is flattened, so it is not
  ## recommended that you use wildcards.
  vendor_files:
    js: [
      'vendor/angular/angular.js'
      'vendor/angular-ui-bootstrap3/ui-bootstrap-tpls.js'
      'vendor/angular-animate/angular-animate.js'
      'vendor/angular-resource/angular-resource.js'
      'vendor/angular-route/angular-route.js'
      'vendor/angular-sanitize/angular-sanitize.js'
      'vendor/marked/lib/marked.js'
      'vendor-private/yaml.js/yaml.js'
    ]
    css: [
    ]
    assets: [
      'README.md'
      'bower.json'
    ]

  ## This is a collection of files used during testing only.
  test_files:
    js: [
      '<%= app_files.jsunit %>'
      '<%= app_files.coffeeunit %>'
      'vendor/angular-mocks/angular-mocks.js'
    ]

  ## PhoneGap configuration
  phonegap:
    config:
      root: 'build/release'
      config: ''
      cordova: '.cordova'
      path: 'build/phonegap'
      platforms: [ 'android' ]
      releases: 'releases'
      releaseName: ->
        pkg = grunt.file.readJSON 'package.json'
        "#{pkg.name}-#{pkg.version}"

      ## Set an app icon at various sizes (optional)
      icons:
        android:
          ldpi: 'icon-36-ldpi.png'
          mdpi: 'icon-48-mdpi.png'
          hdpi: 'icon-72-hdpi.png'
          xhdpi: 'icon-96-xhdpi.png'
        wp8:
          app: 'icon-62-tile.png'
          tile: 'icon-173-tile.png'

      ## Set a splash screen at various sizes (optional)
      # Only works for Android now
      screens:
        android:
          ldpi: 'screen-ldpi-portrait.png'
          ## landscape version
          ldpiLand: 'screen-ldpi-landscape.png'
          mdpi: 'screen-mdpi-portrait.png'
          ## landscape version
          mdpiLand: 'screen-mdpi-landscape.png'
          hdpi: 'screen-hdpi-portrait.png'
          ## landscape version
          hdpiLand: 'screen-hdpi-landscape.png'
          xhdpi: 'screen-xhdpi-portrait.png'
          ## landscape version
          xhdpiLand: 'www/screen-xhdpi-landscape.png'

      ## Android-only integer version to increase with each release.
      # See http://developer.android.com/tools/publishing/versioning.html
      versionCode: -> 1
