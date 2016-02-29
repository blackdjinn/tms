#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# This is the 'login' shell. It handles user validation, some basic
# game-state queries and handing off to other shells.
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require connection
package require chatshell
package require handler
package require md5crypt

oo::class create loginshell {
   superclass handler
# Variables:
#   db -- Connection to database
#   passquery -- prepared query to fetch password
   constructor {} {
   my variable db
   my variable passquery
      set db [::tdbc::postgres::connection new -user tms -password tms -db tms]
      set passquery [$db prepare {select md5pass from "Users" where "Name" = :username}]
   }
   destructor {
      my variable db
      $db close
   }

   method handoffChat {obj name} {
   # Take the connection 'obj' and connect it to a chatshell using 'name'
   #
   # TODO: this assumes implimentation details that will go away.
   # Eventually, chatrooms will be created dynamically and can be joined.
   global chatroom
      my remove $obj
      $chatroom connect $obj $name
   }

   method handoffGame {obj name} {
   # Take the connection 'obj' and connect it to a gameshell using 'name'
   #
   # TODO: this assumes implimentation details that will go away.
   # Eventually, multiple games may be run on the same server.
   global game
      my remove $obj
      $game connect $obj $name
   }

   method validateuser {type name pass} {
   # Check to be sure there is a record for the user and that the passwords match.
   my variable passquery   
      set username $name
      set results [$passquery execute]
      if {[$results rowcount]==1} {
         puts "Got a row"
         set md5pass [lindex [$results allrows] 0 1]
         if {[string equal $md5pass [::md5crypt::aprcrypt $pass $md5pass]]} {
            puts "Passwords matched"
            return 1
         } {
            puts "Bad password"
            return 0
         }
      } {
         puts "Username invalid"
         return 0
      }
   }

   method showhelp {obj} {
   # display help on commands available in Login shell
      $obj echo "Help: Valid commands:"
      $obj echo "  help                     Print this message"
      $obj echo "  who                      List people connected"
      $obj echo "  quit                     disconnect"
      $obj echo "  chat name password       join global chat as 'name'"
      $obj echo "  connect name password    join global game as 'name'"
      #$obj echo "  create name password     create account 'name' and connect"
   }

   method newconnect {obj} {
   # Handle incoming connection to server.
   # Displays help.
      next $obj
      my showhelp $obj
   }

   method parse {obj str} {
   # Parse a line of user input.
      set firstword ""
      scan $str "%s" firstword
      switch -nocase $firstword {
         who {
            # TODO: this only queries the single global chatroom. Change.
            # TODO; Should query game(s), etc.
            global chatroom
            $chatroom showwho $obj
         }
         quit {
            $obj echo "Goodbye."
            my disconnect $obj
         }
         chat {
         # TODO: Multiple rooms... do it...
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
         # TODO: Multiple games too... srsly.
         # TODO: Also, games can have multiple contexts, so 'builder' 'player'
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
# end class defnintion: loginshell
}

package provide loginshell 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
