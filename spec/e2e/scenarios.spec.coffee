'use strict';

# http://docs.angularjs.org/guide/dev_guide.e2e-testing

describe 'MyApp', ->

  it 'should redirect index.html to index.html#/', ->
    browser.get 'index.html'
    expect(browser.getCurrentUrl()).toMatch /\/index.html$/


  describe 'About page', ->

    beforeEach ->
      browser.get 'index.html'
      browser.findElement(global.by.linkText 'About').click()

    # it 'should display an "About" modal', ->
    #   expect(browser.findElement('div.modal-header h?').getText()).toMatch
    #     '^About'


