      

condor\_wait
============

Wait for jobs to finish

Synopsis
^^^^^^^^

**condor\_wait** [**-help \| -version**\ ]

**condor\_wait** [**-debug**\ ] [**-status**\ ] [**-echo**\ ]
[**-wait  **\ *seconds*] [**-num  **\ *number-of-jobs*] *log-file*
[**job ID**\ ]

Description
^^^^^^^^^^^

*condor\_wait* watches a job event log file (created with the **log**
command within a submit description file) and returns when one or more
jobs from the log have completed or aborted.

Because *condor\_wait* expects to find at least one job submitted event
in the log file, at least one job must have been successfully submitted
with *condor\_submit* before *condor\_wait* is executed.

*condor\_wait* will wait forever for jobs to finish, unless a shorter
wait time is specified.

Options
^^^^^^^

 **-help**
    Display usage information
 **-version**
    Display version information
 **-debug**
    Show extra debugging information.
 **-status**
    Show job start and terminate information.
 **-echo**
    Print the events out to stdout.
 **-wait **\ *seconds*
    Wait no more than the integer number of *seconds*. The default is
    unlimited time.
 **-num **\ *number-of-jobs*
    Wait for the integer *number-of-jobs* jobs to end. The default is
    all jobs in the log file.
 log file
    The name of the log file to watch for information about the job.
 job ID
    A specific job or set of jobs to watch. If the **job ID** is only
    the job ClassAd attribute ClusterId, then *condor\_wait* waits for
    all jobs with the given ClusterId. If the **job ID** is a pair of
    the job ClassAd attributes, given by ClusterId.ProcId, then
    *condor\_wait* waits for the specific job with this **job ID**. If
    this option is not specified, all jobs that exist in the log file
    when *condor\_wait* is invoked will be watched.

General Remarks
^^^^^^^^^^^^^^^

*condor\_wait* is an inexpensive way to test or wait for the completion
of a job or a whole cluster, if you are trying to get a process outside
of HTCondor to synchronize with a job or set of jobs.

It can also be used to wait for the completion of a limited subset of
jobs, via the **-num** option.

Examples
^^^^^^^^

::

    condor_wait logfile

This command waits for all jobs that exist in logfile to complete.

::

    condor_wait logfile 40

This command waits for all jobs that exist in logfile with a job ClassAd
attribute ClusterId of 40 to complete.

::

    condor_wait -num 2 logfile

This command waits for any two jobs that exist in logfile to complete.

::

    condor_wait logfile 40.1

This command waits for job 40.1 that exists in logfile to complete.

::

    condor_wait -wait 3600 logfile 40.1

This waits for job 40.1 to complete by watching logfile, but it will not
wait more than one hour (3600 seconds).

Exit Status
^^^^^^^^^^^

*condor\_wait* exits with 0 if and only if the specified job or jobs
have completed or aborted. *condor\_wait* returns 1 if unrecoverable
errors occur, such as a missing log file, if the job does not exist in
the log file, or the user-specified waiting time has expired.

Author
^^^^^^

Center for High Throughput Computing, University of Wisconsin–Madison

Copyright
^^^^^^^^^

Copyright © 1990-2019 Center for High Throughput Computing, Computer
Sciences Department, University of Wisconsin-Madison, Madison, WI. All
Rights Reserved. Licensed under the Apache License, Version 2.0.

      
