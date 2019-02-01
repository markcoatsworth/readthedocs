      

Configuration Templates
=======================

Achieving certain behaviors in an HTCondor pool often requires setting
the values of a number of configuration macros in concert with each
other. We have added configuration templates as a way to do this more
easily, at a higher level, without having to explicitly set each
individual configuration macro.

Configuration templates are pre-defined; users cannot define their own
templates.

Note that the value of an individual configuration macro that is set by
a configuration template can be overridden by setting that configuration
macro later in the configuration.

Detailed information about configuration templates (such as the macros
they set) can be obtained using the *condor\_config\_val* use option
(see `12 <Condorconfigval.html#x105-73100012>`__). (This document does
not contain such information because the *condor\_config\_val* command
is a better way to obtain it.)

Configuration Templates: Using Predefined Sets of Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Predefined sets of configuration can be identified and incorporated into
the configuration using the syntax

::

      use <category name> : <template name>

The use key word is case insensitive. There are no requirements for
white space characters surrounding the colon character. More than one
<template name> identifier may be placed within a single use line.
Separate the names by a space character. There is no mechanism by which
the administrator may define their own custom <category name> or
<template name>.

Each predefined <category name> has a fixed, case insensitive name for
the sets of configuration that are predefined. Placement of a use line
in the configuration brings in the predefined configuration it
identifies.

As of version 8.5.6, some of the configuration templates take arguments
(as described below).

