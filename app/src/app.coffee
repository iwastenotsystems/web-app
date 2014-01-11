'use strict'

# App Module

base = '../bower_components/'
require.config 
  paths:
    'domready': "#{base}requirejs-domready/domReady"
    'angular': "#{base}angular/angular"
    'angular-animate': "#{base}angular-animate/angular-animate"
    'angular-cookies': "#{base}angular-cookies/angular-cookies"
    'angular-loader': "#{base}angular-loader/angular-loader"
    'angular-mocks': "#{base}angular-mocks/angular-mocks"
    'angular-resource': "#{base}angular-resource/angular-resource"
    'angular-route': "#{base}angular-route/angular-route"
    'angular-sanitize': "#{base}angular-sanitize/angular-sanitize"
    'angular-scenario': "#{base}angular-scenario/angular-scenario"
    'angular-touch': "#{base}angular-touch/angular-touch"
    'angular-ui-bootstrap-bower': "#{base}angular-ui-bootstrap-bower/ui-bootstrap-tpls"
    'angular-ui-bootstrap3': "#{base}angular-ui-bootstrap3/ui-bootstrap-tpls"
    'bootstrap-bower': "#{base}bootstrap-bower/bower"
    'marked': "#{base}marked/lib/marked"
    'yaml': "../vendor/yaml.js"


app = angular.module 'myApp', [
  'ui.bootstrap'
  'ngAnimate'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'myApp.controllers'
  'myApp.services'
  'myApp.filters'
]

# Configure routes and associate them with a view, and a controller.
app.config ($routeProvider) ->
  $routeProvider
    .when('/:url?',
      controller: 'myApp.staticContentController'
      templateUrl: 'partials/content.html'
    )
    .when('/options',
      controller: 'OptionsController'
      templateUrl: 'partials/options.html'
    )
    #.otherwise(redirectTo: '/')
