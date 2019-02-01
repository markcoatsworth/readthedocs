      

The High Availability of Daemons
================================

In the case that a key machine no longer functions, HTCondor can be
configured such that another machine takes on the key functions. This is
called High Availability. While high availability is generally
applicable, there are currently two specialized cases for its use: when
the central manager (running the *condor\_negotiator* and
*condor\_collector* daemons) becomes unavailable, and when the machine
running the *condor\_schedd* daemon (maintaining the job queue) becomes
unavailable.

High Availability of the Job Queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For a pool where all jobs are submitted through a single machine in the
pool, and there are lots of jobs, this machine becoming nonfunctional
means that jobs stop running. The *condor\_schedd* daemon maintains the
job queue. No job queue due to having a nonfunctional machine implies
that no jobs can be run. This situation is worsened by using one machine
as the single submission point. For each HTCondor job (taken from the
queue) that is executed, a *condor\_shadow* process runs on the machine
where submitted to handle input/output functionality. If this machine
becomes nonfunctional, none of the jobs can continue. The entire pool
stops running jobs.

The goal of High Availability in this special case is to transfer the
*condor\_schedd* daemon to run on another designated machine. Jobs
caused to stop without finishing can be restarted from the beginning, or
can continue execution using the most recent checkpoint. New jobs can
enter the job queue. Without High Availability, the job queue would
remain intact, but further progress on jobs would wait until the machine
running the *condor\_schedd* daemon became available (after fixing
whatever caused it to become unavailable).

HTCondor uses its flexible configuration mechanisms to allow the
transfer of the *condor\_schedd* daemon from one machine to another. The
configuration specifies which machines are chosen to run the
*condor\_schedd* daemon. To prevent multiple *condor\_schedd* daemons
from running at the same time, a lock (semaphore-like) is held over the
job queue. This synchronizes the situation in which control is
transferred to a secondary machine, and the primary machine returns to
functionality. Configuration variables also determine time intervals at
which the lock expires, and periods of time that pass between polling to
check for expired locks.

To specify a single machine that would take over, if the machine running
the *condor\_schedd* daemon stops working, the following additions are
made to the local configuration of any and all machines that are able to
run the *condor\_schedd* daemon (becoming the single pool submission
point):

::

    MASTER_HA_LIST = SCHEDD
     SPOOL = /share/spool
     HA_LOCK_URL = file:/share/spool
     VALID_SPOOL_FILES = $(VALID_SPOOL_FILES) SCHEDD.lock

Configuration macro MASTER\_HA\_LIST identifies the *condor\_schedd*
daemon as the daemon that is to be watched to make sure that it is
running. Each machine with this configuration must have access to the
lock (the job queue) which synchronizes which single machine does run
the *condor\_schedd* daemon. This lock and the job queue must both be
located in a shared file space, and is currently specified only with a
file URL. The configuration specifies the shared space (SPOOL), and the
URL of the lock. *condor\_preen* is not currently aware of the lock file
and will delete it if it is placed in the SPOOL directory, so be sure to
add file SCHEDD.lock to VALID\_SPOOL\_FILES .

As HTCondor starts on machines that are configured to run the single
*condor\_schedd* daemon, the *condor\_master* daemon of the first
machine that looks at (polls) the lock and notices that no lock is held.
This implies that no *condor\_schedd* daemon is running. This
*condor\_master* daemon acquires the lock and runs the *condor\_schedd*
daemon. Other machines with this same capability to run the
*condor\_schedd* daemon look at (poll) the lock, but do not run the
daemon, as the lock is held. The machine running the *condor\_schedd*
daemon renews the lock periodically.

If the machine running the *condor\_schedd* daemon fails to renew the
lock (because the machine is not functioning), the lock times out
(becomes stale). The lock is released by the *condor\_master* daemon if
*condor\_off* or *condor\_off -schedd* is executed, or when the
*condor\_master* daemon knows that the *condor\_schedd* daemon is no
longer running. As other machines capable of running the
*condor\_schedd* daemon look at the lock (poll), one machine will be the
first to notice that the lock has timed out or been released. This
machine (correctly) interprets this situation as the *condor\_schedd*
daemon is no longer running. This machine’s *condor\_master* daemon then
acquires the lock and runs the *condor\_schedd* daemon.

