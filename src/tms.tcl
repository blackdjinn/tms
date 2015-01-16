#!/usr/bin/tclsh
# TMS -- Tcl MU Server
# (C) Copyright 2014 Ryan Davis.
# Released to Creative Commons. See 'Licence.txt'

namespace eval config {
# TODO Replace this with actual file read logic
# Right now, this is by-hand user configuration
   set gamedir "/home/ryan/srv/test"
   set gamename "Test"
   set address *
   set port 6543
   set greeting "files/welcome.txt"
   set chatmotd "files/motd.txt"
   set libdir "/home/ryan/src/tms/lib"
}

#
# End of configuration. Don't change below here.
#
lappend auto_path $::config::libdir
package require TclOO

package require server
package require loginshell
package require chatshell
package require gameshell

set loginhandler [loginshell new]
set chatroom [chatshell new]
set game [gameshell new]
puts "loginobj: $loginhandler chatobj: $chatroom game: $game"

set thisserver [server new $::config::port $loginhandler]
vwait untilQuit
