# Elm Bootstrap [![Travis build Status](https://travis-ci.org/rundis/elm-bootstrap.svg?branch=master)]



Elm Bootstrap is a comprehensive library package for that aims to make it pleasant and reasonably type safe to use the upcoming [Twitter Bootstrap 4](https://v4-alpha.getbootstrap.com/) CSS Framework in your Elm applications.


Twitter Bootstrap is one of the most popular CSS (with som JS) frameworks for building responsive, mobile first web sites. At the time of writing version 4 is in alpha-6 and apparantly the plan is to move into beta fairly soon.
Version 4 is fully embracing flexbox, which will provide much better control and flexibility.


### What's in it for me ?
* A reasonably type safe API for using Bootstrap
* Some boilerplate is being handled for you
* Interactive elements like Navbar, Dropdowns, Accordion, Modal and Tabs
* Horizontally AND vertically center stuff without tearing your hair out




## Documentation
For user documentation, do check out the [Docs Site](http://elm-bootstrap.info/)

The latest api documentation is up on [Elm Package](http://package.elm-lang.org/packages/rundis/elm-bootstrap/latest).


You will also benefit greatly from reading through the relevant [Twitter Bootstrap documentation](#https://v4-alpha.getbootstrap.com/getting-started/introduction/)




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
Twitter Bootstrap is something that I have been using in non-Elm projects quite extensively. I did some research on what was out there for Elm, but couldn't really find anything that was quite as ambitious as I was looking for.

To a large extent Twitter Bootstrap is just a bunch of CSS classes you can apply to appropriate elements. You can easilty do that by just using vanilla Elm Html.
However it's very easy to get class strings wrong, or apply the wrong classes to the wrong elements, or even nest elements in ways that will break the styling.
This package tries to alleviate some of that, by providing a higher degree of type safety.

The API tries to balance the wish for type safety with factors like
- usability
- need for flexibility / escape hatches
- limitations in the type system (and/or just my lack of experience/knowledge about it) ?


Twitter Bootstrap also consists of a few interactive elements. The interactivety is provided through the use of JavaScript. Elm Bootstrap can't have any of that obviously so the package will provide similar interactivety through the use of pure Elm.



>To be completely honest with you the main reason is probably that I really wanted to learn Elm more deeply and what it would take to design a library and an API using it. That journey has just begun, but you got to start somewhere right ?



## Alternatives
- [`elm-bootstrapify`](#http://package.elm-lang.org/packages/JeremyBellows/elm-bootstrapify/latest) - Supports Bootstrap 3, not as extensive but might suit your needs.
- There are a few other bootstrap related libraries, but they haven't been updated to Elm 0.18.
- [`elm-mdl`](https://github.com/debois/elm-mdl) Is of course the most obvious alternative, if you aren't to fuzzed about Bootstrap. It's very impressive and has
been a great source of inspiration for elm-bootstrap.


## Source of inspiration
* [`elm-mdl`](https://github.com/debois/elm-mdl)
* [`elm-sortable-table`](https://github.com/evancz/elm-sortable-table)
* [`elm-dialog`](https://github.com/krisajenkins/elm-dialog)


## Contributing / Collaborating
This is still very much early days and I would greatly appreciate feedback on usability, design and features etc.

There's a bunch of work left to do, especially when it comes to documentation and examples. If anyone is interested in helping out, either by submitting pull requests or maybe even joining me in making this a top-notch and useful package don't hesitate to get in touch. (@mrundberget on the Elm slack btw)


## Stuff TODO
* Ensure responsive behavior is fully supported
* Encourage or automate screen reader support
* Provide a nice API for all the utility classes
* Proper test coverage
* etc...



## Release history
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
