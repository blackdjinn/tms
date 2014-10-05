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

set pendingconnects {}
set forever 0
set characters(.connectcount) 0

proc newconnection {chanid clientaddr clientport} {
   puts "Newconnect: $clientaddr"
   puts $chanid "Newconnect: $clientaddr"
   lappend pendingconnects $chanid
   fconfigure $chanid -blocking False -buffering line -translation auto
   fileevent $chanid readable [list testEcho $chanid]
}

proc testEcho {chanid} {
   if {[gets $chanid line] >= 0} {
      puts $line
      puts $chanid $line
   }
   if {[eof $chanid]} {
      puts closing
      close $chanid
   }
}

socket -server newconnection $serverport
puts "Listening on $serverport"
vwait forever
