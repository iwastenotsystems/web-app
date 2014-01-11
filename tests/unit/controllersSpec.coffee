'use strict'

# jasmine specs for controllers go here

describe 'myApp.controllers', ->

  beforeEach ->
    @addMatchers 
      toEqualData: (expected) ->
        angular.equals @actual, expected

  beforeEach module('myApp')
  beforeEach module('myApp.services')

  describe 'myApp.manifestController', ->
    scope = ctrl = $httpBackend = undefined    

    manifestData = 
      name: 'single-page-app'
      version: '0.0.0'
      authors: ['Jon Ruttan <jonruttan@gmail.com>']
      description: 'A Coffescript Single-Page-Application boilerplate based on AngularJS and Twitter Bootstrap'

    beforeEach inject (_$httpBackend_, $rootScope, $controller) ->
      $httpBackend = _$httpBackend_
      $httpBackend.expectGET('bower.json')
        .respond manifestData

      scope = $rootScope.$new()
      ctrl = $controller 'myApp.manifestController', {$scope: scope}


    it 'should create *manifest* model with data fetched from xhr', inject ->
      expect(scope.manifest).toEqualData {}
      $httpBackend.flush()

      expect(scope.manifest).toEqualData manifestData


  describe 'myApp.navbarController', ->

