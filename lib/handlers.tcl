#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Handlers for connections. It includes the basic communication logic.
#
# (C) 2014 Ryan Davis.
#
package require TclOO
package require connection

oo::class create handler {
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
      my variable children
      set idx [lsearch -exact $children $con]
      set children [lreplace $children $idx $idx]
   }
   method disconnect {con} {
      my remove $con
      $con destroy
   }
   method echo {str} {
      my variable children
      # puts "Echoing from [self] : $str"
      # puts "Echoing to $children"
      foreach c $children {
         $c echo $str
      }
   }
}

oo::class create loginshell {
   superclass handler
   method handoff {obj str} {
   # TODO: this assumes implimentation details that will go away.
   # Rethink how this is done.
   global chatroom
      set name ""
      set pass ""
      set connect ""
      scan $str "%s %s %s" connect name pass
      # TODO: Validate password here.
      my remove $obj
      $chatroom connect $obj $name
   }
   method parse {obj str} {
      set firstword ""
      scan $str "%s" firstword
      switch -nocase $firstword {
         who {}
         quit {
            $obj echo "Goodbye."
            my disconnect $obj
         }
         connect {
            my handoff $obj $str
         }
         help {
            $obj echo "Help: Valid commands:"
            $obj echo "  help                     Print this message"
            $obj echo "  who                      List people connected"
            $obj echo "  quit                     disconnect"
            $obj echo "  connect name password    connect as 'name'"
         }
         default {
            $obj echo "Command not understood. Type 'help' for assistance."
         }
      }
   }
}

oo::class create chatshell {
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
         my newconnect [charactershell new $con $name]
      }
   }
   method parse {obj str} {
      switch $str {
         QUIT {
            $obj echo "Goodbye!"
            my disconnect $obj
         }
         default { my broadcast "[$obj name] : $str" }
      }
   }
}

package provide handlers 0
package require characters
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
