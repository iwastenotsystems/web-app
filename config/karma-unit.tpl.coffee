module.exports = (config) ->
  config.set
    # Where to look for files, relative to the location of this file.
    # basePath: '../'

    # A list of file patterns to load into the browser during testing.
    # **Note:** Makes assumptions about the structure of both
    #           *`files.app.js`* and *`files.app.coffee`*.
    files: [
      <%= toQuotedString(scripts, '\n      ') %>
      <%= toQuotedString(_.flatten(spec), '\n      ') %>
      '<%= files.app.js[0] %>'
    ]
    exclude: [
      '<%= path.base.app %><%= path.app.assets %>**/*.js'
    ]
    frameworks: [ 'jasmine' ]
    plugins: [
        'karma-jasmine'
        'karma-chrome-launcher'
        'karma-coffee-preprocessor'
        'karma-coverage'
        'karma-firefox-launcher'
        'karma-html2js-preprocessor'
        'karma-jasmine'
        'karma-phantomjs-launcher'
        'karma-script-launcher'
    ],
    preprocessors:
      '**/*.coffee': 'coffee'
      '**/*.html': 'html2js'

    coffeePreprocessor:
      # options passed to the coffee compiler.
      options:
        bare: true
        sourceMap: true

    # How to report, by default.
    reporters: [
      'dots'
      'coverage'
    ]

    # On which port should the browser connect, on which port is the test runner
    # operating, and what is the URL path for the browser to use.
    port: <%= port.karma %>
    runnerPort: 9100
    urlRoot: '/'

    # Disable file watching by default.
    autoWatch: false

    # The list of browsers to launch to test on. This includes only "Firefox" by
    # default, but other browser names include:
    # Chrome, ChromeCanary, Firefox, Opera, Safari, PhantomJS
    #
    # Note that you can also use the executable name of the browser, like "chromium"
    # or "firefox", but that these vary based on your operating system.
    #
    # You may also leave this blank and manually navigate your browser to
    # http://localhost:9018/ when you're running tests. The window/tab can be left
    # open and the tests will automatically occur there during the build. This has
    # the aesthetic advantage of not launching a browser every time you save.
    browsers: [
      # 'Chrome'
      # 'Firefox'
      'PhantomJS'
    ]
