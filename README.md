# Elm Bootstrap [![Travis build Status](https://travis-ci.org/rundis/elm-bootstrap.svg?branch=master)]



Elm Bootstrap is a comprehensive library package that aims to make it pleasant and reasonably type safe to use [Twitter Bootstrap 4](https://getbootstrap.com/) CSS Framework in Elm applications.


Twitter Bootstrap is one of the most popular CSS (with some JS) frameworks for building responsive, mobile first web sites. Version 4 is fully embracing flexbox, which provides much better control and flexibility.


### What's in it for me?
* A reasonably type safe API for using Bootstrap
* Some boilerplate is being handled for you
* Interactive elements like Navbar, Dropdowns, Accordion, Modal, Popups, Dismissable Alerts, Tabs and Carousel
* Horizontally AND vertically center stuff without tearing your hair out




## Documentation
* User documentation - Check out the [Docs Site](http://elm-bootstrap.info/). If need/prefer https
you'll need to go [here](https://elm-bootstrap.surge.sh/).
* API documentation - is up on [Elm Package](http://package.elm-lang.org/packages/rundis/elm-bootstrap/latest).
* It also helps to read through the relevant [Twitter Bootstrap documentation](https://getbootstrap.com/docs/4.0/getting-started/introduction/).


## Getting started
* Add `rundis/elm-bootstrap` to your `elm-package.json`
* Start simple by using elm-reactor


```elm

module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid


view : Model -> Html Msg
view model =
    Grid.container []         -- Responsive fixed width container
        [ CDN.stylesheet      -- Inlined Bootstrap CSS for use with reactor
        , navbar model        -- Interactive and responsive menu
        , mainContent model
        ]


-- ... etc


```



## Raison D'être
Twitter Bootstrap is something that I have been using in non-Elm projects extensively.
I researched what was out there for Elm, but couldn't find anything that was quite as ambitious as I was looking for.

To a large extent, Twitter Bootstrap is just a bunch of CSS classes that can be applied to appropriate elements.
Though Bootstrap can be used with just the vanilla Elm HTML library, it is very easy to get class strings wrong, apply the wrong classes to the wrong elements, or even nest elements in ways that will break the styling.
This package aims to alleviate these issues by providing a higher degree of type safety.

This API tries to balance the wish for type safety with factors like
- usability
- need for flexibility / escape hatches
- limitations in the type system (and/or just my lack of experience/knowledge about it)?


Twitter Bootstrap also consists of a few interactive elements. The interactivety is provided through the use of JavaScript. Elm Bootstrap can't have any of that obviously so the package will provide similar interactivity through the use of pure Elm.



>To be completely honest, the main reason I created this was probably to learn Elm more deeply and to see what it would take to design a library and an API using it. You got to start somewhere right?



## Alternatives
- [`elm-bootstrapify`](#http://package.elm-lang.org/packages/JeremyBellows/elm-bootstrapify/latest) - Supports Bootstrap 3, not as extensive but might suit your needs.
- There are a few other Bootstrap related libraries, but they haven't been updated to Elm 0.18.
- [`elm-mdl`](https://github.com/debois/elm-mdl) is of course the most obvious alternative, if you aren't fond of Bootstrap. It's very impressive and has been a great source of inspiration for elm-bootstrap.


## Source of inspiration
* [`elm-mdl`](https://github.com/debois/elm-mdl)
* [`elm-sortable-table`](https://github.com/evancz/elm-sortable-table)
* [`elm-dialog`](https://github.com/krisajenkins/elm-dialog)


## Contributing / Collaborating
This package is still in its early stages and I would greatly appreciate feedback on usability, design, features, etc.

There's a bunch of work left to do, especially when it comes to documentation and examples. If anyone is interested in helping out, either by submitting pull requests or maybe even joining me in making this a top-notch and useful package, don't hesitate to get in touch. (@mrundberget on the Elm slack btw)


## Stuff TODO
* Ensure responsive behavior is fully supported
* Encourage or automate screen reader support
* Provide a nice API for all the utility classes
* Proper test coverage
* etc...



## Release history
* Going forward check out the [GitHub releases](https://github.com/rundis/elm-bootstrap/releases)
* 5.0.0 **Elm 0.19 Upgrade.** Contains a few breaking changes. Please consult release notes on the releases tab on GitHub. No further maintenance is planned for an 0.18 compatible version.

* 4.0.0 Updated to support Twitter Bootstrap 4.0 release version
  * **Breaking changes** - There's quite a few breaking changes. Please consult `elm-package diff` for details. For a large part the breaking changes are caused by major changes from Twitter Bootstrap Alpha 6 to Twitter Bootstrap 4 release. Since it was going to be breaking changes regardless, we took the liberty of refactoring some modules to improve the API as well.
  * **New feature**: Support breadcrumb
  * **New feature**: Added Border, Flex, Size, Spacing and Display modules (under Bootstrap.Utilities). They contain a bunch a functions for creating handy TWBS classes.
  * **Addition**: Added support for the new color roles in TWBS 4.0 accross a range of modules in elm-bootstrap
  * **Addition**: We now support dismissable alerts (with optional fade out animation).
  * **Addition**: You can now use dropdowns in inputgroups
  * **Addition**: Show accordion with one card open initially when that makes sense.
  * **Addition**: Allow tables to be responsive from given breakpoints.
  * **Subtraction**: Form validation got more tedious as TWBS changed this completely from the alpha release. Hopefully we can come up with improvements in this area to make it better again.
  * _**Special mention**: TWBS changed how labels and checkboxes and radios need to be composed. You'll need to/really should provide an id (`Checkbox.id` or `Radio.id`)_


* 3.0.0
  * **New Feature**: Support for bootstrap carousels (great job by [@folkertdev])
  * **Fix**: Expose fieldset module
  * **Breaking change**: To better support deep linking, the tab module requires ids' for tab items. This will allow automatic url hash change when clicking tabs and you may specify active tab using `customInitialState` providing the tabitem id/hash. Checkout the Tabs module page in https://github.com/rundis/elm-bootstrap.info
  * **Breaking change**: Form selects exposes onChange rather than onInput. (api doc example fixed too)
  * **Breaking change**: Progress bar take float rather than int for progress value
  * **Breaking change**: Progress `attr` removed in favor of `attrs` function
  * **Minor improvement**: Possible to customize progress container with `wrapperAttrs` function
  * **Minor improvement**: Possible to customize dropdown menu with attributes
  * **Minor improvement**: Modal closes when you click on the backdrop (tx to [@farmio])
  * **Fix**: Apply custom attributes for inputgroup (tx to [@CallumJHays])
  * **Api doc fixes**: A long range of grammar/spelling fixes to api docs (tx to [@branjwong])
* 2.0.0
  * **New Feature**: Support for radio buttons and checkbox buttons (tx to [@folkertdev](https://github.com/folkertdev) )
  * **New Feature**: Support for Input groups
  * **New Feature**: Experimental support for Popovers (and tooltips)
  * **Improvment**: Support for HTML.Keyed in Grid, Table and List groups
  * **Minor improvement**: Button onClick shorthand, input placeholder shorthand
  * Varios doc fixes and removal of unused CardBlock type. (Tx everyone that contributed !)
  * Made some progress on adding regression tests
* 1.1.0 - Doc fixes and a grid col class bug
* 1.0.0 - Initial release with most of TWBS core components covered


## License
The BSD 3 Clause License
