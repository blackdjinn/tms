#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handlers for connections. It includes the basic communication logic.
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection
package require handler
package require character

oo::class create gamechar {
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

   method interpreter {} {
      # Getter method
      my variable interpreter
      return $interpreter
   }

   method tag {} {
      my variable name
      return "char: $name"
   }
}

oo::class create gameshell {
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
         # puts "$tag ! Creating new character $name"
         my newconnect [gamechar new $con $name]
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
      foreach {n c a} [concat [join [my connectinfo]]] {
         set connecttime [clock format $c]
         set idletime [clock format [expr {$now-$a}] -format "%T" -timezone UTC]
         $obj echo [format "%-20s %-30s %-10s" $n $connecttime $idletime]
      }
      $obj echo "----- Done"
   }

   method parse {obj str} {
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

}


package provide gameshell 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
