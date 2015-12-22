#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# This class should be subclassed for most internal nodes in the
# server tree
#
# (C) 2014, 2015 Ryan Davis.
#
package require TclOO
package require connection

oo::class create handler {
# Variables:
#   children -- nodes below this in server tree
#   parent -- node above in server tree.
   constructor {} {
   my variable children
   my variable parent
      set children {}
      set parent [self]
   }
   destructor {
   my variable children
      foreach x $children {$x destroy}
   }
# Setter Methods
   method parent {obj} {
   my variable parent
      # puts "New parent of [self] is $obj"
      set parent $obj
   }
# Getter Methods
   method name {} { return "<UNKNOWN>" }
# Methods.
   method broadcast {str} {
      my variable parent
      if {$parent == [self]} {
         # puts "TOP broadcast [self]"
         my echo $str
      } {
         $parent broadcast $str
         # puts bbb
      }
   }

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
   # remove 'con' from children, but DO NOT DESTROY.
      my variable children
      set idx [lsearch -exact $children $con]
      set children [lreplace $children $idx $idx]
   }

   method disconnect {con} {
   # Remove 'con' from children and destroy 'con'.
      my remove $con
      $con destroy
   }

   method echo {str} {
   # Distributor. Calls 'echo' method with 'str' on all children.
      my variable children
      # puts "Echoing from [self] : $str"
      # puts "Echoing to $children"
      foreach c $children {
         $c echo $str
      }
   }
# end class definition: handler
}

package provide handler 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
