#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# This is the 'login' shell. It handles user validation, some basic
# game-state queries and handing off to other shells.
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection
package require chatshell
package require handler

oo::class create loginshell {
   superclass handler
   method handoffChat {obj name} {
   # TODO: this assumes implimentation details that will go away.
   # Eventually, chatrooms will be created dynamically and can be joined.
   global chatroom
      my remove $obj
      $chatroom connect $obj $name
   }
   method handoffGame {obj name} {
   # TODO: this assumes implimentation details that will go away.
   # Eventually, multiple games may be run on the same server.
   global game
      my remove $obj
      $game connect $obj $name
   }
   method validateuser {type name pass} {
      # TODO stub, just returns 'true'
      return 1
   }
   method showhelp {obj} {
      $obj echo "Help: Valid commands:"
      $obj echo "  help                     Print this message"
      $obj echo "  who                      List people connected"
      $obj echo "  quit                     disconnect"
      $obj echo "  chat name password       join global chat as 'name'"
      $obj echo "  connect name password    join global game as 'name'"
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
            # TODO: this only queries a single global chatroom. Change.
            global chatroom
            $chatroom showwho $obj
         }
         quit {
            $obj echo "Goodbye."
            my disconnect $obj
         }
         chat {
            set name ""
            set pass ""
            set connect ""
            scan $str "%s %s %s" connect name pass
            if {[my validateuser chat $name $pass]} {
               my handoffChat $obj $name
            } {
               $obj echo "Error: Username and/or password invalid."
            }
         }
         connect {
            set name ""
            set pass ""
            set connect ""
            scan $str "%s %s %s" connect name pass
            if {[my validateuser game $name $pass]} {
               my handoffGame $obj $name
            } {
               $obj echo "Error: Username and/or password invalid."
            }
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
