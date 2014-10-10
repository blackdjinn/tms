#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Class definition for 'server' which contains the basic wrapping
# for keeping a server port open and creating clients
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection
package require handlers

oo::class create server {
   constructor {serverport connecthandler} {
      my variable channel
      my variable port
      my variable active
      my variable handler
      set port $serverport
      set handler $connecthandler
      set active True
      set channel [socket -server [list [self] newconnect] $port]
      puts "Server up. Listening on $port"
   }
   destructor {
      my variable channel
      close $channel
   }
# Methods.
   method newconnect {chanid clientaddr clientport} {
      my variable handler
      set incoming [connection new $chanid $clientaddr $clientport]
      eval [list $handler newconnect $incoming]
      return $incoming
   }
}
package provide server 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