Available Configuration Templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are four <category name> values. Within a category, a predefined,
case insensitive name identifies the set of configuration it
incorporates.

 ROLE category
    Describes configuration for the various roles that a machine might
    play within an HTCondor pool. The configuration will identify which
    daemons are running on a machine.

    -  Personal

       Settings needed for when a single machine is the entire pool.

    -  Submit

       Settings needed to allow this machine to submit jobs to the pool.
       May be combined with Execute and CentralManager roles.

    -  Execute

       Settings needed to allow this machine to execute jobs. May be
       combined with Submit and CentralManager roles.

    -  CentralManager

       Settings needed to allow this machine to act as the central
       manager for the pool. May be combined with Submit and Execute
       roles.

 FEATURE category
    Describes configuration for implemented features.

    -  Remote\_Runtime\_Config

       Enables the use of *condor\_config\_val* **-rset** to the machine
       with this configuration. Note that there are security
       implications for use of this configuration, as it potentially
       permits the arbitrary modification of configuration. Variable
       SETTABLE\_ATTRS\_CONFIG must also be defined.

    -  Remote\_Config

       Enables the use of *condor\_config\_val* **-set** to the machine
       with this configuration. Note that there are security
       implications for use of this configuration, as it potentially
       permits the arbitrary modification of configuration. Variable
       SETTABLE\_ATTRS\_CONFIG must also be defined.

    -  VMware

       Enables use of the vm universe with VMware virtual machines. Note
       that this feature depends on Perl.

    -  GPUs

       Sets configuration based on detection with the
       *condor\_gpu\_discovery* tool, and defines a custom resource
       using the name GPUs. Supports both OpenCL and CUDA, if detected.
       Automatically includes the GPUsMonitor feature.

    -  GPUsMonitor

       Also adds configuration to report the usage of NVidia GPUs.

    -  Monitor( resource\_name, mode, period, executable, metric[,
       metric]+ )

       Configures a custom machine resource monitor with the given name,
       mode, period, executable, and metrics. See
       `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for the definitions of
       these terms.

    -  PartitionableSlot( slot\_type\_num [, allocation] )

       Sets up a partitionable slot of the specified slot type number
       and allocation (defaults for slot\_type\_num and allocation are 1
       and 100% respectively).
       See \ `3.7.1 <PolicyConfigurationforExecuteHostsandforSubmitHosts.html#x35-2540003.7.1>`__
       for information on partitionalble slot policies.

    -  AssignAccountingGroup( map\_filename ) Sets up a *condor\_schedd*
       job transform that assigns an accounting group to each job as it
       is submitted. The accounting is determined by mapping the Owner
       attribute of the job using the given map file.
    -  ScheddUserMapFile( map\_name, map\_filename ) Defines a
       *condor\_schedd* usermap named map\_name using the given map
       file.
    -  SetJobAttrFromUserMap( dst\_attr, src\_attr, map\_name [,
       map\_filename] ) Sets up a *condor\_schedd* job transform that
       sets the dst\_attr attribute of each job as it is submitted. The
       value of dst\_attr is determined by mapping the src\_attr of the
       job using the usermap named map\_name. If the optional
       map\_filename argument is specifed, then this metaknob also
       defines a *condor\_schedd* usermap named map\_Name using the
       given map file.
    -  StartdCronOneShot( job\_name, exe [, hook\_args] )

       Create a one-shot *condor\_startd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  StartdCronPeriodic( job\_name, period, exe [, hook\_args] )

       Create a periodic-shot *condor\_startd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  StartdCronContinuous( job\_name, exe [, hook\_args] )

       Create a (nearly) continuous *condor\_startd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  ScheddCronOneShot( job\_name, exe [, hook\_args] )

       Create a one-shot *condor\_schedd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  ScheddCronPeriodic( job\_name, period, exe [, hook\_args] )

       Create a periodic-shot *condor\_schedd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  ScheddCronContinuous( job\_name, exe [, hook\_args] )

       Create a (nearly) continuous *condor\_schedd* job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  OneShotCronHook( STARTD\_CRON \| SCHEDD\_CRON, job\_name,
       hook\_exe [,hook\_args] )

       Create a one-shot job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  PeriodicCronHook( STARTD\_CRON \| SCHEDD\_CRON , job\_name,
       period, hook\_exe [,hook\_args] )

       Create a periodic job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

    -  ContinuousCronHook( STARTD\_CRON \| SCHEDD\_CRON , job\_name,
       hook\_exe [,hook\_args] )

       Create a (nearly) continuous job hook.
       (See `4.4.3 <Hooks.html#x51-4450004.4.3>`__ for more information
       about job hooks.)

        

    -  UWCS\_Desktop\_Policy\_Values

       Configuration values used in the UWCS\_DESKTOP policy. (Note that
       these values were previously in the parameter table;
       configuration that uses these values will have to use the
       UWCS\_Desktop\_Policy\_Values template. For example, POLICY :
       UWCS\_Desktop uses the FEATURE : UWCS\_Desktop\_Policy\_Values
       template.)

 POLICY category
    Describes configuration for the circumstances under which machines
    choose to run jobs.

    -  Always\_Run\_Jobs

       Always start jobs and run them to completion, without
       consideration of *condor\_negotiator* generated preemption or
       suspension. This is the default policy, and it is intended to be
       used with dedicated resources. If this policy is used together
       with the Limit\_Job\_Runtimes policy, order the specification by
       placing this Always\_Run\_Jobs policy first.

    -  UWCS\_Desktop

       This was the default policy before HTCondor version 8.1.6. It is
       intended to be used with desktop machines not exclusively running
       HTCondor jobs. It injects UWCS into the name of some
       configuration variables.

    -  Desktop

       An updated and reimplementation of the UWCS\_Desktop policy, but
       without the UWCS naming of some configuration variables.

    -  Limit\_Job\_Runtimes( limit\_in\_seconds )

       Limits running jobs to a maximum of the specified time using
       preemption. (The default limit is 24 hours.) This policy does not
       work while the machine is draining; use the following policy
       instead.

       If this policy is used together with the Always\_Run\_Jobs
       policy, order the specification by placing this
       Limit\_Job\_Runtimes policy second.

    -  Preempt\_if\_Runtime\_Exceeds( limit\_in\_seconds )

       Limits running jobs to a maximum of the specified time using
       preemption. (The default limit is 24 hours).

    -  Hold\_if\_Runtime\_Exceeds( limit\_in\_seconds )

       Limits running jobs to a maximum of the specified time by placing
       them on hold immediately (ignoring any job retirement time). (The
       default limit is 24 hours).

    -  Preempt\_If\_Cpus\_Exceeded

       If the startd observes the number of CPU cores used by the job
       exceed the number of cores in the slot by more than 0.8 on
       average over the past minute, preempt the job immediately
       ignoring any job retirement time.

    -  Hold\_If\_Cpus\_Exceeded

       If the startd observes the number of CPU cores used by the job
       exceed the number of cores in the slot by more than 0.8 on
       average over the past minute, immediately place the job on hold
       ignoring any job retirement time. The job will go on hold with a
       reasonable hold reason in job attribute HoldReason and a value of
       101 in job attribute HoldReasonCode. The hold reason and code can
       be customized by specifying HOLD\_REASON\_CPU\_EXCEEDED and
       HOLD\_SUBCODE\_CPU\_EXCEEDED respectively.

       Standard universe jobs can’t be held by startd policy
       expressions, so this metaknob automatically ignores them.

    -  Preempt\_If\_Memory\_Exceeded

       If the startd observes the memory usage of the job exceed the
       memory provisioned in the slot, preempt the job immediately
       ignoring any job retirement time.

    -  Hold\_If\_Memory\_Exceeded

       If the startd observes the memory usage of the job exceed the
       memory provisioned in the slot, immediately place the job on hold
       ignoring any job retirement time. The job will go on hold with a
       reasonable hold reason in job attribute HoldReason and a value of
       102 in job attribute HoldReasonCode. The hold reason and code can
       be customized by specifying HOLD\_REASON\_MEMORY\_EXCEEDED and
       HOLD\_SUBCODE\_MEMORY\_EXCEEDED respectively.

       Standard universe jobs can’t be held by startd policy
       expressions, so this metaknob automatically ignores them.

    -  Preempt\_If( policy\_variable )

       Preempt jobs according to the specified policy. policy\_variable
       must be the name of a configuration macro containing an
       expression that evaluates to True if the job should be preempted.

       See an example here:  `3.4.4 <#x32-1860003.4.4>`__.

    -  Want\_Hold\_If( policy\_variable, subcode, reason\_text )

       Add the given policy to the WANT\_HOLD expression; if the
       WANT\_HOLD expression is defined, policy\_variable is prepended
       to the existing expression; otherwise WANT\_HOLD is simply set to
       the value of the textttpolicy\_variable macro.

       Standard universe jobs can’t be held by startd policy
       expressions, so this metaknob automatically ignores them.

       See an example here:  `3.4.4 <#x32-1860003.4.4>`__.

    -  Startd\_Publish\_CpusUsage

       Publish the number of CPU cores being used by the job into to
       slot ad as attribute CpusUsage. This value will be the average
       number of cores used by the job over the past minute, sampling
       every 5 seconds.

 SECURITY category
    Describes configuration for an implemented security model.

    -  Host\_Based

       The default security model (based on IPs and DNS names). Do not
       combine with User\_Based security.

    -  User\_Based

       Grants permissions to an administrator and uses
       With\_Authentication. Do not combine with Host\_Based security.

    -  With\_Authentication

       Requires both authentication and integrity checks.

    -  Strong

       Requires authentication, encryption, and integrity checks.

