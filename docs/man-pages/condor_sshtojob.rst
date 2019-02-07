      

condor\_ssh\_to\_job
====================

create an ssh session to a running job

Synopsis
--------

**condor\_ssh\_to\_job** [**-help**\ ]

**condor\_ssh\_to\_job** [**-debug**\ ] [**-name  **\ *schedd-name*]
[**-pool  **\ *pool-name*] [**-ssh  **\ *ssh-command*]
[**-keygen-options  **\ *ssh-keygen-options*]
[**-shells  **\ *shell1,shell2,...*] [**-auto-retry**\ ]
[**-remove-on-interrupt**\ ] *cluster \| cluster.process \|
cluster.process.node* [*remote-command*\ ]

Description
-----------

*condor\_ssh\_to\_job* creates an *ssh* session to a running job. The
job is specified with the argument. If only the job *cluster* id is
given, then the job *process* id defaults to the value 0.

*condor\_ssh\_to\_job* is available in Unix HTCondor distributions, and
works with two kinds of jobs: those in the vanilla, vm, java, local, or
parallel universes, and those jobs in the grid universe which use EC2
resources. It will not work with other grid universe jobs.

For jobs in the vanilla, vm, java, local, or parallel universes, the
user must be the owner of the job or must be a queue super user, and
both the *condor\_schedd* and *condor\_starter* daemons must allow
*condor\_ssh\_to\_job* access. If no *remote-command* is specified, an
interactive shell is created. An alternate *ssh* program such as *sftp*
may be specified, using the **-ssh** option, for uploading and
downloading files.

The remote command or shell runs with the same user id as the running
job, and it is initialized with the same working directory. The
environment is initialized to be the same as that of the job, plus any
changes made by the shell setup scripts and any environment variables
passed by the *ssh* client. In addition, the environment variable
``_CONDOR_JOB_PIDS`` is defined. It is a space-separated list of PIDs
associated with the job. At a minimum, the list will contain the PID of
the process started when the job was launched, and it will be the first
item in the list. It may contain additional PIDs of other processes that
the job has created.

The *ssh* session and all processes it creates are treated by HTCondor
as though they are processes belonging to the job. If the slot is
preempted or suspended, the *ssh* session is killed or suspended along
with the job. If the job exits before the *ssh* session finishes, the
slot remains in the Claimed Busy state and is treated as though not all
job processes have exited until all *ssh* sessions are closed. Multiple
*ssh* sessions may be created to the same job at the same time. Resource
consumption of the *sshd* process and all processes spawned by it are
monitored by the *condor\_starter* as though these processes belong to
the job, so any policies such as ``PREEMPT`` that enforce a limit on
resource consumption also take into account resources consumed by the
*ssh* session.

*condor\_ssh\_to\_job* stores ssh keys in temporary files within a newly
created and uniquely named directory. The newly created directory will
be within the directory defined by the environment variable ``TMPDIR``.
When the ssh session is finished, this directory and the ssh keys
contained within it are removed.

See the HTCondor administrator’s manual section on configuration for
details of the configuration variables related to
*condor\_ssh\_to\_job*.

An *ssh* session works by first authenticating and authorizing a secure
connection between *condor\_ssh\_to\_job* and the *condor\_starter*
daemon, using HTCondor protocols. The *condor\_starter* generates an ssh
key pair and sends it securely to *condor\_ssh\_to\_job*. Then the
*condor\_starter* spawns *sshd* in inetd mode with its stdin and stdout
attached to the TCP connection from *condor\_ssh\_to\_job*.
*condor\_ssh\_to\_job* acts as a proxy for the *ssh* client to
communicate with *sshd*, using the existing connection authorized by
HTCondor. At no point is *sshd* listening on the network for connections
or running with any privileges other than that of the user identity
running the job. If CCB is being used to enable connectivity to the
execute node from outside of a firewall or private network,
*condor\_ssh\_to\_job* is able to make use of CCB in order to form the
*ssh* connection.

The login shell of the user id running the job is used to run the
requested command, *sshd* subsystem, or interactive shell. This is
hard-coded behavior in *OpenSSH* and cannot be overridden by
configuration. This means that *condor\_ssh\_to\_job* access is
effectively disabled if the login shell disables access, as in the
example programs */bin/true* and */sbin/nologin*.

*condor\_ssh\_to\_job* is intended to work with *OpenSSH* as installed
in typical environments. It does not work on Windows platforms. If the
*ssh* programs are installed in non-standard locations, then the paths
to these programs will need to be customized within the HTCondor
configuration. Versions of *ssh* other than *OpenSSH* may work, but they
will likely require additional configuration of command-line arguments,
changes to the *sshd* configuration template file, and possibly
modification of the $(LIBEXEC)/condor\_ssh\_to\_job\_sshd\_setup script
used by the *condor\_starter* to set up *sshd*.

