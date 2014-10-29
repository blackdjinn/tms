#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handler for individual chracters
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require handlers

oo::class create charactershell {
   superclass handler
   constructor {con charname} {
      my variable name
      my variable atime
      set name $charname
      set atime [clock seconds]
      next
      my newconnect $con
      # puts "[$con tag] ! creating $charname charctershell [self]"
   }
   method name {} {
      my variable name
      return $name
   }
   method parse {obj str} {
      #Stub that passes the buck upstairs
      my variable parent
      my variable atime
      set atime [clock seconds]
      $parent parse [self] $str
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

package provide characters 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