Configuration Template Transition Syntax
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For pools that are transitioning to using this new syntax in
configuration, while still having some tools and daemons with HTCondor
versions earlier than 8.1.6, special syntax in the configuration will
cause those daemons to fail upon start up, rather than use the new, but
misinterpreted, syntax. Newer daemons will ignore the extra syntax.
Placing the @ character before the use key word causes the older daemons
to fail when they attempt to parse this syntax.

As an example, consider the *condor\_startd* as it starts up. A
*condor\_startd* previous to HTCondor version 8.1.6 fails to start when
it sees:

::

    @use feature : GPUs

Running an older *condor\_config\_val* also identifies the @use line as
being bad. A *condor\_startd* of HTCondor version 8.1.6 or more recent
sees

::

    use feature : GPUs

Configuration Template Examples
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  Preempt a job if its memory usage exceeds the requested memory:

   ::

       MEMORY_EXCEEDED = (isDefined(MemoryUsage) && MemoryUsage > RequestMemory)
        use POLICY : PREEMPT_IF(MEMORY_EXCEEDED)
            

-  Put a job on hold if its memory usage exceeds the requested memory:

   ::

       MEMORY_EXCEEDED = (isDefined(MemoryUsage) && MemoryUsage > RequestMemory)
        use POLICY : WANT_HOLD_IF(MEMORY_EXCEEDED, 102, memory usage exceeded request_memory)
            

-  Update dynamic GPU information every 15 minutes:

   ::

       use FEATURE : StartdCronPeriodic(DYNGPU, 15*60, $(LOCAL_DIR)\dynamic_gpu_info.pl, $(LIBEXEC)\condor_gpu_discovery -dynamic)
            

   where dynamic\_gpu\_info.pl is a simple perl script that strips off
   the DetectedGPUs line from textttcondor\_gpu\_discovery:

   ::

       #!/usr/bin/env perl
        my @attrs = `@ARGV`;
        for (@attrs) {
        next if ($_ =~ /^Detected/i);
        print $_;
        }
            

      
