#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Class definition for 'server' which contains the basic wrapping
# for keeping a server port open and creating clients
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require connection
package require handler
package require tdbc
package require tdbc::postgres

oo::class create server {
# Variables:
#   channel -- logical IO channel for the connection listener
#   port -- local port being listened on
#   active -- We still listening?
#   login -- object we hook incoming connections to. instance of loginshell
   constructor {serverport connecthandler} {
   my variable channel
   my variable port
   my variable active
   my variable login
      set port $serverport
      set login $connecthandler
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
   # called from the 'new connection' event on the listener channel
   my variable login
      set incoming [connection new $chanid $clientaddr $clientport]
      $login newconnect $incoming
      return $incoming
   }
#
}

package provide server 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
