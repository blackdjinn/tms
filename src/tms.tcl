#!/usr/bin/tclsh
# TMS -- Tcl MU Server
# (C) Copyright 2014, 2015 Ryan Davis.
# Released to Creative Commons. See 'Licence.txt'

namespace eval config {
# TODO Replace this with actual file read logic
# Right now, this is by-hand user configuration
#   set gamedir "/home/ryan/srv/test"
   set gamedir "/home/ryan/src/tms/var/skeleton"
   set gamename "Test"
   set address *
   set port 6543
   set greeting "text/welcome.txt"
   set chatmotd "text/motd.txt"
   set gamemotd "text/motd.txt"
   set libdir "/home/ryan/src/tms/lib"
   # debug level. Bigger is spammier.
   # TODO: bitmask debug settings? Probably a good idea.
   set debug 1
}

#
# End of configuration. Don't change below here.
#

# Spammy safe interpreter debugging info.
# Unless you are debugging the sandboxing, you DO NOT want this.
if {$::config::debug >= 2} { ::safe::setLogCmd puts }

# Set up path for library autoloading. Needed for 'package require'.
lappend auto_path $::config::libdir

# Basic OO package. Should be sourced in by the stuff below, but...
package require TclOO

# Load up the classes needed to start the game.
package require server
package require loginshell
package require chatshell
package require gameshell

# Instantiate...
set loginhandler [loginshell new]
# TODO: These should be created/destroyed as needed or by startup scripts.
# TODO: Right now they create globals.
set chatroom [chatshell new]
set game [gameshell new]

# debug output
puts "loginobj: $loginhandler chatobj: $chatroom game: $game"

# Crete new listener instance and hand connections to $loginhandler
set thisserver [server new $::config::port $loginhandler]

# Start the event loop.
# Run until something sets the global variable 'untilQuit'
vwait untilQuit

# Graceful exit code.
# TODO: Actually write this.
