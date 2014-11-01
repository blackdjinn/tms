# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded connection 0 [list source [file join $dir connection.tcl]]
package ifneeded server 0 [list source [file join $dir server.tcl]]
package ifneeded handler 0 [list source [file join $dir handler.tcl]]
package ifneeded loginshell 0 [list source [file join $dir loginshell.tcl]]
package ifneeded chatshell 0 [list source [file join $dir chatshell.tcl]]
package ifneeded character 0 [list source [file join $dir character.tcl]]
