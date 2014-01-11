module.exports = (config) ->
  config.set
    basePath : '../'

    files : [
      'app/vendor/angular/angular.js'
      'app/vendor/angular-**/angular-*.js'
      'app/vendor/angular-ui-bootstrap-bower/ui-bootstrap-tpls.js'
      'app/vendor/marked/lib/marked.js'
      'app/vendor/js-yaml/js-yaml.js'
      'app/dist/*.js'
      'app/dist/**/*.js'
      'tests/unit/**/*.coffee'
    ]

    exclude : [
      'app/vendor/angular-loader/angular-loader.js'
      'app/vendor/angular-scenario/angular-scenario.js'
      'app/vendor/angular-**/angular-*.min.js'
    ]

    autoWatch : true

    frameworks: ['jasmine']

    browsers : ['Chrome']

    plugins : [
      'karma-junit-reporter'
      'karma-chrome-launcher'
      'karma-firefox-launcher'
      'karma-jasmine'
      'karma-coffee-preprocessor'
      'karma-html2js-preprocessor'
    ],

    preprocessors =
      '**/*.coffee': 'coffee'
      '**/*.html': 'html2js'

    junitReporter:
      outputFile: 'test_out/unit.xml'
      suite: 'unit'
