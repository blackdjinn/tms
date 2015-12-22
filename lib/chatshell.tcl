#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# 'shell' class for the chatroom shell.
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require connection
package require handler
package require character

oo::class create chatchar {
# TODO: flesh this out.
# currently just uses the generic character class.
   superclass character
}

oo::class create chatshell {
# Variables: all inherited.
   superclass handler
   method connect {con name} {
      my variable children
      set found 0
      set tag [$con tag]
      puts "$tag ! Connecting to $name"
      $con echo "Connecting to $name"
      foreach c $children {
         if {[string compare -nocase $name [$c name]]==0} {
            set found $c
            break
            # puts "$tag ! Located existing $name $c"
         }
      }
      if {0 != $found} {
         # puts "$tag ! Adding to $name object"
         $found newconnect $con
      } {
         # puts "$tag ! Creating new chatacter $name"
         my newconnect [chatchar new $con $name]
      }
   }

   method connectinfo {} {
   my variable children
      set outlist {}
      foreach c $children {
         lappend outlist [list [$c name] [$c ctime] [$c atime]]
      }
      return $outlist
   }
   
   method showwho {obj} {
      set now [clock seconds]
      $obj echo [format "%-20s %-30s %-10s" Name: Connected: Idle: ]
puts [my connectinfo]
      foreach {n c a} [concat [join [my connectinfo]]] {
         set connecttime [clock format $c]
         set idletime [clock format [expr {$now-$a}] -format "%T" -timezone UTC]
         $obj echo [format "%-20s %-30s %-10s" $n $connecttime $idletime]
      }
      $obj echo "----- Done"
   }
   
   method parse {obj str} {
      switch $str {
         WHO {
            my showwho $obj
         }
         QUIT {
            $obj echo "Goodbye!"
            my disconnect $obj
         }
         default { my broadcast "[$obj name] : $str" }
      }
   }
# end class definition: chatshell
}

package provide chatshell 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
