#!/usr/bin/tclsh
# TMS -- Tcl MU Server
# (C) Copyright 2014 Ryan Davis.
# Released to Creative Commons. See 'Licence.txt'

# User configuration

# Port to listen for incoming connections on
set serverport 5432

#
# End of configuration. Don't change below here.
#
package require TclOO

oo::class create connection {
   constructor {chanid clientaddress clientport} {
      my variable channel
      my variable address
      my variable port
      my variable active
      my variable tag
      my variable owner
      set owner nil
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
      fileevent $channel readable {}
      close $channel
   }
# Getter methods
   method channel {} { my variable channel ; return $channel }
   method address {} { my variable address ; return $address }
   method port {} { my variable port ; return $port }
   method active {} { my variable active ; return $active }
   mrthod tag {} { my variable tag ; return $tag }
# Setter Methods
   method settag {newtag} {
      my variable tag
      set tag $newtag
      return $tag
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
         }
      } { return "" }
   }
   method newline {} {
   # triggered on readable input
   # Currently a stup to simply echo.
      my echo [my readline]
   }
   export echo address port active tag settag
}

set pendingconnects {}
set forever 0
set characters(.connectcount) 0

proc newconnection {chanid clientaddr clientport} {
   global pendingconnects
   lappend pendingconnects [connection new $chanid $clientaddr $clientport]
}

socket -server newconnection $serverport
puts "Listening on $serverport"
vwait forever
