#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handler for individual chracters
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require handler

oo::class create character {
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
      #Stub that passes the buck upstairs
      my variable parent
      my variable atime
      set atime [clock seconds]
      $parent parse [self] $str
   }
   method newconnect {con} {
   my variable name
      $con settag "[$con tag]:$name"
      next $con
   }
   method disconnect {con} {
   my variable children
   my variable name
      my remove $con
      $con destroy
      if {[llength $children] <= 0} {
         $parent disconnect [self]
         puts "! $name uneeded. destroyed."
      }
   }
}

package provide character 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
