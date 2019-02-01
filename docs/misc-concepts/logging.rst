      

Logging in HTCondor
===================

HTCondor records many types of information in a variety of logs.
Administration may require locating and using the contents of a log to
debug issues. Listed here are details of the logs, to aid in
identification.

Job and Daemon Logs
^^^^^^^^^^^^^^^^^^^

 job event log
    The job event log is an optional, chronological list of events that
    occur as a job runs. The job event log is written on the submit
    machine. The submit description file for the job requests a job
    event log with the submit command **log**. The log is created and
    remains on the submit machine. Contents of the log are detailed in
    section \ `2.6.7 <ManagingaJob.html#x18-600002.6.7>`__. Examples of
    events are that the job is running, that the job is placed on hold,
    or that the job completed.
 daemon logs
    Each daemon configured to have a log writes events relevant to that
    daemon. Each event written consists of a timestamp and message. The
    name of the log file is set by the value of configuration variable
    <SUBSYS>\_LOG , where <SUBSYS> is replaced by the name of the
    daemon. The log is not permitted to grow without bound; log rotation
    takes place after a configurable maximum size or length of time is
    encountered. This maximum is specified by configuration variable
    MAX\_<SUBSYS>\_LOG .

    Which events are logged for a particular daemon are determined by
    the value of configuration variable <SUBSYS>\_DEBUG . The possible
    values for <SUBSYS>\_DEBUG categorize events, such that it is
    possible to control the level and quantity of events written to the
    daemon’s log.

    Configuration variables that affect daemon logs are

     MAX\_NUM\_<SUBSYS>\_LOG
     TRUNC\_<SUBSYS>\_LOG\_ON\_OPEN
     <SUBSYS>\_LOG\_KEEP\_OPEN
     <SUBSYS>\_LOCK
     FILE\_LOCK\_VIA\_MUTEX
     TOUCH\_LOG\_INTERVAL
     LOGS\_USE\_TIMESTAMP
     LOG\_TO\_SYSLOG

    Daemon logs are often investigated to accomplish administrative
    debugging. *condor\_config\_val* can be used to determine the
    location and file name of the daemon log. For example, to display
    the location of the log for the *condor\_collector* daemon, use

    ::

          condor_config_val COLLECTOR_LOG

 job queue log
    The job queue log is a transactional representation of the current
    job queue. If the *condor\_schedd* crashes, the job queue can be
    rebuilt using this log. The file name is set by configuration
    variable JOB\_QUEUE\_LOG , and defaults to $(SPOOL)/job\_queue.log.

    Within the log, each transaction is identified with an integer value
    and followed where appropriate with other values relevant to the
    transaction. To reduce the size of the log and remove any
    transactions that are no longer relevant, a copy of the log is kept
    by renaming the log at each time interval defined by configuration
    variable QUEUE\_CLEAN\_INTERVAL, and then a new log is written with
    only current and relevant transactions.

    Configuration variables that affect the job queue log are

     SCHEDD\_BACKUP\_SPOOL
     ROTATE\_HISTORY\_DAILY
     ROTATE\_HISTORY\_MONTHLY
     QUEUE\_CLEAN\_INTERVAL
     MAX\_JOB\_QUEUE\_LOG\_ROTATIONS

 *condor\_schedd* audit log
    The optional *condor\_schedd* audit log records user-initiated
    events that modify the job queue, such as invocations of
    *condor\_submit*, *condor\_rm*, *condor\_hold* and
    *condor\_release*. Each event has a time stamp and a message that
    describes details of the event.

    This log exists to help administrators track the activities of pool
    users.

    The file name is set by configuration variable SCHEDD\_AUDIT\_LOG .

    Configuration variables that affect the audit log are

     MAX\_SCHEDD\_AUDIT\_LOG
     MAX\_NUM\_SCHEDD\_AUDIT\_LOG

 *condor\_shared\_port* audit log
    The optional *condor\_shared\_port* audit log records connections
    made through the DAEMON\_SOCKET\_DIR . Each record includes the
    source address, the socket file name, and the target process’s PID,
    UID, GID, executable path, and command line.

    This log exists to help administrators track the activities of pool
    users.

    The file name is set by configuration variable
    SHARED\_PORT\_AUDIT\_LOG .

    Configuration variables that affect the audit log are

     MAX\_SHARED\_PORT\_AUDIT\_LOG
     MAX\_NUM\_SHARED\_PORT\_AUDIT\_LOG

 event log
    The event log is an optional, chronological list of events that
    occur for all jobs and all users. The events logged are the same as
    those that would go into a job event log. The file name is set by
    configuration variable EVENT\_LOG . The log is created only if this
    configuration variable is set.

    Configuration variables that affect the event log, setting details
    such as the maximum size to which this log may grow and details of
    file rotation and locking are

     EVENT\_LOG\_MAX\_SIZE
     EVENT\_LOG\_MAX\_ROTATIONS
     EVENT\_LOG\_LOCKING
     EVENT\_LOG\_FSYNC
     EVENT\_LOG\_ROTATION\_LOCK
     EVENT\_LOG\_JOB\_AD\_INFORMATION\_ATTRS
     EVENT\_LOG\_USE\_XML

 accountant log
    The accountant log is a transactional representation of the
    *condor\_negotiator* daemon’s database of accounting information,
    which are user priorities. The file name of the accountant log is
    $(SPOOL)/Accountantnew.log. Within the log, users are identified by
    username@uid\_domain.

    To reduce the size and remove information that is no longer
    relevant, a copy of the log is made when its size hits the number of
    bytes defined by configuration variable
    MAX\_ACCOUNTANT\_DATABASE\_SIZE, and then a new log is written in a
    more compact form.

    Administrators can change user priorities kept in this log by using
    the command line tool *condor\_userprio*.

 negotiator match log
    The negotiator match log is a second daemon log from the
    *condor\_negotiator* daemon. Events written to this log are those
    with debug level of D\_MATCH. The file name is set by configuration
    variable NEGOTIATOR\_MATCH\_LOG , and defaults to $(LOG)/MatchLog.
 history log
    This optional log contains information about all jobs that have been
    completed. It is written by the *condor\_schedd* daemon. The file
    name is $(SPOOL)/history.

    Administrators can change view this historical information by using
    the command line tool *condor\_history*.

    Configuration variables that affect the history log, setting details
    such as the maximum size to which this log may grow are

     ENABLE\_HISTORY\_ROTATION
     MAX\_HISTORY\_LOG
     MAX\_HISTORY\_ROTATIONS

