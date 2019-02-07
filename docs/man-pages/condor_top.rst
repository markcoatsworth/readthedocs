      

condor\_top
===========

Display status and runtime statistics of a HTCondor daemon

Synopsis
--------

**condor\_top** [**-h**\ ]

**condor\_top** [**-l**\ ]
[**-p  **\ *centralmanagerhostname[:portname]*] [**-n  **\ *name*]
[**-d  **\ *delay*] [**-c  **\ *columnset*] [**-s  **\ *sortcolumn*]
[--**attrs=<attr1,attr2,...>**] [*daemon options*\ ]

**condor\_top** [**-c  **\ *columnset*] [**-s  **\ *sortcolumn*]
[--**attrs=<attr1,attr2,...>**] [*classad-filename classad-filename*\ ]

Description
-----------

*condor\_top* displays the status (e.g. memory usage and duty cycle) of
a HTCondor daemon and calculates and displays runtime statistics for the
daemon’s subprocesses.

When no arguments are specified, *condor\_top* displays the status for
the primary daemon based on the role of the current machine by scanning
the ``DAEMON_LIST`` configuration setting. If multiple daemons are
listed, *condor\_top* will monitor one of (in decreasing priority):
*condor\_schedd*, *condor\_startd*, *condor\_collector*,
*condor\_negotiator*, *condor\_master*.

If the *condor\_collector* returns multiple ClassAds for the chosen
daemon type, *condor\_top* will display stats from the first ClassAd
returned. Results can be constrained by passing the ``NAME`` of a
specific daemon with **-n**.

The default *delay* is ``STATISTICS_WINDOW_QUANTUM``, which is 4 minutes
(240 seconds) in a default HTCondor configuration. Setting the delay
smaller can be helpful for finding spikes of activity, but setting the
delay too small will lead to poor measurements of the duty cycle and of
the runtime statistics.

*condor\_top* can run in a top-like “live” mode by passing **-l**. The
live mode is similar to the \*nix top command, with stats updating every
*delay* seconds. Redirecting stdout will disable live mode even if
**-l** is set. To exit *condor\_top* while in live mode, issue Ctrl-C.

*condor\_top* can be passed two files containing ClassAds from the same
HTCondor daemon, in which case the *condor\_collector* will not be
queried but rather the statistics will be computed and displayed
immediately from the two ClassAds. Only -c, -s, and –attrs options are
considered when passing ClassAds via files.

The following subprocess stat columns may be displayed (\*default):

 Item
    \*Name of the subprocess
 InstRt
    \*Total runtime between the two ClassAds
 InstAvg
    \*Mean runtime per execution between the two ClassAds
 TotalRt
    Total runtime since daemon start
 TotAvg
    \*Mean runtime per execution since daemon start
 TotMax
    \*Max runtime per execution since daemon start
 TotMin
    Min runtime per execution since daemon start
 RtPctAvg
    \*Percent of mean runtime per execution. The ratio of InstAvg to
    TotAvg, expressed as a percentage
 RtPctMax
    Percent of max runtime per execution. The ratio of (InstAvg -
    TotMin) to (TotMax - TotMin), expressed as a percentage
 RtSigmas
    Standard deviations from mean runtime. The ratio of (InstAvg -
    TotAvg) to the standard deviation in runtime per execution since
    daemon start
 InstCt
    Executions between the two ClassAds
 InstRate
    \*Executions per second between the two ClassAds
 TotalCt
    Total executions (counts) since daemon start
 AvgRate
    \*Mean count rate. Executions per second since daemon start
 CtPctAvg
    Percent of mean count rate. The ratio of InstRate to AvgRate,
    expressed as a percentage.

Options
-------

 **-h**
    Displays the list of options.
 **-l**
    Puts *condor\_top* in to a live, continually updating mode.
 **-p **\ *centralmanagerhostname[:portname]*
    Query the daemon via the specified central manager. If omitted, the
    value of the configuration variable ``COLLECTOR_HOST`` is used.
 **-n **\ *name*
    Query the daemon named *name*. If omitted, the value used will
    depend on the type of daemon queried (see Daemon Options).
 **-d **\ *delay*
    Specifies the *delay* between ClassAd updates, in integer seconds.
    If omitted, the value of the configuration variable
    ``STATISTICS_WINDOW_QUANTUM`` is used.
 **-c **\ *columnset*
    Display *columnset* set of columns. Valid *columnset*\ s are:
    default, runtime, count, all.
 **-s **\ *sortcolumn*
    Sort table by *sortcolumn*. Defaults to InstRt.
 **—attrs=<attr1,attr2,...>**
    | Comma-delimited list of additional ClassAd attributes to monitor.

    **Daemon Options**

 **—collector**
    Monitor *condor\_collector* ClassAds. If -n is not set, the
    constraint “Machine == ``COLLECTOR_HOST``\ ” will be used.
 **—negotiator**
    Monitor *condor\_negotiator* ClassAds. If -n is not set, the
    constraint “Machine == ``COLLECTOR_HOST``\ ” will be used.
 **—master**
    Monitor *condor\_master* ClassAds. If -n is not set, the constraint
    “Machine == ``COLLECTOR_HOST``\ ” will be used.
 **—schedd**
    Monitor *condor\_schedd* ClassAds. If -n is not set, the constraint
    “Machine == ``FULL_HOSTNAME``\ ” will be tried, otherwise the first
    *condor\_schedd* ClassAd returned from the *condor\_collector* will
    be used.
 **—startd**
    Monitor *condor\_startd* ClassAds. If -n is not set, the constraint
    “Machine == ``FULL_HOSTNAME``\ ” will be tried, otherwise the first
    *condor\_startd* ClassAd returned from the *condor\_collector* will
    be used.

Author
------

Center for High Throughput Computing, University of Wisconsin–Madison

Copyright
---------

Copyright © 1990-2019 Center for High Throughput Computing, Computer
Sciences Department, University of Wisconsin-Madison, Madison, WI. All
Rights Reserved. Licensed under the Apache License, Version 2.0.

      
