// Protractor E2E configuration file
exports.config = {
  // The address of a running selenium server.
  // Configure the seleniumAddress with the port from the config file:
  // seleniumAddress: 'http://localhost:<%= port.protractor %>/wd/hub',
  // Configure the seleniumAddress with the port from the environment variable:
  // seleniumAddress: 'http://localhost:<%= process.env.SELENIUM_LAUNCHER_PORT %>/wd/hub',
  // Configure the seleniumAddress with the hub address the environment variable:
  seleniumAddress: '<%= process.env.SELENIUM_HUB %>',

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    'browserName': 'phantomjs'
  },

  // Spec patterns are relative to the current working directly when
  // protractor is called.
  specs: [
    <%= toQuotedString(_.flatten(spec), ',\n    ') %>
    // '../spec/protractor/e2e/**/*.js',
    // '../spec/protractor/e2e/**/*.coffee'
  ],

  // A base URL for your application under test. Calls to protractor.get()
  // with relative paths will be prepended with this.
  baseUrl: 'http://localhost:9001',

  // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    includeStackTrace: false,
    defaultTimeoutInterval: 30000
  },

  // Newer versions of Protractor should be able to use this. Until
  // then, the `require('coffee-script')` statement in the onPrepare
  // handler does this.
  // See: <https://github.com/angular/protractor/issues/38>
  // plugins: [
  //   'protractor-coffee-preprocessor'
  // ]
  onPrepare: function() {
    require('coffee-script');
  }

};