For jobs in the grid universe which use EC2 resources, a request that
HTCondor have the EC2 service create a new key pair for the job by
specifying **ec2\_keypair\_file** causes *condor\_ssh\_to\_job* to
attempt to connect to the corresponding instance via *ssh*. This
attempts invokes *ssh* directly, bypassing the HTCondor networking
layer. It supplies *ssh* with the public DNS name of the instance and
the name of the file with the new key pair’s private key. For the
connection to succeed, the instance must have started an *ssh* server,
and its security group(s) must allow connections on port 22.
Conventionally, images will allow logins using the key pair on a single
specific account. Because *ssh* defaults to logging in as the current
user, the **-l <username>** option or its equivalent for other versions
of *ssh* will be needed as part of the *remote-command* argument.
Although the **-X** option does not apply to EC2 jobs, adding **-X** or
**-Y** to the *remote-command* argument can duplicate the effect.

Options
-------

 **-help**
    Display brief usage information and exit.
 **-debug**
    Causes debugging information to be sent to ``stderr``, based on the
    value of the configuration variable ``TOOL_DEBUG``.
 **-name **\ *schedd-name*
    Specify an alternate *condor\_schedd*, if the default (local) one is
    not desired.
 **-pool **\ *pool-name*
    Specify an alternate HTCondor pool, if the default one is not
    desired. Does not apply to EC2 jobs.
 **-ssh **\ *ssh-command*
    Specify an alternate *ssh* program to run in place of *ssh*, for
    example *sftp* or *scp*. Additional arguments are specified as
    *ssh-command*. Since the arguments are delimited by spaces, place
    double quote marks around the whole command, to prevent the shell
    from splitting it into multiple arguments to *condor\_ssh\_to\_job*.
    If any arguments must contain spaces, enclose them within single
    quotes. Does not apply to EC2 jobs.
 **-keygen-options **\ *ssh-keygen-options*
    Specify additional arguments to the *ssh\_keygen* program, for
    creating the ssh key that is used for the duration of the session.
    For example, a different number of bits could be used, or a
    different key type than the default. Does not apply to EC2 jobs.
 **-shells **\ *shell1,shell2,...*
    Specify a comma-separated list of shells to attempt to launch. If
    the first shell does not exist on the remote machine, then the
    following ones in the list will be tried. If none of the specified
    shells can be found, */bin/sh* is used by default. If this option is
    not specified, it defaults to the environment variable ``SHELL``
    from within the *condor\_ssh\_to\_job* environment. Does not apply
    to EC2 jobs.
 **-auto-retry**
    Specifies that if the job is not yet running, *condor\_ssh\_to\_job*
    should keep trying periodically until it succeeds or encounters some
    other error.
 **-remove-on-interrupt**
    If specified, attempt to remove the job from the queue if
    *condor\_ssh\_to\_job* is interrupted via a CTRL-c or otherwise
    terminated abnormally.
 **-X**
    Enable X11 forwarding. Does not apply to EC2 jobs.
 **-x**
    Disable X11 forwarding.

Examples
--------

::

    % condor_ssh_to_job 32.0 
    Welcome to slot2@tonic.cs.wisc.edu! 
    Your condor job is running with pid(s) 65881. 
    % gdb -p 65881 
    (gdb) where 
    ... 
    % logout 
    Connection to condor-job.tonic.cs.wisc.edu closed.

To upload or download files interactively with *sftp*:

::

    % condor_ssh_to_job -ssh sftp 32.0 
    Connecting to condor-job.tonic.cs.wisc.edu... 
    sftp> ls 
    ... 
    sftp> get outputfile.dat

This example shows downloading a file from the job with *scp*. The
string "remote" is used in place of a host name in this example. It is
not necessary to insert the correct remote host name, or even a valid
one, because the connection to the job is created automatically.
Therefore, the placeholder string "remote" is perfectly fine.

::

    % condor_ssh_to_job -ssh scp 32 remote:outputfile.dat .

This example uses *condor\_ssh\_to\_job* to accomplish the task of
running *rsync* to synchronize a local file with a remote file in the
job’s working directory. Job id 32.0 is used in place of a host name in
this example. This causes *rsync* to insert the expected job id in the
arguments to *condor\_ssh\_to\_job*.

::

    % rsync -v -e "condor_ssh_to_job" 32.0:outputfile.dat .

Note that *condor\_ssh\_to\_job* was added to HTCondor in version 7.3.
If one uses *condor\_ssh\_to\_job* to connect to a job on an execute
machine running a version of HTCondor older than the 7.3 series, the
command will fail with the error message

::

    Failed to send CREATE_JOB_OWNER_SEC_SESSION to starter

Exit Status
-----------

*condor\_ssh\_to\_job* will exit with a non-zero status value if it
fails to set up an ssh session. If it succeeds, it will exit with the
status value of the remote command or shell.

Author
------

Center for High Throughput Computing, University of Wisconsin–Madison

Copyright
---------

Copyright © 1990-2019 Center for High Throughput Computing, Computer
Sciences Department, University of Wisconsin-Madison, Madison, WI. All
Rights Reserved. Licensed under the Apache License, Version 2.0.

      
