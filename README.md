Title:    Web Application Boilerplate  
Subtitle: Using CoffeeScript, AngularJS, Twitter Bootstrap and PhoneGap  
Keywords: [ #CoffeeScript, #AngularJS, #Bootstrap, #PhoneGap, #SinglePageApplication, #SPA, #SPI, #application, #boilerplate ]  
Author:   "[Jon Ruttan](jonruttan@gmail.com)"  
Date:     2013-10-21  
Revision: 1 (2013-10-21)  
License:  "[The MIT License](http://opensource.org/licenses/MIT)"  

# Web Application Boilerplate

An *[AngularJS] and [Bootstrap] application boilerplate* written in [CoffeeScript]. Deploys to web as well as Mobile Devices via [PhoneGap].

[AngularJS]: http://angularjs.org/
[Bootstrap]: http://getbootstrap.com/
[CoffeeScript]: http://coffeescript.org/
[PhoneGap]: http://phonegap.com/

## Requirements

### [Node.js]

> Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

*Node.js* is required as as the underlying *scripting language* for the *CoffeeScript compiler*, the *[Cake] build system* and the *[Bower] package manager*. Node.js uses the *`npm`* package manager to handle module dependencies.

[Node.js]: http://nodejs.org/
[Cake]: http://coffeescript.org/#cake

### [CoffeeScript]

> CoffeeScript is a little language that compiles into JavaScript. Underneath that awkward Java-esque patina, JavaScript has always had a gorgeous heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.

Once Node.js has been installed, CoffeeScript can be installed via the *`npm`* package manager by issuing the following command:

    sudo npm install -g coffeescript


### [Git]

> Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

[Git]: http://git-scm.com/

### [Bower]

> Bower is a package manager for the web. It offers a generic, unopinionated solution to the problem of front-end package management, while exposing the package dependency model via an API that can be consumed by a more opinionated build stack. There are no system wide dependencies, no dependencies are shared between different apps, and the dependency tree is flat.

> Bower runs over Git, and is package-agnostic. A packaged component can be made up of any type of asset, and use any type of transport (e.g., AMD, CommonJS, etc.).

Bower depends on Node and npm. It's installed globally using *`npm`*:

    npm install -g bower

[Bower]: http://bower.io/

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

Move the project's root directory and issue

    cake watch

to have the *`cake`* build tool watch the *src/* directory for changes and issue compile commands to create the corresponding JavaScript code in the *lib/* directory.

---


## Resources

## Images

- [Cog Icon](http://brsev.deviantart.com/)

### Code

- [Coffescript](http://coffeescript.org/)
- [A Cakefile template for coffeescript, docco and mocha](https://github.com/twilson63/cakefile-template)

## License

MarkedReader is released under the MIT license:

> The MIT License
>
> Copyright (c) 2013 [Jonathan Ruttan](jonruttan@gmail.com)
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
