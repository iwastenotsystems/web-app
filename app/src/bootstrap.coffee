'use strict'

# # Bootstrap Module
#
# Bootstraps Angular onto the *`window.document`* node

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
