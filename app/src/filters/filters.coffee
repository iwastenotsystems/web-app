'use strict'

# # Filters

# Create a new module called *`myApp.filters`* which will act as a container
# for the application filters.
myAppFilters = angular.module('myApp.filters', []);

# ## Markdown Filter
# Create a new sanitising *Markdown* filter called *`markdown`*.
# The filter is based on the *[Marked]* Markdown parser and compiler module.
# 
# [Marked]: https://github.com/chjj/marked
myAppFilters.filter 'markdown', [
  '$sce'
  ($sce) ->
    # Set default options for the Marked converter object.
    marked.setOptions
      gfm: true
      tables: true
      breaks: true
      pedantic: false
      sanitize: true
      smartLists: true
      smartypants: true

    (text) ->
      # Leave early if there is no text
      return if typeof text is 'undefined'

      # Metadata starts at the beginning of text and extends until the first
      # empty line, so fetch that block of text.
      results = text.match /^[\s\S]*?\n\s*\n/m
      if results isnt null and results[0] isnt text

        # Try to parse the block of text as YAML.
        try
          meta = YAML.parse results[0]

          # If the YAML parser didn't raise any errors, then check the results
          # to make sure they're sane.
          for key, value of meta
            if key is null or value is null
              meta = {}
              break

          # Since everything has checked out, strip the metadata from the text.
          text = text[results[0].length...] if Object.keys(meta).length isnt 0

        # On the event that an error is raised, clear the metadata
        catch e
            meta = {}


      # Return the converted text, after informing the *Strict Contextual
      # Escaping* service the Html is trusted and is safe to be displayed via
      # the *ng-bind-html* directive.
      try
        marked text, (err, content) ->
          throw err if err
          $sce.trustAsHtml content
      catch TypeError
]
