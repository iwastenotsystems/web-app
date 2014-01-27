// Protractor E2E configuration file
exports.config = {
  // The address of a running selenium server.
  seleniumAddress: 'http://localhost:4444/wd/hub',

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    'browserName': 'chrome'
  },

  // Spec patterns are relative to the current working directly when
  // protractor is called.
  specs: [
    '../tests/protractor/e2e/**/*.{coffee,js}'
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
