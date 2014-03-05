Title:    Web Application Framework  
Subtitle: Using CoffeeScript, AngularJS, Twitter Bootstrap and PhoneGap  
Keywords: [#CoffeeScript, #AngularJS, #Bootstrap, #PhoneGap, #SinglePageApplication, #SPA, #SPI, #application, #framework]  
Author:   "[Jon Ruttan](jonruttan@iwastenotsystems.com)"  
Date:     2013-10-21  
Revision: 3 (2014-01-15)  
License:  "[The MIT License](http://opensource.org/licenses/MIT)"  

# Web Application Framework

An [AngularJS] and [Bootstrap] *application framework* written in [CoffeeScript]. Task automation is done using [Grunt] and [Grunt plugins], and the [Bower] package manager handles web component dependencies. Deploys to web, and additionally to Mobile Devices via [PhoneGap].

[AngularJS]: http://angularjs.org/
[Bootstrap]: http://getbootstrap.com/
[CoffeeScript]: http://coffeescript.org/
[Grunt]: http://gruntjs.com/
[Grunt plugins]: http://gruntjs.com/plugins/
[Bower]: http://bower.io/
[PhoneGap]: http://phonegap.com/

## Quick Start

First, install [Git] and [Node.js], then in a shell:

```bash
# Clone the *Web App* repository
git clone https://github.com/iwastenotsystems/web-app

# Descend into the `web-app` directory
cd web-app

# Install [Node.js] *Global* dependencies
sudo npm install -g coffee-script grunt-cli bower phantomjs

# Install [Node.js] *Local* dependencies
npm install

# Run *Grunt* *`init`* task to finish the installation.
# Installs *Web* dependencies using *Bower* package manager
grunt init

# Run the *default* task, build the *develop* and *release* versions of the
# web app, build the docs, start a web server and open the *release* version
# in a browser.
grunt
```

## Requirements

### [Node.js]

> Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

Node.js is required as as the underlying scripting language for the CoffeeScript compiler, the [Grunt] build system and the [Bower] package manager. Node.js uses the *`npm`* package manager to handle module dependencies.

[Node.js]: http://nodejs.org/

### [CoffeeScript]

> CoffeeScript is a little language that compiles into JavaScript. Underneath that awkward Java-esque patina, JavaScript has always had a gorgeous heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.

Once Node.js has been installed, CoffeeScript can be installed via the *`npm`* package manager by issuing the following command:

    sudo npm install -g coffee-script

This will put the `coffee` command in your system path, allowing it to be run from any directory.

### [Grunt]

> Grunt: The JavaScript Task Runner. Why use a task runner? In one word: automation. The less work you have to do when performing repetitive tasks like minification, compilation, unit testing, linting, etc, the easier your job becomes. After you've configured it, a task runner can do most of that mundane work for you—and your team—with basically zero effort.

Once Node.js has been installed, Grunt can be installed via the *`npm`* package manager by issuing the following command:

    sudo npm install -g grunt-cli

This will put the `grunt` command in your system path, allowing it to be run from any directory.

### [Git]

> Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

[Git]: http://git-scm.com/

### [Bower]

> Bower is a package manager for the web. It offers a generic, unopinionated solution to the problem of front-end package management, while exposing the package dependency model via an API that can be consumed by a more opinionated build stack. There are no system wide dependencies, no dependencies are shared between different apps, and the dependency tree is flat.

> Bower runs over Git, and is package-agnostic. A packaged component can be made up of any type of asset, and use any type of transport (e.g., AMD, CommonJS, etc.).

Bower depends on Node and npm. It's installed globally using *`npm`*:

    npm install -g bower

This will put the `bower` command in your system path, allowing it to be run from any directory.

### Optional: [PhoneGap]

> PhoneGap is a free and open source framework that allows you to create mobile apps using standardized web APIs for the platforms you care about.

[PhoneGap] is required should you wish to bundle the application up as a mobile application. It can be installed via `npm` and must be installed globally:

    npm install -g phonegap

> Adobe® PhoneGap™ Build allows users to use their own debug server with the Build service.

> \[PhoneGap\] uses a tool called Weinre to enable remote debugging of mobile apps. [^user-debug-server]

    npm -g install weinre

[PhoneGap]: http://phonegap.com/
[Weinre]: http://people.apache.org/~pmuellr/weinre/docs/latest/

[^user-debug-server]: <https://build.phonegap.com/docs/user-debug-server>

---


## Development

Move to the project's root directory and issue:

    grunt develop

to have the *`Grunt`* build tool build the *develop* version of the project, start an internal web server (default port 8001), and watch the *app/* directory for changes, issuing build commands as necessary.


## Release

Move to the project's root directory and issue:

    grunt build

to have the *`Grunt`* build build and test the *develop* version of the project, then build the *release* version and *docs*.


---


## Resources

## Images

- [Cog Icon](http://brsev.deviantart.com/)

### Code

- [Coffescript](http://coffeescript.org/)
- [A Cakefile template for coffeescript, docco and mocha](https://github.com/twilson63/cakefile-template)
