      

 AuthenticatedIdentity:
    The authenticated name assigned by the *condor\_collector* to the
    daemon that published the ClassAd.
 AuthenticationMethod:
    The authentication method used by the *condor\_collector* to
    determine the AuthenticatedIdentity.
 LastHeardFrom:
    The time inserted into a daemon’s ClassAd representing the time that
    this *condor\_collector* last received a message from the daemon.
    Time is represented as the number of second elapsed since the Unix
    epoch (00:00:00 UTC, Jan 1, 1970). This attribute is added if
    COLLECTOR\_DAEMON\_STATS is True.
 UpdatesHistory:
    A bitmap representing the status of the most recent updates received
    from the daemon. This attribute is only added if
    COLLECTOR\_DAEMON\_HISTORY\_SIZE is non-zero. See
    page \ `733 <ConfigurationMacros.html#x33-2010003.5.14>`__ for more
    information on this setting. This attribute is added if
    COLLECTOR\_DAEMON\_STATS is True.
 UpdatesLost:
    An integer count of the number of updates from the daemon that the
    *condor\_collector* can definitively determine were lost since the
    *condor\_collector* started running. This attribute is added if
    COLLECTOR\_DAEMON\_STATS is True.
 UpdatesSequenced:
    An integer count of the number of updates received from the daemon,
    for which the *condor\_collector* can tell how many were or were not
    lost, since the *condor\_collector* started running. This attribute
    is added if COLLECTOR\_DAEMON\_STATS is True.
 UpdatesTotal:
    An integer count started when the *condor\_collector* started
    running, representing the sum of the number of updates actually
    received from the daemon plus the number of updates that the
    *condor\_collector* determined were lost. This attribute is added if
    COLLECTOR\_DAEMON\_STATS is True.

      
