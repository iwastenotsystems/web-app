'use strict'

# # Services Module

# Create a new module called *myApp.services* to act as a container
# for the application services.
myAppServices = angular.module('myApp.services', []);


# ## myApp.manifestService
# 
# Retrieves the *Application Manifest* data from the `bower.json` file using
# the AngularJS *`$resource`* RESTful object.
myAppServices.service 'myApp.manifestService', [
  '$resource'
  ($resource) ->
    manifestResource = $resource 'assets/data/bower.json'
    assetsResource = $resource 'assets/assets.json'

    @getManifest = ->
      manifestResource.get()

    @getAssets = ->
      assetsResource.query()
    
    @    
]


# ## myApp.modalService
# 
# Provides a user interaction Modal window using the *`$modal`* service.
# 
# ### Modal example
# ```
# modalService.open().then (result) ->
#   console.dir result
# ```
# 
# ### Static Modal example
# This example additionally demonstrates overriding the modal's default
# *modal data* and *modal options*.
# ```
# modalService.openStatic(
#   headerText: 'Delete Item?'
#   bodyText: 'Do you wish to permanently delete this item?'
#   dismissButtonText: 'Cancel'
#   closeButtonText: 'Delete'
# ,
#   keyboard: false
# ).then (result) ->
#   console.dir result
# ```
# 
myAppServices.service 'myApp.modalService', [
  '$modal'
  ($modal) ->

    # Service-wide modal scope data.
    modalData =
      headerText: 'Proceed?'
      bodyText: 'Perform this action?'
      dismissButtonText: 'Close'
      closeButtonText: 'OK'

    # Service-wide modal options.
    modalOptions = 
      backdrop: true
      keyboard: true
      modalFade: true
      templateUrl: 'partials/modal.html'

    # ### Method: openStatic
    # 
    # Open a *static* modal window -- window is **not** closed when clicking
    # outside of the modal window.
    @openModal = (customModalData = {}, customModalOptions = {}) ->
      customModalOptions.backdrop = 'static'
      @open customModalData, customModalOptions

    # ### Methdod: open
    # 
    # Open a modal window.
    @open = (customModalData = {}, customModalOptions = {}) ->

      # Create temp objects to work with since we're in a Singeton service.
      tempModalData = {}
      tempModalOptions = {}

      # Map $scope custom properties to defaults defined in the service.
      angular.extend tempModalData, modalData, customModalData

      # Map angular-ui modal custom options to modal options defined in
      # the service.
      angular.extend tempModalOptions, modalOptions, customModalOptions

      # Construct a controller to handle the modal instance in the event that
      # one hasn't been provided.
      if not tempModalOptions.controller
        tempModalOptions.controller = ($scope, $modalInstance) ->

          # Extend the modal instance controller's *`$scope`* with *modal data*.
          angular.extend $scope, tempModalData

          # Scope method to close modal instance when action button is pressed.
          $scope.close = (result) ->
            $modalInstance.close result

          # Scope method to dismiss modal instance when 
          $scope.dismiss = (reason) ->
            $modalInstance.dismiss reason ? 'cancel'

      $modal.open(tempModalOptions).result

    @
]
