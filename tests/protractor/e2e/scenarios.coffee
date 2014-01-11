'use strict';

# http://docs.angularjs.org/guide/dev_guide.e2e-testing

describe 'MyApp', ->

  it 'should redirect index.html to index.html#/', ->
    browser.get 'app/index.html'
    expect(browser.getCurrentUrl()).toMatch /\/jon$/


  # describe 'Phone list view', ->

  #   beforeEach ->
  #     browser.get 'app/index.html#/phones'


  #   it 'should display all entries when nothing typed in search box', ->
  #     browser.findElements(global.by.repeater 'phone in phones').then (arr) ->
  #       expect(arr.length).toEqual 20


  #   it 'should filter the phone list as user types "nexus" into the search box', ->
  #     element(global.by.model 'query').sendKeys 'nexus'
  #     browser.findElements(global.by.repeater 'phone in phones').then (arr) ->
  #       expect(arr.length).toEqual 1


  #   it 'should filter the phone list as user types "motorola" into the search box', ->
  #     element(global.by.model('query')).sendKeys 'motorola'
  #     browser.findElements(global.by.repeater 'phone in phones').then (arr) ->
  #       expect(arr.length).toEqual 8


  #   it 'should be possible to control phone order via the drop down select box', ->
  #     # narrow the dataset to make the test assertions shorter
  #     element(global.by.model 'query').sendKeys 'tablet' 

  #     browser.findElements(global.by.repeater('phone in phones').column 'name').then (arr) ->
  #         expect(arr[0].getText()).toEqual "Motorola XOOM\u2122 with Wi-Fi"
  #         expect(arr[1].getText()).toEqual "MOTOROLA XOOM\u2122"

  #     browser.findElement(global.by.model 'query').click()
  #     browser.findElement(global.by.css 'select option[value="name"]').click()

  #     browser.findElements(global.by.repeater('phone in phones').column 'name').then (arr) ->
  #         expect(arr[0].getText()).toEqual "MOTOROLA XOOM\u2122"
  #         expect(arr[1].getText()).toEqual "Motorola XOOM\u2122 with Wi-Fi"


  #   it 'should render phone specific links', ->
  #     element(global.by.model('query')).sendKeys 'nexus'
  #     browser.findElement(global.by.css '.phones li a').click()
  #     expect(browser.getCurrentUrl()).toMatch /\/phones\/nexus-s$/


  # describe 'Phone detail view', ->

  #   beforeEach ->
  #     browser.get 'app/index.html#/phones/nexus-s'


  #   it 'should display nexus-s page', ->
  #     expect(element(global.by.binding('phone.name')).getText()).toBe 'Nexus S'


  #   it 'should display the first phone image as the main phone image', ->
  #     expect(element(global.by.css('img.phone.active')).getAttribute 'src')
  #       .toMatch /img\/phones\/nexus-s.0.jpg$/


  #   it 'should swap main image if a thumbnail image is clicked on', ->
  #     browser.findElement(global.by.css '.phone-thumbs li:nth-child(3) img').click()
  #     expect(element(global.by.css 'img.phone.active').getAttribute 'src')
  #       .toMatch /img\/phones\/nexus-s.2.jpg$/ 

  #     browser.findElement(global.by.css '.phone-thumbs li:nth-child(1) img').click()
  #     expect(element(global.by.css 'img.phone.active').getAttribute 'src')
  #       .toMatch /img\/phones\/nexus-s.0.jpg$/
