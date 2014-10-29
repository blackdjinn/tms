#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handlers for connections. It includes the basic communication logic.
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection
# package require characters

oo::class create handler {
   constructor {} {
   my variable children
   my variable parent
      set children {}
      set parent [self]
   }
   destructor {
   my variable children
      foreach x $children {close $x}
   }
# Setter Methods
   method parent {obj} {
   my variable parent
      set parent $obj
   }
# Methods.
   method newconnect {newcon} {
   my variable children
      lappend children $newcon
      $newcon parent [self]
   }
   method parse {obj str} {
      # Stub implimentation, just echos.
      $obj echo $str
   }
   method remove {con} {
      my variable children
      set idx [lsearch -exact $children $con]
      set children [lreplace $children $idx $idx]
   }
   method disconnect {con} {
      [self] remove $con
      $con destroy
   }
   method echo {str} {
      my variable children
      foreach c $children {
         $c echo $str
      }
   }
}

oo::class create loginshell {
   superclass handler
   method parse {obj str} {
      set firstword ""
      scan $str "%s" firstword
      switch -nocase $firstword {
         who {}
         quit {
            $obj echo "Goodbye."
            my disconnect $obj
         }
         connect {
            my handoff $obj $name
         }
         help {
            $obj echo "Help: Valid commands:"
            $obj echo "  help           Print this message"
            $obj echo "  who            List people connected"
            $obj echo "  quit           disconnect"
            $obj echo "  connect name   connect as 'name'"
         }
         default {
            $obj echo "Command not understood. Type 'help' for assistance."
         }
      }
   }
}

oo::class create chatshell {
   superclass handler
}

package provide handlers 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
