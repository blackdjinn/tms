#!/bin/false
# This shouldn't be invoked as a command, so it is set up to fail.
#
# Class definition for 'connection' which contains the basic wrapping
# for maintinaing a specific client connection.
#
# (C) 2014 Ryan Davis.
#
package require TclOO

oo::class create connection {
   constructor {chanid clientaddress clientport} {
      my variable channel
      my variable address
      my variable port
      my variable active
      my variable tag
      my variable parent
      set parent nil
      set channel $chanid
      set address $clientaddress
      set port $clientport
      set active True
      set tag "$address:$port"
      fconfigure $channel -blocking False -buffering line -translation auto
      fileevent $channel readable [list [self] newline ]
      puts "$tag ! connected"
      my echo "$tag ! connected"
   }
   destructor {
      my variable channel
      my variable tag
      fileevent $channel readable {}
      close $channel
      puts "$tag ! disconnected"
   }
# Getter methods
   method channel {} { my variable channel ; return $channel }
   method address {} { my variable address ; return $address }
   method port {} { my variable port ; return $port }
   method active {} { my variable active ; return $active }
   method tag {} { my variable tag ; return $tag }
# Setter Methods
   method settag {newtag} {
      my variable tag
      set tag $newtag
      return $tag
   }
   method parent {obj} {
      my variable parent
      set parent $obj
   }
# I/O
   method echo {str} {
   # Send string argument to client
   my variable active
   my variable channel
   my variable tag
      if {$active} {
         puts $channel $str
         puts "$tag > $str"
      }
   }
   method readline {} {
   # Return line read from client
   my variable active
   my variable channel
   my variable tag
      if {$active} {
         if {[gets $channel line] >= 0} {
            puts "$tag < $line"
            return $line
         }
         if {[eof $channel]} {
            puts "$tag ! closing"
            close $channel
            set active False
            my variable parent
            $parent disconnect [self]
         }
      } { return "" }
   }
   method newline {} {
   # triggered on readable input
   my variable parent
      $parent parse [self] [my readline]
   }
   export echo address port active tag settag export parent
}
package provide connection 0
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
}
