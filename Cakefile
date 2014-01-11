# # web-app Cakefile
# 
# The main Cakefile for the web-app project.
# 
# It comes baked in with at least 5 tasks:
#
# * build - compiles your src directory to your lib directory
# * watch - watches any changes in your src directory and automatically compiles to the lib directory
# * test  - runs mocha test framework, you can edit this task to use your favorite test framework
# * docs  - generates annotated documentation using docco
# * clean - clean generated .js files


# ## Initilisation
# 
fs      = require 'fs-extra'
path    = require 'path'
{print} = require 'util'
{spawn, exec} = require 'child_process'
#_ = require 'underscore'
kckr    = require 'kckr'

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null


# Add local `node_modules/bin` directories to the the PATH environment variable.
# Wrap it in a closure to avoid polluting the top-level namespace.
do ->
  for dir in fs.readdirSync 'node_modules'
    dir = "node_modules/#{dir}/bin"
    process.env.PATH += ":#{dir}" if fs.existsSync dir


# ## Configuration
# 

# ANSI Terminal Colors
bold = red = green = reset = ''
unless process.env.NODE_DISABLE_COLORS
  bold  = '\x1B[0;1m'
  red   = '\x1B[0;31m'
  green = '\x1B[0;32m'
  reset = '\x1B[0m'

# The *Source* and *Distribution* paths
paths = 
  source: 'app/src'
  dist: 'dist/master'
  lib: 'lib'
  assets: 'assets/data'


# ## Cakefile Options
#

# ## *-p, --port, web server port*
#
# Specify a port for the local web server to use. 
#
# <small>Usage</small>
#
# ```
# cake -p 8000
# cake --port 8000
# ```
option '-p', '--port [PORT]', 'web server port (default: 8000)'

# ## *-v, --verbose, verbose output*
#
# Output extra information. 
#
# <small>Usage</small>
#
# ```
# cake -v build
# cake --verbose build
# ```
option '-v', '--verbose', 'verbose output'

# ## *-w, --watch, watch source for changes*
#
# Watch source for changes and re-trigger task. 
#
# <small>Usage</small>
#
# ```
# cake -w build
# cake --watch build
# ```
option '-w', '--watch', 'watch source'



# ## Cakefile Tasks
#

# ### *build*
#
# Builds Source
#
# <small>Usage</small>
#
# ```
# cake build
# ```
task 'build', 'compile source', (options) -> clean options, (options) -> build options, -> log ":)", green

# ### *watch*
#
# Builds your source whenever it changes
#
# <small>Usage</small>
#
# ```
# cake watch
# ```
task 'watch', 'compile and watch', -> build true, -> log ":-)", green

# ### *clean*
#
# Cleans up generated js files
#
# <small>Usage</small>
#
# ```
# cake clean
# ```
task 'clean', 'clean generated files', -> clean -> log ";)", green

# ### *test*
#
# Runs your test suite.
#
# <small>Usage</small>
#
# ```
# cake test
# ```
task 'test', 'run tests', -> build -> mocha -> log ":)", green

# ### *test-unit*
#
# Runs your unit test suite.
#
# <small>Usage</small>
#
# ```
# cake test-unit
# ```
task 'test-unit', 'run unit tests', -> build -> karma -> log ":)", green

# ### *test-e2e*
#
# Runs your end2end test suite.
#
# <small>Usage</small>
#
# ```
# cake test-e2e
# ```
task 'test-e2e', 'run e2e tests', -> build -> protractor -> log ":)", green

# ### *serve*
#
# Start web server on port 8000.
#
# <small>Usage</small>
#
# ```
# cake serve
# ```
task 'serve', 'run web server', (options) -> serve options, -> log ":O", green

# ### *webdrvr*
#
# Start Selenium WebBriver server for End-to-End (e2e) tests.
#
# <small>Usage</small>
#
# ```
# cake webdrvr
# ```
task 'webdrvr', 'run web driver', -> webdrvr -> log ":|", green

task 'hound', 'hound', -> hound -> log ':|', green

task 'watch2', 'watch2', -> watch2 -> log ':|', green


# ## Internal Functions
#

isDirectory = (file) ->
  try
    fs.statSync(file).isDirectory()
  catch err
    false


# ### *walk* 
#
# **given** string as path which represents a directory in relation to local directory
# **and** callback as done in the form of (err, source, base)
# **then** recurse through directory and issue callback on each file
#
# Examples
#
# ``` coffeescript
# walk 'src', (err, results) -> console.log results
# ```
walk = (paths, callback, base) ->
  if typeof paths is 'object'
    walk dir, callback, base ? dir for dir in paths
    return

  if isDirectory paths
    fs.readdir paths, (err, list) ->
      return callback err if err
      walk "#{paths}#{path.sep}#{dir}", callback, base for dir in list
  else
    callback null, paths, base ? paths
        

