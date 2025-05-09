# nc-chat

A simple chat over netcat(1).

You can have an 'advanced' chatting environment, cosisting of multiple worlds,
where you can hang out with your friends.

## Features

* Lightweight
* Multiple worlds
* Multiple rooms per world
* Very customisable
* Interactive objects in your rooms
* Commands separated into categories

## Running

Nc-chat uses
[CHICKEN Scheme](https://call-cc.org/),
which you need to have installed.

```
sudo chicken-install csm tcp-server srfi-1 srfi-13
cd src
csm -program nc-chat 
```

## Config

Nc-chat executable should nave a `data/` directory next to itself.
In this directory, you can have as much scheme files in as many nested 
directories as you want.
They will all be sourced.
Sourced are files ending in `.scm`, `.ss` and `.so`, if you want to include
some compiled Scheme.
These Scheme files are used to configure your server.

By default, there is a minimal testing example.

The configuration works by defining symbols, that are then exported to the
running process.

The following symbols are looked for:

#### port

The TCP port the server should listen on.

```
(define port 9999)
```

#### worlds

A list of symbols, under which are all the existing worlds.
Each symbol must have a world defined to it.
The first one is the default one users are connected to.

```
(define worlds '(hub hall))
```

#### motd
A string that will be displayed to users upon joining.
```
(define motd
"Welcome to my server
Don't forget to get some /help!
-------------------------------
")
```

#### individual worlds
This is the base of your server.
Each symbol defined in `worlds` must have a world definition associated with it.
Worlds are stored as a simple list-based data structure, where first item in a
list works as it's key and the rest as it's contents.
Example world might look like this:

```
(import (chicken time posix))

(define hub
  `((description "The main central area of this place")
    (places
      (base
        (welcome "Welcome to the HUB!")
        (interactives
          (clock
            "An old clock hangs on the wall"
            ,(lambda (args u) (string-append
                               "it's "
                               (seconds->string)))))
        (pathways
          (gallery
            "This door leads to the gallery..."
            gallery)))

      (gallery
        (welcome "Welcome to the gallery!")
        (interactives)
        (pathways
          (main-area
            "This door leads to the main area."
            base))))))
```

Each world has a `description` and `places`.
There can be as many places as you want.
The first place defined in a world is used as it's default one.

Each place has a welcome message, which will be shown to the user when they
enter it.
After that, it has `interactives`.
Interactives are objects in that place that the user can interact with.
Each interactive should have two elements.
First one is it's description and the second one is the text that will the
user see upon interaction.

Pathways are ways to move from one place to another.
There can be as much pathways in a place as you want.
Each pathway has it's description and name of the place it leads to.
It's key and destination don't have to be the same, but they can be.

Keys in interactives and pathways are used by users to refer to them, so make
them easy to write.

#### The fancy

Any string in World can also be a function that returns the string.
This function will be called every time the string is needed.

Special case are functions in the interaction part of interactives.
These functions take two arguments: any arguments passed after the command,
represented as a list of strings, and the user who interacted with it.

To make something of it, you should import some functions from the server.

```
(define (get-access brd-server brd-world brd-place
                    usr? usr-name set-usr-name!
                    usr-color set-usr-color!
                    usr-description set-usr-description!)

  (set! broadcast-server brd-server)
  (set! broadcast-world brd-world)
  (set! broadcast-place brd-place)

  (set! user? usr?)
  (set! user-name usr-name)
  (set! set-user-name! set-usr-name!)
  (set! set-user-color! set-usr-color!)
  (set! set-user-description! set-usr-description!))
```

This piece of code gives you access to few useful functions.
Broadcasts are the simple way to write a message to multiple users.
They are separated into broadcast domains: `server`, `world` and `place`.

They take first user in whose world or place to broadcast.
All broadcasts can also take the optional named argument `exception`, which if
given `#t`, will not message the user who interacted.

**Note that function should always return a string.
If you don't want to message anything else, just return `""`.**
