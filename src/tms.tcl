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

package require server
package require handlers

set thisserver [server new $serverport [loginshell new]]
vwait forever
