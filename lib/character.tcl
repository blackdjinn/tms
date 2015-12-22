#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handler for individual chracters
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require handler

oo::class create character {
# Variables:
#   name -- Name of the character represented.
#   atime -- Time this character object saw user access
#   ctime -- Time this character object was created.
#     Times may be out of sequences as they are set by different calls
#     to [clock seconds].
   superclass handler
   constructor {con charname} {
      my variable name
      my variable atime
      my variable ctime
      set name $charname
      set atime [clock seconds]
      set ctime [clock seconds]
      next
      my newconnect $con
      # puts "[$con tag] ! creating $charname charctershell [self]"
   }
# Getters
   method atime {} {
      my variable atime
      return $atime
   }

   method ctime {} {
      my variable ctime
      return $ctime
   }

   method name {} {
      my variable name
      return $name
   }
# Other
   method parse {obj str} {
      #Stub that passes the buck upstairs to what should be an instance of
      # some sort of 'shell' class.
      my variable parent
      my variable atime
      set atime [clock seconds]
      $parent parse [self] $str
   }
   
   method newconnect {con} {
   # create new connection to this character.
   my variable name
      $con settag "[$con tag]:$name"
      next $con
   }
   
   method disconnect {con} {
   # Close and remove a network connection to this character.
   my variable children
   my variable name
      my remove $con
      $con destroy
      if {[llength $children] <= 0} {
         $parent disconnect [self]
         puts "! $name uneeded. destroyed."
      }
   }
# end class definition: character
}

package provide character 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
