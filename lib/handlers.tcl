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

oo::class create handler {
   constructor {} {
   my variable channels
   my variable owner
      set channels {}
      set owner [self]
   }
   destructor {
   my variable channels
      foreach x $channels {close $x}
   }
# Setter Methods
   method owner {obj} {
   my variable owner
      set owner $obj
   }
# Methods.
   method newconnect {newcon} {
   my variable channels
      lappend channels $newcon
      $newcon owner [self]
   }
   method parse {obj str} {
      # Stub implimentation, just echos.
      $obj echo $str
   }
}

oo::class create loginshell {
   superclass handler
}

package provide handlers 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
