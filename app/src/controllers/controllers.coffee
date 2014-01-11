'use strict'

# # Controllers Module

# Create a new module called *myApp.controllers* to act as a container
# for the application controllers.
myAppControllers = angular.module('myApp.controllers', []);


# ## myApp.manifestController
# 
# *myApp.manifestController* provides the Application's manifest data
# which is retreived via the *myApp.manifestService* object.
myAppControllers.controller 'myApp.manifestController', [
  '$scope'
  'myApp.manifestService'
  ($scope, manifestService) ->
    $scope.manifest = manifestService.getManifest()
]


# ## myApp.staticContentController
# 
# *myApp.staticContentController* provides static content retreived via an
# $http get request.
myAppControllers.controller 'myApp.staticContentController', [
  '$scope'
  '$routeParams'
  '$http'
  ($scope, $routeParams, $http) ->

    # The *$routeProvider* route path specified an optional named group 
    # parameter, *`url`*. When available use that value for the Url, otherwise
    # default to `README.md`.
    url = $routeParams.url ? 'assets/data/README.md'

    # Request that the $http object fetch the data from the Url, then set the
    # $scope's *`content`* member to the result's data when the Promise
    # resolves.
    $http.get(url).then (result) ->
      $scope.content = result.data
]


# ## myApp.navbarController
# 
# *myApp.navbarController* provides data and handlers for the Navbar.
myAppControllers.controller 'myApp.navbarController', [
  '$scope'
  '$modal'
  'myApp.modalService'
  ($scope, $modal, modalService) ->

    $scope.navCollapsed = false

    # ### openAbout: Open About Modal
    $scope.openAbout = ->

      # Open the About modal
      modalInstance = $modal.open
        templateUrl: 'partials/about.html'
        controller: 'myApp.aboutModalInstanceController'


    # ### openModal: Open Modal
    $scope.openModal = ->
      modalService.openModal(
        headerText: 'Delete Item?'
        bodyText: 'Do you wish to permanently delete this item?'
        dismissButtonText: 'Cancel'
        closeButtonText: 'Delete'
      ,
        keyboard: false
      ).then (result) ->
        console.log result
]


# ## myApp.aboutModalController
# 
# *myApp.navbarController* provides data and handlers for the About modal
# dialog.
myAppControllers.controller 'myApp.aboutModalInstanceController', [
  '$scope'
  '$modalInstance'
  'myApp.manifestService'
  ($scope, $modalInstance, manifestService) ->

    # The About modal needs information about the app, so load the application
    # manifest, and component information.
    $scope.manifest = manifestService.getManifest()
    $scope.assets = manifestService.getAssets()

    $scope.close = (result) ->
      $modalInstance.close result
]
