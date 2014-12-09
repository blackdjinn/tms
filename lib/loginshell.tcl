#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handlers for connections. It includes the basic communication logic.
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection
package require chatshell
package require handler

oo::class create loginshell {
   superclass handler
   method handoff {obj name} {
   # TODO: this assumes implimentation details that will go away.
   # Eventually, chatrooms will be created dynamically and can be joined.
   global chatroom
      set name ""
      set pass ""
      set connect ""
      scan $str "%s %s %s" connect name pass
      if {my validateuser $name $pass} {
         my remove $obj
         $chatroom connect $obj $name
      } {
         $obj echo "Error: Username and/or password invalid."
      }
   }
   method validateuser {name pass} {
      # TODO stub, just returns 'true'
      return 1
   }
   method showhelp {obj} {
      $obj echo "Help: Valid commands:"
      $obj echo "  help                     Print this message"
      $obj echo "  who                      List people connected"
      $obj echo "  quit                     disconnect"
      $obj echo "  connect name password    connect as 'name'"
      #$obj echo "  create name password     create account 'name' and connect"
   }
   method newconnect {obj} {
      next $obj
      my showhelp $obj
   }
   method parse {obj str} {
      set firstword ""
      scan $str "%s" firstword
      switch -nocase $firstword {
         who {
            global chatroom
            $chatroom showwho $obj
         }
         quit {
            $obj echo "Goodbye."
            my disconnect $obj
         }
         connect {
            my handoff $obj $str
         }
         create {
            my createaccount $obj $str
         }
         help {
            my showhelp $obj
         }
         default {
            $obj echo "Command not understood. Type 'help' for assistance."
         }
      }
   }
}
package provide loginshell 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