DAGMan Logs
^^^^^^^^^^^

 default node log
    A job event log of all node jobs within a single DAG. It is used to
    enforce the dependencies of the DAG.

    The file name is set by configuration variable
    DAGMAN\_DEFAULT\_NODE\_LOG , and the full path name of this file
    must be unique while any and all submitted DAGs and other jobs from
    the submit host run. The syntax used in the definition of this
    configuration variable is different to enable the setting of a
    unique file name. See
    section \ `3.5.23 <ConfigurationMacros.html#x33-2160003.5.23>`__ for
    the complete definition.

    Configuration variables that affect this log are

     DAGMAN\_ALWAYS\_USE\_NODE\_LOG

 the .dagman.out file
    A log created or appended to for each DAG submitted with timestamped
    events and extra information about the configuration applied to the
    DAG. The name of this log is formed by appending .dagman.out to the
    name of the DAG input file. The file remains after the DAG
    completes.

    This log may be helpful in debugging what has happened in the
    execution of a DAG, as well as help to determine the final state of
    the DAG.

    Configuration variables that affect this log are

     DAGMAN\_VERBOSITY
     DAGMAN\_PENDING\_REPORT\_INTERVAL

 the jobstate.log file
    This optional, machine-readable log enables automated monitoring of
    DAG.
    Section \ `2.10.14 <DAGManApplications.html#x22-1110002.10.14>`__
    details this log.

      