# ### *log* 
# 
# **given** string as a message
# **and** string as a color
# **and** optional string as an explanation
# **then** builds a statement and logs to console.
# 
log = (message, color, explanation) -> console.log color + message + reset + ' ' + (explanation or '')

# ### *launch*
#
# **given** string as a cmd
# **and** optional array and option flags
# **and** optional callback
# **then** spawn cmd with options
# **and** pipe to process stdout and stderr respectively
# **and** on child process exit emit callback if set and status is 0
launch = (cmd, options=[], callback) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback?() if status is 0


# ### *build*
#
# **given** optional boolean as watch
# **and** optional function as callback
# **then** invoke launch passing coffee command
# **and** defaulted options to compile src to lib
build_v1 = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-b', '-m', '-o' ]
  #options = options.concat files
  options.push path for name, path of paths
  options.unshift '-w' if watch
  launch 'coffee', options, callback

# ### *unlinkIfCoffeeFile*
#
# **given** string as file
# **and** file ends in '.coffee'
# **then** convert '.coffee' to '.js'
# **and** remove the result
unlinkIfCoffeeFile = (file) ->
  if file.match /\.coffee$/
    fs.unlink file.replace('src','lib').replace(/\.coffee$/, '.js'), ->
    true
  else false

# ### *clean*
#
# **given** optional function as callback
# **then** loop through files variable
# **and** call unlinkIfCoffeeFile on each
clean = (options, callback) ->
  if typeof options is 'function'
    callback = options
    options = {}

  fs.remove paths.dist, (err) ->
    return console.error err if err
    callback options


# ### *moduleExists*
#
# **given** name for module
# **when** trying to require module
# **and** not found
# **then* print not found message with install helper in red
# **and* return false if not found
moduleExists = (name) ->
  try 
    require name 
  catch err 
    log "#{name} required: npm install #{name}", red
    false


# ### *mocha*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing mocha command
mocha = (options, callback) ->
  #if moduleExists('mocha')
  if typeof options is 'function'
    callback = options
    options = []
  # add coffee directive
  options.push '--compilers'
  options.push 'coffee:coffee-script'
  
  launch 'mocha', options, callback

# ### *karma*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing karma command
karma = (options, callback) ->
  #if moduleExists('karma')
  if typeof options is 'function'
    callback = options
    options = []
  options.push 'start'
  # add config file
  options.push 'config/karma.conf.coffee'
  
  launch 'karma', options, callback

# ### *protractor*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing protractor command
protractor = (options, callback) ->
  #if moduleExists('mocha')
  if typeof options is 'function'
    callback = options
    options = []
  # add config file
  options.push 'config/protractor-e2e.conf.js'
  
  launch 'protractor', options, callback

# ### *docco*
#
# **given** optional function as callback
# **then** invoke launch passing docco command
docco = (callback) ->
  #if moduleExists('docco')
  walk paths.src, (err, files) -> launch 'docco', files, callback

# ### *serve*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing serve command
serve = (options, callback) ->
  if typeof options is 'function'
    callback = options
    options = {}

  args = ['-p', options.port ? '8000']
  launch 'serve', args, callback

# ### *webdrvr*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing webdrvr command
webdrvr = (options, callback) ->
  if typeof options is 'function'
    callback = options
    options = {}

  args = []
  launch 'webdrvr', args, callback


buildActions =
  'app': (source, base, callback) ->
    prefix = path.normalize "#{base}#{path.sep}"      

    if source[prefix.length..].match /^src/
      # TODO: Normalise `path.sep` in *`source`*.

      dir = path.dirname source
      console.log "coffee: #{source} -> #{paths.dist}/#{paths.lib}#{dir[prefix.length..]}"
      options = [
        '--compile'
        '--bare'
        '--map'
        '--output'
        "#{paths.dist}/#{paths.lib}#{dir[paths.source.length..]}"
        source
      ]
      launch 'coffee', options, launch 'docco', [source], callback

    else
      console.log "copy: #{source} -> #{paths.dist}/#{path.dirname(source)[prefix.length..]}"
      fs.copy source, "#{paths.dist}/#{source[prefix.length..]}", (err) ->
        console.error err if err

  'README.md': (source, base, callback) ->
    console.log "copy: #{source} -> #{paths.dist}/#{paths.assets}"
    fs.copy source, "#{paths.dist}/#{paths.assets}/#{source}", (err) ->
      console.error err if err

  'Cakefile': (source, base, callback) ->
    launch 'docco', [source], callback


build = (options, callback) ->
  if typeof options is 'function'
    callback = options
    options = {}

  walk Object.keys(buildActions), (err, source, base) ->
    return console.error err if err

    for key, fn of buildActions
      if source.match new RegExp "^#{key}"
        fn source, key, callback
        break
  
  if options.watch?
    new kckr.Kckr
      sources: Object.keys buildActions
      verbose: true
      callback: (source, base) ->
        buildActions[base] source, base, callback
