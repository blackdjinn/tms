#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# This is the shell for anything connecte to the game as a character.
# It includes the specialized class for a character connected to this game.
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require connection
package require handler
package require character

oo::class create gamechar {
# Variables:
#   interpreter -- the sandboxed interpreter stapled to this character
   superclass character
   constructor {con charname} {
      my variable interpreter
      set interpreter [::safe::interpCreate -noStatics]
      next $con $charname
   }

   destructor {
      my variable interpreter
      ::safe::interpDelete $interpreter
      next
   }
# Getters
   method interpreter {} {
      # Getter method
      my variable interpreter
      return $interpreter
   }

# Other methods
   method tag {} {
   # return human readable description string.
      my variable name
      return "char: $name"
   }
# end class definition: gamechar
}

oo::class create gameshell {
# Variables: All inherited.
   superclass handler
   method connect {con name} {
      my variable children
      set tag [$con tag]
      puts "$tag ! Connecting to $name"
      $con echo "Connecting to $name"
      # Find already-extant character
      set found 0
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
         # puts "$tag ! Creating new character $name"
         my newconnect [gamechar new $con $name]
      }
   }

   method connectinfo {} {
   # Return information on all connected children.
   # Typical Tcl ordered flat list.
   # Order is: characterName ctime atime
   my variable children
      set outlist {}
      foreach c $children {
         lappend outlist [list [$c name] [$c ctime] [$c atime]]
      }
      return $outlist
   }

   method showwho {obj} {
   # Human readable connection information.
   # Information is done using by calling the 'echo' method on obj
   # for each line.
      set now [clock seconds]
      $obj echo [format "%-20s %-30s %-10s" Name: Connected: Idle: ]
      foreach {n c a} [concat [join [my connectinfo]]] {
         set connecttime [clock format $c]
         set idletime [clock format [expr {$now-$a}] -format "%T" -timezone UTC]
         $obj echo [format "%-20s %-30s %-10s" $n $connecttime $idletime]
      }
      $obj echo "----- Done"
   }

   method parse {obj str} {
   # Try and interpret 'str' using the interpreter attached to 'obj'
   # Echo the result or error information.
      puts "[$obj tag] ! Parsing: $str"
      if {0== [catch "[$obj interpreter] eval $str" result ovn]} {
         $obj echo $result
      } {
         # TODO: Parse this out for better reading
         $obj echo "Error: $result"
         $obj echo "----"
         $obj echo $ovn
         $obj echo "----"
      }
   }
# end class doefinition: gameshell
}

package provide gameshell 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
