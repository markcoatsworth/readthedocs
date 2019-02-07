      

condor\_power
=============

send packet intended to wake a machine from a low power state

Synopsis
--------

**condor\_power** [**-h**\ ]

**condor\_power** [**-d**\ ] [**-i**\ ] [**-m  **\ *MACaddress*]
[**-s  **\ *subnet*] [*ClassAdFile*\ ]

Description
-----------

*condor\_power* sends one UDP Wake on LAN (WOL) packet to a machine
specified either by command line arguments or by the contents of a
machine ClassAd. The machine ClassAd may be in a file, where the file
name specified by the optional argument *ClassAdFile* is given on the
command line. With no command line arguments to specify the machine, and
no file specified, *condor\_power* quietly presumes that standard input
is the file source which will specify the machine ClassAd that includes
the public IP address and subnet of the machine.

*condor\_power* needs a complete specification of the machine to be
successful. If a MAC address is provided on the command line, but no
subnet is given, then the default value for the subnet is used. If a
subnet is provided on the command line, but no MAC address is given,
then *condor\_power* falls back to taking its information in the form of
the machine ClassAd as provided in a file or on standard input. Note
that this case implies that the command line specification of the subnet
is ignored.

*condor\_power* relies on the router receiving the WOL packet to
correctly broadcast the request. Since routers are often configured to
ignore requests to broadcast messages on a different subnet than the
sender, the send of a WOL packet to a machine on a different subnet may
fail.

Options
-------

 **-h**
    Print usage information and exit.
 **-d**
    Enable debugging messages.
 **-i**
    Read a ClassAd that is piped in through standard input.
 **-m **\ *MACaddress*
    Specify the MAC address in the standard format of six groups of two
    hexadecimal digits separated by colons.
 **-s **\ *subnet*
    Specify the subnet in the standard form of a mask for an IPv4
    address. Without this option, a global broadcast will be sent.

Exit Status
-----------

*condor\_power* will exit with a status value of 0 (zero) upon success,
and it will exit with the value 1 (one) upon failure.

Author
------

Center for High Throughput Computing, University of Wisconsin–Madison

Copyright
---------

Copyright © 1990-2019 Center for High Throughput Computing, Computer
Sciences Department, University of Wisconsin-Madison, Madison, WI. All
Rights Reserved. Licensed under the Apache License, Version 2.0.

      
