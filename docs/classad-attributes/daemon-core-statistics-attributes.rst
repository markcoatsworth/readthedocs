      

DaemonCore Statistics Attributes
================================

Every HTCondor daemon keeps a set of operational statistics, some of
which are common to all daemons, others are specific to the running of a
particular daemon. In some cases, the statistics can reveal buggy or
slow performance of the HTCondor system. The following statistics are
available for all daemons, and can be accessed directly with the
condor\_status command with a direct query, such as

::

    condor\_status -direct somehostname.example.com -schedd -statistics DC:2 -l

 DCUdpQueueDepth:
    This attribute is the number of bytes in the incoming UDP receive
    queue for this daemon, if it has a UDP command port. This attribute
    is polled once a minute by default, so may be out of date. The
    attribute DCUdpQueueDepthPeak records the peak depth since the
    daemon has started.
 DebugOuts:
    This attribute is the count of debugging messages printed to the
    daemon’s debug log, such as the ScheddLog. There is a moderate cost
    to writing these logging messages, if the debug level is very high
    for an active daemon, the logging will slow performance. The
    corresponding attribute RecentDebugOuts is the count of the messages
    in the last 20 minutes.
 PipeMessages:
    This attribute is the number of messages received on a Unix pipe by
    this daemon since start time. The corresponding attribute
    RecentPipeMessages is the count of message in the last 20 minutes.
 PipeRuntime:
    This attribute respresents the total number of wall clock seconds
    this daemon has spent processing pipe message since start. The
    corresponding attribute RecentPipeRuntime is the total time in the
    last 20 minutes.
 SelectWaittime:
    This attribute represents the total number of wall clock seconds
    this daemon has spent completely idle, waiting to process incoming
    requests or internal timers. The attribute DaemonCoreDutyCycle,
    which may be easier to write policy around, is based off of this.
 SignalRuntime:
    This attribute respresents the total number of wall clock time
    seconds this daemon has spent processing signals since start. The
    corresponding attribute RecentSignalRuntime is the total time in the
    last 20 minutes.
 Signals:
    This attribute is the number of signals, either Unix signals, or
    HTCondor simulated signals received by this daemon since start time.
    The corresponding attribute RecentSignals is the number of signals
    in the last 20 minutes.
 SocketRuntime:
    This attribute respresents the total number of wall clock time
    seconds this daemon has spent processing socket messages since
    start. The corresponding attribute RecentTimerRuntime is the total
    time in the last 20 minutes.
 SockMessages:
    This attribute is the number of messages received on socket by this
    daemon since start time. The corresponding attribute
    RecentSockMessages is the count of message in the last 20 minutes.
 TimerRuntime:
    This attribute respresents the total number of wall clock time
    seconds this daemon has spent processing timers since start. The
    corresponding attribute RecentTimerRuntime is the total time in the
    last 20 minutes.
 TimersFired:
    This attribute is the number of internal timers which have fired, in
    this daemon since start time. The corresponding attribute
    RecentTimersFired in the number of timers fired in the last 20
    minutes.

      