See section \ `3.5.7 <ConfigurationMacros.html#x33-1940003.5.7>`__, in
the section on *condor\_master* Configuration File Macros for details
relating to the configuration variables used to set timing and polling
intervals.

Working with Remote Job Submission
''''''''''''''''''''''''''''''''''

Remote job submission requires identification of the job queue,
submitting with a command similar to:

::

      % condor_submit -remote condor@example.com myjob.submit

This implies the identification of a single *condor\_schedd* daemon,
running on a single machine. With the high availability of the job
queue, there are multiple *condor\_schedd* daemons, of which only one at
a time is acting as the single submission point. To make remote
submission of jobs work properly, set the configuration variable
SCHEDD\_NAME in the local configuration to have the same value for each
potentially running *condor\_schedd* daemon. In addition, the value
chosen for the variable SCHEDD\_NAME will need to include the at symbol
(@), such that HTCondor will not modify the value set for this variable.
See the description of MASTER\_NAME in
section \ `3.5.7 <ConfigurationMacros.html#x33-1940003.5.7>`__ on
page \ `646 <ConfigurationMacros.html#x33-1940003.5.7>`__ for defaults
and composition of valid values for SCHEDD\_NAME. As an example, include
in each local configuration a value similar to:

::

    SCHEDD_NAME = had-schedd@

Then, with this sample configuration, the submit command appears as:

::

      % condor_submit -remote had-schedd@  myjob.submit

High Availability of the Central Manager
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Interaction with Flocking
'''''''''''''''''''''''''

The HTCondor high availability mechanisms discussed in this section
currently do not work well in configurations involving flocking. The
individual problems listed listed below interact to make the situation
worse. Because of these problems, we advise against the use of flocking
to pools with high availability mechanisms enabled.

-  The *condor\_schedd* has a hard configured list of
   *condor\_collector* and *condor\_negotiator* daemons, and does not
   query redundant collectors to get the current *condor\_negotiator*,
   as it does when communicating with its local pool. As a result, if
   the default *condor\_negotiator* fails, the *condor\_schedd* does not
   learn of the failure, and thus, talk to the new *condor\_negotiator*.
-  When the *condor\_negotiator* is unable to communicate with a
   *condor\_collector*, it utilizes the next *condor\_collector* within
   the list. Unfortunately, it does not start over at the top of the
   list. When combined with the previous problem, a backup
   *condor\_negotiator* will never get jobs from a flocked
   *condor\_schedd*.

Introduction
''''''''''''

The *condor\_negotiator* and *condor\_collector* daemons are the heart
of the HTCondor matchmaking system. The availability of these daemons is
critical to an HTCondor pool’s functionality. Both daemons usually run
on the same machine, most often known as the central manager. The
failure of a central manager machine prevents HTCondor from matching new
jobs and allocating new resources. High availability of the
*condor\_negotiator* and *condor\_collector* daemons eliminates this
problem.

Configuration allows one of multiple machines within the pool to
function as the central manager. While there are may be many active
*condor\_collector* daemons, only a single, active *condor\_negotiator*
daemon will be running. The machine with the *condor\_negotiator* daemon
running is the active central manager. The other potential central
managers each have a *condor\_collector* daemon running; these are the
idle central managers.

All submit and execute machines are configured to report to all
potential central manager machines.

Each potential central manager machine runs the high availability
daemon, *condor\_had*. These daemons communicate with each other,
constantly monitoring the pool to ensure that one active central manager
is available. If the active central manager machine crashes or is shut
down, these daemons detect the failure, and they agree on which of the
idle central managers is to become the active one. A protocol determines
this.

In the case of a network partition, idle *condor\_had* daemons within
each partition detect (by the lack of communication) a partitioning, and
then use the protocol to chose an active central manager. As long as the
partition remains, and there exists an idle central manager within the
partition, there will be one active central manager within each
partition. When the network is repaired, the protocol returns to having
one central manager.

Through configuration, a specific central manager machine may act as the
primary central manager. While this machine is up and running, it
functions as the central manager. After a failure of this primary
central manager, another idle central manager becomes the active one.
When the primary recovers, it again becomes the central manager. This is
a recommended configuration, if one of the central managers is a
reliable machine, which is expected to have very short periods of
instability. An alternative configuration allows the promoted active
central manager (in the case that the central manager fails) to stay
active after the failed central manager machine returns.

This high availability mechanism operates by monitoring communication
between machines. Note that there is a significant difference in
communications between machines when

#. a machine is down
#. a specific daemon (the *condor\_had* daemon in this case) is not
   running, yet the machine is functioning

The high availability mechanism distinguishes between these two, and it
operates based only on first (when a central manager machine is down). A
lack of executing daemons does not cause the protocol to choose or use a
new active central manager.

The central manager machine contains state information, and this
includes information about user priorities. The information is kept in a
single file, and is used by the central manager machine. Should the
primary central manager fail, a pool with high availability enabled
would lose this information (and continue operation, but with
re-initialized priorities). Therefore, the *condor\_replication* daemon
exists to replicate this file on all potential central manager machines.
This daemon promulgates the file in a way that is safe from error, and
more secure than dependence on a shared file system copy.

The *condor\_replication* daemon runs on each potential central manager
machine as well as on the active central manager machine. There is a
unidirectional communication between the *condor\_had* daemon and the
*condor\_replication* daemon on each machine. To properly do its job,
the *condor\_replication* daemon must transfer state files. When it
needs to transfer a file, the *condor\_replication* daemons at both the
sending and receiving ends of the transfer invoke the
*condor\_transferer* daemon. These short lived daemons do the task of
file transfer and then exit. Do not place TRANSFERER into DAEMON\_LIST,
as it is not a daemon that the *condor\_master* should invoke or watch
over.

Configuration
'''''''''''''

The high availability of central manager machines is enabled through
configuration. It is disabled by default. All machines in a pool must be
configured appropriately in order to make the high availability
mechanism work. See
section \ `3.5.26 <ConfigurationMacros.html#x33-2220003.5.26>`__, for
definitions of these configuration variables.

The *condor\_had* and *condor\_replication* daemons use the
*condor\_shared\_port* daemon by default. If you want to use more than
one *condor\_had* or *condor\_replication* daemon with the
*condor\_shared\_port* daemon under the same master, you must configure
those additional daemons to use nondefault socket names. (Set the -sock
option in <NAME>\_ARGS.) Because the *condor\_had* daemon must know the
*condor\_replication* daemon’s address a priori, you will also need to
set <NAME>.REPLICATION\_SOCKET\_NAME appropriately.

The stabilization period is the time it takes for the *condor\_had*
daemons to detect a change in the pool state such as an active central
manager failure or network partition, and recover from this change. It
may be computed using the following formula:

::

    stabilization period = 12 * (number of central managers) *
                               $(HAD_CONNECTION_TIMEOUT)

To disable the high availability of central managers mechanism, it is
sufficient to remove HAD, REPLICATION, and NEGOTIATOR from the
DAEMON\_LIST configuration variable on all machines, leaving only one
*condor\_negotiator* in the pool.

To shut down a currently operating high availability mechanism, follow
the given steps. All commands must be invoked from a host which has
administrative permissions on all central managers. The first three
commands kill all *condor\_had*, *condor\_replication*, and all running
*condor\_negotiator* daemons. The last command is invoked on the host
where the single *condor\_negotiator* daemon is to run.

#. condor\_off -all -neg
#. condor\_off -all -subsystem -replication
#. condor\_off -all -subsystem -had
#. condor\_on -neg

When configuring *condor\_had* to control the *condor\_negotiator*, if
the default backoff constant value is too small, it can result in a
churning of the *condor\_negotiator*, especially in cases in which the
primary negotiator is unable to run due to misconfiguration. In these
cases, the *condor\_master* will kill the *condor\_had* after the
*condor\_negotiator* exists, wait a short period, then restart
*condor\_had*. The *condor\_had* will then win the election, so the
secondary *condor\_negotiator* will be killed, and the primary will be
restarted, only to exit again. If this happens too quickly, neither
*condor\_negotiator* will run long enough to complete a negotiation
cycle, resulting in no jobs getting started. Increasing this value via
MASTER\_HAD\_BACKOFF\_CONSTANT to be larger than a typical negotiation
cycle can help solve this problem.

To run a high availability pool without the replication feature, do the
following operations:

#. Set the HAD\_USE\_REPLICATION configuration variable to False, and
   thus disable the replication on configuration level.
#. Remove REPLICATION from both DAEMON\_LIST and DC\_DAEMON\_LIST in the
   configuration file.

Sample Configuration
''''''''''''''''''''

This section provides sample configurations for high availability.

We begin with a sample configuration using shared port, and then include
a sample configuration for not using shared port. Both samples relate to
the high availability of central managers.

Each sample is split into two parts: the configuration for the central
manager machines, and the configuration for the machines that will not
be central managers.

The following shared-port configuration is for the central manager
machines.

::

    ## THE FOLLOWING MUST BE IDENTICAL ON ALL CENTRAL MANAGERS
     
     CENTRAL_MANAGER1 = cm1.domain.name
     CENTRAL_MANAGER2 = cm2.domain.name
     CONDOR_HOST = $(CENTRAL_MANAGER1), $(CENTRAL_MANAGER2)
     
     # Since we're using shared port, we set the port number to the shared
     # port daemon's port number.  NOTE: this assumes that each machine in
     # the list is using the same port number for shared port.  While this
     # will be true by default, if you've changed it in configuration any-
     # where, you need to reflect that change here.
     
     HAD_USE_SHARED_PORT = TRUE
     HAD_LIST = \
     $(CENTRAL_MANAGER1):$(SHARED_PORT_PORT), \
     $(CENTRAL_MANAGER2):$(SHARED_PORT_PORT)
     
     REPLICATION_USE_SHARED_PORT = TRUE
     REPLICATION_LIST = \
     $(CENTRAL_MANAGER1):$(SHARED_PORT_PORT), \
     $(CENTRAL_MANAGER2):$(SHARED_PORT_PORT)
     
     # The recommended setting.
     HAD_USE_PRIMARY = TRUE
     
     # If you change which daemon(s) you're making highly-available, you must
     # change both of these values.
     HAD_CONTROLLEE = NEGOTIATOR
     MASTER_NEGOTIATOR_CONTROLLER = HAD
     
     ## THE FOLLOWING MAY DIFFER BETWEEN CENTRAL MANAGERS
     
     # The daemon list may contain additional entries.
     DAEMON_LIST = MASTER, COLLECTOR, NEGOTIATOR, HAD, REPLICATION
     
     # Using replication is optional.
     HAD_USE_REPLICATION = TRUE
     
     # This is the default location for the state file.
     STATE_FILE = $(SPOOL)/Accountantnew.log
     
     # See note above the length of the negotiation cycle.
     MASTER_HAD_BACKOFF_CONSTANT = 360

The following shared-port configuration is for the machines which that
will not be central managers.

::

    CENTRAL_MANAGER1 = cm1.domain.name
     CENTRAL_MANAGER2 = cm2.domain.name
     CONDOR_HOST = $(CENTRAL_MANAGER1), $(CENTRAL_MANAGER2)

The following configuration sets fixed port numbers for the central
manager machines.

::

    ##########################################################################
     # A sample configuration file for central managers, to enable the        #
     # the high availability  mechanism.                                      #
     ##########################################################################
     
     #########################################################################
     ## THE FOLLOWING MUST BE IDENTICAL ON ALL POTENTIAL CENTRAL MANAGERS.   #
     #########################################################################
     ## For simplicity in writing other expressions, define a variable
     ## for each potential central manager in the pool.
     ## These are samples.
     CENTRAL_MANAGER1 = cm1.domain.name
     CENTRAL_MANAGER2 = cm2.domain.name
     ## A list of all potential central managers in the pool.
     CONDOR_HOST = $(CENTRAL_MANAGER1),$(CENTRAL_MANAGER2)
     
     ## Define the port number on which the condor_had daemon will
     ## listen.  The port must match the port number used
     ## for when defining HAD_LIST.  This port number is
     ## arbitrary; make sure that there is no port number collision
     ## with other applications.
     HAD_PORT = 51450
     HAD_ARGS = -f -p $(HAD_PORT)
     
     ## The following macro defines the port number condor_replication will listen
     ## on on this machine. This port should match the port number specified
     ## for that replication daemon in the REPLICATION_LIST
     ## Port number is arbitrary (make sure no collision with other applications)
     ## This is a sample port number
     REPLICATION_PORT = 41450
     REPLICATION_ARGS = -p $(REPLICATION_PORT)
     
     ## The following list must contain the same addresses in the same order
     ## as CONDOR_HOST. In addition, for each hostname, it should specify
     ## the port number of condor_had daemon running on that host.
     ## The first machine in the list will be the PRIMARY central manager
     ## machine, in case HAD_USE_PRIMARY is set to true.
     HAD_LIST = \
     $(CENTRAL_MANAGER1):$(HAD_PORT), \
     $(CENTRAL_MANAGER2):$(HAD_PORT)
     
     ## The following list must contain the same addresses
     ## as HAD_LIST. In addition, for each hostname, it should specify
     ## the port number of condor_replication daemon running on that host.
     ## This parameter is mandatory and has no default value
     REPLICATION_LIST = \
     $(CENTRAL_MANAGER1):$(REPLICATION_PORT), \
     $(CENTRAL_MANAGER2):$(REPLICATION_PORT)
     
     ## The following is the name of the daemon that the HAD controls.
     ## This must match the name of a daemon in the master's DAEMON_LIST.
     ## The default is NEGOTIATOR, but can be any daemon that the master
     ## controls.
     HAD_CONTROLLEE = NEGOTIATOR
     
     ## HAD connection time.
     ## Recommended value is 2 if the central managers are on the same subnet.
     ## Recommended value is 5 if Condor security is enabled.
     ## Recommended value is 10 if the network is very slow, or
     ## to reduce the sensitivity of HA daemons to network failures.
     HAD_CONNECTION_TIMEOUT = 2
     
     ##If true, the first central manager in HAD_LIST is a primary.
     HAD_USE_PRIMARY = true
     
     
     ###################################################################
     ## THE PARAMETERS BELOW ARE ALLOWED TO BE DIFFERENT ON EACH       #
     ## CENTRAL MANAGER                                                #
     ## THESE ARE MASTER SPECIFIC PARAMETERS
     ###################################################################
     
     
     ## the master should start at least these four daemons
     DAEMON_LIST = MASTER, COLLECTOR, NEGOTIATOR, HAD, REPLICATION
     
     
     ## Enables/disables the replication feature of HAD daemon
     ## Default: false
     HAD_USE_REPLICATION    = true
     
     ## Name of the file from the SPOOL directory that will be replicated
     ## Default: $(SPOOL)/Accountantnew.log
     STATE_FILE = $(SPOOL)/Accountantnew.log
     
     ## Period of time between two successive awakenings of the replication daemon
     ## Default: 300
     REPLICATION_INTERVAL                 = 300
     
     ## Period of time, in which transferer daemons have to accomplish the
     ## downloading/uploading process
     ## Default: 300
     MAX_TRANSFER_LIFETIME                = 300
     
     
     ## Period of time between two successive sends of classads to the collector by HAD
     ## Default: 300
     HAD_UPDATE_INTERVAL = 300
     
     
     ## The HAD controls the negotiator, and should have a larger
     ## backoff constant
     MASTER_NEGOTIATOR_CONTROLLER = HAD
     MASTER_HAD_BACKOFF_CONSTANT = 360

The configuration for machines that will not be central managers is
identical for the fixed- and shared- port cases.

::

    ##########################################################################
     # Sample configuration relating to high availability for machines        #
     # that DO NOT run the condor_had daemon.                                 #
     ##########################################################################
     
     ## For simplicity define a variable for each potential central manager
     ## in the pool.
     CENTRAL_MANAGER1 = cm1.domain.name
     CENTRAL_MANAGER2 = cm2.domain.name
     ## List of all potential central managers in the pool
     CONDOR_HOST = $(CENTRAL_MANAGER1),$(CENTRAL_MANAGER2)

      
