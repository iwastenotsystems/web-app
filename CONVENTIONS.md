Title:    Git Commit Guidelines  
Keywords: [#Git, #Commit, #Guidelines]  
Authors:  ["[Jon Ruttan](jonruttan@iwastenotsystems.com)", "[ajoslin](https://github.com/ajoslin)"  ]
Original: <https://github.com/ajoslin/conventional-changelog/blob/master/CONVENTIONS.md>  
Date:     2014-01-23  
Revision: 2 (2014-03-22)  


# Git Commit Guidelines

These rules are adopted from the [AngularJS commit conventions].

[AngularJS commit conventions]: https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/


## Goals

  - allow the generation of `CHANGELOG.md` by script
  - allow `git bisect` to selectively ignore commits
  - provide better information when browsing the history


## Message Format

Each commit message consists of a *header*, a *body* and a *footer*. The header has a special format that includes the *type*, a *scope* and a *subject*. The body, and the footer are both optional.

#### Template

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

#### Examples

```
feat(ruler): add inches as well as centimeters
```

```
fix(protractor): fix 90 degrees counting as 91 degrees
```

```
refactor(pencil): use graphite instead of lead

Graphite is a much more available resource than lead, so we use it to lower the price.
```

```
fix(pen): use blue ink instead of red ink

BREAKING CHANGE: Pen now uses blue ink instead of red.

To migrate, change your code from the following:

`pen.draw('blue')`

To:

`pen.draw('red')`
```

Lines in the commit message should not exceed 100 characters. This convention makes the message easy to read on [GitHub] as well as in various *git* tools.

[GitHub]: http://github.com


### Type

The *type* should be one of the following (only **feat** and **fix** show up in the *Changelog*):

  - **feat**: *A new feature*
  - **fix**: *A bug fix*
  - **docs**: *Documentation only changes*
  - **style**: *Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)*
  - **refactor**: *A code change that neither fixes a bug or adds a feature*
  - **test**: *Adding missing tests*
  - **chore**: *Changes to the build process or auxiliary tools and libraries such as documentation generation*


### Scope

The scope could be anything specifying place of the commit change. For example *`$location`*, *`$browser`*, *`$compile`*, *`$rootScope`*, *`ngHref`*, *`ngClick`*, *`ngView`*, *etc*...


### Subject

The subject contains a succinct description of the change:

  - use the imperative, present tense: "change" not "changed" nor "changes"
  - don't capitalize the first letter
  - no period (.) at the end


### Body 

  - just as in the <subject>, use the imperative, present tense: “change” not “changed” nor “changes”
  - include the motivation for the change, and the contrasts with previous behavior


### Footer


#### Breaking Changes

All breaking changes have to be mentioned in the footer with the description, justification, and migration notes for the change.

```
BREAKING CHANGE: isolate scope bindings definition has changed and
    the inject option for the directive controller injection was removed.
    
    To migrate the code follow the example below:
    
    Before:
    
    scope: {
      myAttr: 'attribute',
      myBind: 'bind',
      myExpression: 'expression',
      myEval: 'evaluate',
      myAccessor: 'accessor'
    }
    
    After:
    
    scope: {
      myAttr: '@',
      myBind: '@',
      myExpression: '&',
      // myEval - usually not useful, but in cases where the expression is assignable, you can use '='
      myAccessor: '=' // in directive's template change myAccessor() to myAccessor
    }
    
    The removed `inject` wasn't generaly useful for directives so there should be no code using it.
```


#### Referencing issues

Closed bugs should be listed on a separate line in the footer prefixed with the `Closes` keyword, like this:

```
Closes #234
```
