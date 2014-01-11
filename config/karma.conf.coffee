module.exports = (config) ->
  config.set
    basePath : '../'

    files : [
      'app/bower_components/angular/angular.js'
      'app/bower_components/angular-**/angular-*.js'
      'app/bower_components/angular-ui-bootstrap-bower/ui-bootstrap-tpls.js'
      'app/bower_components/marked/lib/marked.js'
      'app/bower_components/js-yaml/js-yaml.js'
      'app/dist/*.js'
      'app/dist/**/*.js'
      'tests/unit/**/*.coffee'
    ]

    exclude : [
      'app/bower_components/angular-loader/angular-loader.js'
      'app/bower_components/angular-scenario/angular-scenario.js'
      'app/bower_components/angular-**/angular-*.min.js'
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
