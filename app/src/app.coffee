'use strict'

# App Module

app = angular.module 'myApp', [
  'ui.bootstrap'
  'ngAnimate'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'templates-app'
  'myApp.controllers'
  'myApp.services'
  'myApp.filters'
]

# Configure routes and associate them with a view, and a controller.
app.config ($routeProvider) ->
  $routeProvider
    .when('/:url?',
      controller: 'myApp.staticContentController'
      templateUrl: 'partials/content.tpl.html'
    )
    .when('/options',
      controller: 'OptionsController'
      templateUrl: 'partials/options.tpl.html'
    )
    #.otherwise(redirectTo: '/')
