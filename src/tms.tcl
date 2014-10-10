#!/usr/bin/tclsh
# TMS -- Tcl MU Server
# (C) Copyright 2014 Ryan Davis.
# Released to Creative Commons. See 'Licence.txt'

# User configuration

# Port to listen for incoming connections on
set serverport 5432
set libdir "/home/ryan/src/tms/lib"

#
# End of configuration. Don't change below here.
#
lappend auto_path $libdir
package require TclOO

package require connection

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
