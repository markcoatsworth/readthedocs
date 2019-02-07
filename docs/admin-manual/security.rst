      

Security
========

Security in HTCondor is a broad issue, with many aspects to consider.
Because HTCondor’s main purpose is to allow users to run arbitrary code
on large numbers of computers, it is important to try to limit who can
access an HTCondor pool and what privileges they have when using the
pool. This section covers these topics.

There is a distinction between the kinds of resource attacks HTCondor
can defeat, and the kinds of attacks HTCondor cannot defeat. HTCondor
cannot prevent security breaches of users that can elevate their
privilege to the root or administrator account. HTCondor does not run
user jobs in sandboxes (standard universe jobs are a partial exception
to this), so HTCondor cannot defeat all malicious actions by user jobs.
An example of a malicious job is one that launches a distributed denial
of service attack. HTCondor assumes that users are trustworthy. HTCondor
can prevent unauthorized access to the HTCondor pool, to help ensure
that only trusted users have access to the pool. In addition, HTCondor
provides encryption and integrity checking, to ensure that network
transmissions are not examined or tampered with while in transit.

Broadly speaking, the aspects of security in HTCondor may be categorized
and described:

 Users
    Authorization or capability in an operating system is based on a
    process owner. Both those that submit jobs and HTCondor daemons
    become process owners. The HTCondor system prefers that HTCondor
    daemons are run as the user root, while other common operations are
    owned by a user of HTCondor. Operations that do not belong to either
    root or an HTCondor user are often owned by the condor user. See
    Section \ `3.8.13 <#x36-2960003.8.13>`__ for more detail.
 Authentication
    Proper identification of a user is accomplished by the process of
    authentication. It attempts to distinguish between real users and
    impostors. By default, HTCondor’s authentication uses the user id
    (UID) to determine identity, but HTCondor can choose among a variety
    of authentication mechanisms, including the stronger authentication
    methods Kerberos and GSI.
 Authorization
    Authorization specifies who is allowed to do what. Some users are
    allowed to submit jobs, while other users are allowed administrative
    privileges over HTCondor itself. HTCondor provides authorization on
    either a per-user or on a per-machine basis.
 Privacy
    HTCondor may encrypt data sent across the network, which prevents
    others from viewing the data. With persistence and sufficient
    computing power, decryption is possible. HTCondor can encrypt the
    data sent for internal communication, as well as user data, such as
    files and executables. Encryption operates on network transmissions:
    unencrypted data is stored on disk by default. However, see the
    ``ENCRYPT_EXECUTE_DIRECTORY`` setting for how to encrypt job data on
    the disk of an execute node.
 Integrity
    The man-in-the-middle attack tampers with data without the awareness
    of either side of the communication. HTCondor’s integrity check
    sends additional cryptographic data to verify that network data
    transmissions have not been tampered with. Note that the integrity
    information is only for network transmissions: data stored on disk
    does not have this integrity information. Also note that integrity
    checks are not performed upon job data files that are transferred by
    HTCondor via the File Transfer Mechanism described in
    section \ `2.5.9 <SubmittingaJob.html#x17-380002.5.9>`__.

HTCondor’s Security Model
-------------------------

At the heart of HTCondor’s security model is the notion that
communications are subject to various security checks. A request from
one HTCondor daemon to another may require authentication to prevent
subversion of the system. A request from a user of HTCondor may need to
be denied due to the confidential nature of the request. The security
model handles these example situations and many more.

Requests to HTCondor are categorized into groups of access levels, based
on the type of operation requested. The user of a specific request must
be authorized at the required access level. For example, executing the
*condor\_status* command requires the ``READ`` access level. Actions
that accomplish management tasks, such as shutting down or restarting of
a daemon require an ``ADMINISTRATOR`` access level. See
Section \ `3.8.7 <#x36-2880003.8.7>`__ for a full list of HTCondor’s
access levels and their meanings.

There are two sides to any communication or command invocation in
HTCondor. One side is identified as the client, and the other side is
identified as the daemon. The client is the party that initiates the
command, and the daemon is the party that processes the command and
responds. In some cases it is easy to distinguish the client from the
daemon, while in other cases it is not as easy. HTCondor tools such as
*condor\_submit* and *condor\_config\_val* are clients. They send
commands to daemons and act as clients in all their communications. For
example, the *condor\_submit* command communicates with the
*condor\_schedd*. Behind the scenes, HTCondor daemons also communicate
with each other; in this case the daemon initiating the command plays
the role of the client. For instance, the *condor\_negotiator* daemon
acts as a client when contacting the *condor\_schedd* daemon to initiate
matchmaking. Once a match has been found, the *condor\_schedd* daemon
acts as a client and contacts the *condor\_startd* daemon.

HTCondor’s security model is implemented using configuration. Commands
in HTCondor are executed over TCP/IP network connections. While network
communication enables HTCondor to manage resources that are distributed
across an organization (or beyond), it also brings in security
challenges. HTCondor must have ways of ensuring that communications are
being sent by trustworthy users and not tampered with in transit. These
issues can be addressed with HTCondor’s authentication, encryption, and
integrity features.

Access Level Descriptions
~~~~~~~~~~~~~~~~~~~~~~~~~

Authorization is granted based on specified access levels. This list
describes each access level, and provides examples of their usage. The
levels implement a partial hierarchy; a higher level often implies a
``READ`` or both a ``WRITE`` and a ``READ`` level of access as
described.

 ``READ``
    This access level can obtain or read information about HTCondor.
    Examples that require only ``READ`` access are viewing the status of
    the pool with *condor\_status*, checking a job queue with
    *condor\_q*, or viewing user priorities with *condor\_userprio*.
    ``READ`` access does not allow any changes, and it does not allow
    job submission.
 ``WRITE``
    This access level is required to send (write) information to
    HTCondor. Examples that require ``WRITE`` access are job submission
    with *condor\_submit* and advertising a machine so it appears in the
    pool (this is usually done automatically by the *condor\_startd*
    daemon). The ``WRITE`` level of access implies ``READ`` access.
 ``ADMINISTRATOR``
    This access level has additional HTCondor administrator rights to
    the pool. It includes the ability to change user priorities with the
    command *condor\_userprio*, as well as the ability to turn HTCondor
    on and off (as with the commands *condor\_on* and *condor\_off*).
    The *condor\_fetchlog* tool also requires an ``ADMINISTRATOR``
    access level. The ``ADMINISTRATOR`` level of access implies both
    ``READ`` and ``WRITE`` access.
 ``CONFIG``
    This access level is required to modify a daemon’s configuration
    using the *condor\_config\_val* command. By default, this level of
    access can change any configuration parameters of an HTCondor pool,
    except those specified in the ``condor_config.root`` configuration
    file. The ``CONFIG`` level of access implies ``READ`` access.
 ``OWNER``
    This level of access is required for commands that the owner of a
    machine (any local user) should be able to use, in addition to the
    HTCondor administrators. An example that requires the ``OWNER``
    access level is the *condor\_vacate* command. The command causes the
    *condor\_startd* daemon to vacate any HTCondor job currently running
    on a machine. The owner of that machine should be able to cause the
    removal of a job running on the machine.
 ``DAEMON``
    This access level is used for commands that are internal to the
    operation of HTCondor. An example of this internal operation is when
    the *condor\_startd* daemon sends its ClassAd updates to the
    *condor\_collector* daemon (which may be more specifically
    controlled by the ``ADVERTISE_STARTD`` access level). Authorization
    at this access level should only be given to the user account under
    which the HTCondor daemons run. The ``DAEMON`` level of access
    implies both ``READ`` and ``WRITE`` access.
 ``NEGOTIATOR``
    This access level is used specifically to verify that commands are
    sent by the *condor\_negotiator* daemon. The *condor\_negotiator*
    daemon runs on the central manager of the pool. Commands requiring
    this access level are the ones that tell the *condor\_schedd* daemon
    to begin negotiating, and those that tell an available
    *condor\_startd* daemon that it has been matched to a
    *condor\_schedd* with jobs to run. The ``NEGOTIATOR`` level of
    access implies ``READ`` access.
 ``ADVERTISE_MASTER``
    This access level is used specifically for commands used to
    advertise a *condor\_master* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``ADVERTISE_STARTD``
    This access level is used specifically for commands used to
    advertise a *condor\_startd* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``ADVERTISE_SCHEDD``
    This access level is used specifically for commands used to
    advertise a *condor\_schedd* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``CLIENT``
    This access level is different from all the others. Whereas all of
    the other access levels refer to the security policy for accepting
    connections from others, the ``CLIENT`` access level applies when an
    HTCondor daemon or tool is connecting to some other HTCondor daemon.
    In other words, it specifies the policy of the client that is
    initiating the operation, rather than the server that is being
    contacted.

The following is a list of registered commands that daemons will accept.
The list is ordered by daemon. For each daemon, the commands are grouped
by the access level required for a daemon to accept the command from a
given machine.

ALL DAEMONS:

 ``WRITE``
    The command sent as a result of *condor\_reconfig* to reconfigure a
    daemon.

STARTD:

 ``WRITE``
    All commands that relate to a *condor\_schedd* daemon claiming a
    machine, starting jobs there, or stopping those jobs.

    The command that *condor\_checkpoint* sends to periodically
    checkpoint all running jobs.

 ``READ``
    The command that *condor\_preen* sends to request the current state
    of the *condor\_startd* daemon.

 ``OWNER``
    The command that *condor\_vacate* sends to cause any running jobs to
    stop running.
 ``NEGOTIATOR``
    The command that the *condor\_negotiator* daemon sends to match a
    machine’s *condor\_startd* daemon with a given *condor\_schedd*
    daemon.

NEGOTIATOR:

 ``WRITE``
    The command that initiates a new negotiation cycle. It is sent by
    the *condor\_schedd* when new jobs are submitted or a
    *condor\_reschedule* command is issued.
 ``READ``
    The command that can retrieve the current state of user priorities
    in the pool, sent by the *condor\_userprio* command.
 ``ADMINISTRATOR``
    The command that can set the current values of user priorities, sent
    as a result of the *condor\_userprio* command.

COLLECTOR:

 ``ADVERTISE_MASTER``
    Commands that update the *condor\_collector* daemon with new
    *condor\_master* ClassAds.
 ``ADVERTISE_SCHEDD``
    Commands that update the *condor\_collector* daemon with new
    *condor\_schedd* ClassAds.
 ``ADVERTISE_STARTD``
    Commands that update the *condor\_collector* daemon with new
    *condor\_startd* ClassAds.
 ``DAEMON``
    All other commands that update the *condor\_collector* daemon with
    new ClassAds. Note that the specific access levels such as
    ``ADVERTISE_STARTD`` default to the ``DAEMON`` settings, which in
    turn defaults to ``WRITE``.
 ``READ``
    All commands that query the *condor\_collector* daemon for ClassAds.

SCHEDD:

 ``NEGOTIATOR``
    The command that the *condor\_negotiator* sends to begin negotiating
    with this *condor\_schedd* to match its jobs with available
    *condor\_startds*.
 ``WRITE``
    The command which *condor\_reschedule* sends to the *condor\_schedd*
    to get it to update the *condor\_collector* with a current ClassAd
    and begin a negotiation cycle.

    The commands which write information into the job queue (such as
    *condor\_submit* and *condor\_hold*). Note that for most commands
    which attempt to write to the job queue, HTCondor will perform an
    additional user-level authentication step. This additional
    user-level authentication prevents, for example, an ordinary user
    from removing a different user’s jobs.

 ``READ``
    The command from any tool to view the status of the job queue.

    The commands that a *condor\_startd* sends to the *condor\_schedd*
    when the *condor\_schedd* daemon’s claim is being preempted and also
    when the lease on the claim is renewed. These operations only
    require ``READ`` access, rather than ``DAEMON`` in order to limit
    the level of trust that the *condor\_schedd* must have for the
    *condor\_startd*. Success of these commands is only possible if the
    *condor\_startd* knows the secret claim id, so effectively,
    authorization for these commands is more specific than HTCondor’s
    general security model implies. The *condor\_schedd* automatically
    grants the *condor\_startd* ``READ`` access for the duration of the
    claim. Therefore, if one desires to only authorize specific execute
    machines to run jobs, one must either limit which machines are
    allowed to advertise themselves to the pool (most common) or
    configure the *condor\_schedd*\ ’s ``ALLOW_CLIENT`` setting to only
    allow connections from the *condor\_schedd* to the trusted execute
    machines.

MASTER: All commands are registered with ``ADMINISTRATOR`` access:

 restart
    : Master restarts itself (and all its children)
 off
    : Master shuts down all its children
 off -master
    : Master shuts down all its children and exits
 on
    : Master spawns all the daemons it is configured to spawn

Security Negotiation
--------------------

Because of the wide range of environments and security demands
necessary, HTCondor must be flexible. Configuration provides this
flexibility. The process by which HTCondor determines the security
settings that will be used when a connection is established is called
security negotiation. Security negotiation’s primary purpose is to
determine which of the features of authentication, encryption, and
integrity checking will be enabled for a connection. In addition, since
HTCondor supports multiple technologies for authentication and
encryption, security negotiation also determines which technology is
chosen for the connection.

Security negotiation is a completely separate process from matchmaking,
and should not be confused with any specific function of the
*condor\_negotiator* daemon. Security negotiation occurs when one
HTCondor daemon or tool initiates communication with another HTCondor
daemon, to determine the security settings by which the communication
will be ruled. The *condor\_negotiator* daemon does negotiation, whereby
queued jobs and available machines within a pool go through the process
of matchmaking (deciding out which machines will run which jobs).

Configuration
~~~~~~~~~~~~~

The configuration macro names that determine what features will be used
during client-daemon communication follow the pattern:

::

        SEC_<context>_<feature>

The <feature> portion of the macro name determines which security
feature’s policy is being set. <feature> may be any one of

::

        AUTHENTICATION 
        ENCRYPTION 
        INTEGRITY 
        NEGOTIATION

The <context> component of the security policy macros can be used to
craft a fine-grained security policy based on the type of communication
taking place. <context> may be any one of

::

        CLIENT 
        READ 
        WRITE 
        ADMINISTRATOR 
        CONFIG 
        OWNER 
        DAEMON 
        NEGOTIATOR 
        ADVERTISE_MASTER 
        ADVERTISE_STARTD 
        ADVERTISE_SCHEDD 
        DEFAULT

Any of these constructed configuration macros may be set to any of the
following values:

::

        REQUIRED 
        PREFERRED 
        OPTIONAL 
        NEVER

Security negotiation resolves various client-daemon combinations of
desired security features in order to set a policy.

As an example, consider Frida the scientist. Frida wants to avoid
authentication when possible. She sets

::

        SEC_DEFAULT_AUTHENTICATION = OPTIONAL

The machine running the *condor\_schedd* to which Frida will remotely
submit jobs, however, is operated by a security-conscious system
administrator who dutifully sets:

::

        SEC_DEFAULT_AUTHENTICATION = REQUIRED

When Frida submits her jobs, HTCondor’s security negotiation determines
that authentication will be used, and allows the command to continue.
This example illustrates the point that the most restrictive security
policy sets the levels of security enforced. There is actually more to
the understanding of this scenario. Some HTCondor commands, such as the
use of *condor\_submit* to submit jobs always require authentication of
the submitter, no matter what the policy says. This is because the
identity of the submitter needs to be known in order to carry out the
operation. Others commands, such as *condor\_q*, do not always require
authentication, so in the above example, the server’s policy would force
Frida’s *condor\_q* queries to be authenticated, whereas a different
policy could allow *condor\_q* to happen without any authentication.

Whether or not security negotiation occurs depends on the setting at
both the client and daemon side of the configuration variable(s) defined
by ``SEC_*_NEGOTIATION``. ``SEC_DEFAULT_NEGOTIATION`` is a variable
representing the entire set of configuration variables for
``NEGOTIATION``. For the client side setting, the only definitions that
make sense are ``REQUIRED`` and ``NEVER``. For the daemon side setting,
the ``PREFERRED`` value makes no sense. Table \ `3.2 <#x36-2720012>`__
shows how security negotiation resolves various client-daemon
combinations of security negotiation policy settings. Within the table,
Yes means the security negotiation will take place. No means it will
not. Fail means that the policy settings are incompatible and the
communication cannot continue.

--------------

Daemon Setting

NEVER

OPTIONAL

REQUIRED

Client

NEVER

No

No

Fail

--------------

--------------

--------------

--------------

Setting

REQUIRED

Fail

Yes

Yes

| 

Table 3.2: Resolution of security negotiation.

--------------

Enabling authentication, encryption, and integrity checks is dependent
on security negotiation taking place. The enabled security negotiation
further sets the policy for these other features.
Table \ `3.3 <#x36-2720023>`__ shows how security features are resolved
for client-daemon combinations of security feature policy settings. Like
Table \ `3.2 <#x36-2720012>`__, Yes means the feature will be utilized.
No means it will not. Fail implies incompatibility and the feature
cannot be resolved.

--------------

Daemon Setting

NEVER

OPTIONAL

PREFERRED

REQUIRED

NEVER

No

No

No

Fail

Client

OPTIONAL

No

No

Yes

Yes

Setting

PREFERRED

No

Yes

Yes

Yes

REQUIRED

Fail

Yes

Yes

Yes

| 

Table 3.3: Resolution of security features.

--------------

The enabling of encryption and/or integrity checks is dependent on
authentication taking place. The authentication provides a key exchange.
The key is needed for both encryption and integrity checks.

Setting SEC\_CLIENT\_<feature> determines the policy for all outgoing
commands. The policy for incoming commands (the daemon side of the
communication) takes a more fine-grained approach that implements a set
of access levels for the received command. For example, it is desirable
to have all incoming administrative requests require authentication.
Inquiries on pool status may not be so restrictive. To implement this,
the administrator configures the policy:

::

    SEC_ADMINISTRATOR_AUTHENTICATION = REQUIRED 
    SEC_READ_AUTHENTICATION          = OPTIONAL

The DEFAULT value for <context> provides a way to set a policy for all
access levels (READ, WRITE, etc.) that do not have a specific
configuration variable defined. In addition, some access levels will
default to the settings specified for other access levels. For example,
``ADVERTISE_STARTD`` defaults to ``DAEMON``, and ``DAEMON`` defaults to
``WRITE``, which then defaults to the general DEFAULT setting.

Configuration for Security Methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Authentication and encryption can each be accomplished by a variety of
methods or technologies. Which method is utilized is determined during
security negotiation.

The configuration macros that determine the methods to use for
authentication and/or encryption are

::

    SEC_<context>_AUTHENTICATION_METHODS 
    SEC_<context>_CRYPTO_METHODS

These macros are defined by a comma or space delimited list of possible
methods to use. Section `3.8.3 <#x36-2740003.8.3>`__ lists all
implemented authentication methods. Section `3.8.5 <#x36-2860003.8.5>`__
lists all implemented encryption methods.

Authentication
--------------

The client side of any communication uses one of two macros to specify
whether authentication is to occur:

::

        SEC_DEFAULT_AUTHENTICATION 
        SEC_CLIENT_AUTHENTICATION

For the daemon side, there are a larger number of macros to specify
whether authentication is to take place, based upon the necessary access
level:

::

        SEC_DEFAULT_AUTHENTICATION 
        SEC_READ_AUTHENTICATION 
        SEC_WRITE_AUTHENTICATION 
        SEC_ADMINISTRATOR_AUTHENTICATION 
        SEC_CONFIG_AUTHENTICATION 
        SEC_OWNER_AUTHENTICATION 
        SEC_DAEMON_AUTHENTICATION 
        SEC_NEGOTIATOR_AUTHENTICATION 
        SEC_ADVERTISE_MASTER_AUTHENTICATION 
        SEC_ADVERTISE_STARTD_AUTHENTICATION 
        SEC_ADVERTISE_SCHEDD_AUTHENTICATION

As an example, the macro defined in the configuration file for a daemon
as

::

    SEC_WRITE_AUTHENTICATION = REQUIRED

signifies that the daemon must authenticate the client for any
communication that requires the ``WRITE`` access level. If the daemon’s
configuration contains

::

    SEC_DEFAULT_AUTHENTICATION = REQUIRED

and does not contain any other security configuration for
AUTHENTICATION, then this default defines the daemon’s needs for
authentication over all access levels. Where a specific macro is
defined, the more specific value takes precedence over the default
definition.

If authentication is to be done, then the communicating parties must
negotiate a mutually acceptable method of authentication to be used. A
list of acceptable methods may be provided by the client, using the
macros

::

        SEC_DEFAULT_AUTHENTICATION_METHODS 
        SEC_CLIENT_AUTHENTICATION_METHODS

A list of acceptable methods may be provided by the daemon, using the
macros

::

        SEC_DEFAULT_AUTHENTICATION_METHODS 
        SEC_READ_AUTHENTICATION_METHODS 
        SEC_WRITE_AUTHENTICATION_METHODS 
        SEC_ADMINISTRATOR_AUTHENTICATION_METHODS 
        SEC_CONFIG_AUTHENTICATION_METHODS 
        SEC_OWNER_AUTHENTICATION_METHODS 
        SEC_DAEMON_AUTHENTICATION_METHODS 
        SEC_NEGOTIATOR_AUTHENTICATION_METHODS 
        SEC_ADVERTISE_MASTER_AUTHENTICATION_METHODS 
        SEC_ADVERTISE_STARTD_AUTHENTICATION_METHODS 
        SEC_ADVERTISE_SCHEDD_AUTHENTICATION_METHODS

The methods are given as a comma-separated list of acceptable values.
These variables list the authentication methods that are available to be
used. The ordering of the list defines preference; the first item in the
list indicates the highest preference. As not all of the authentication
methods work on Windows platforms, which ones do not work on Windows are
indicated in the following list of defined values:

::

        GSI       (not available on Windows platforms) 
        SSL 
        KERBEROS 
        PASSWORD 
        FS        (not available on Windows platforms) 
        FS_REMOTE (not available on Windows platforms) 
        NTSSPI 
        MUNGE 
        CLAIMTOBE 
        ANONYMOUS

For example, a client may be configured with:

::

    SEC_CLIENT_AUTHENTICATION_METHODS = FS, GSI

and a daemon the client is trying to contact with:

::

    SEC_DEFAULT_AUTHENTICATION_METHODS = GSI

Security negotiation will determine that GSI authentication is the only
compatible choice. If there are multiple compatible authentication
methods, security negotiation will make a list of acceptable methods and
they will be tried in order until one succeeds.

As another example, the macro

::

    SEC_DEFAULT_AUTHENTICATION_METHODS = KERBEROS, NTSSPI

indicates that either Kerberos or Windows authentication may be used,
but Kerberos is preferred over Windows. Note that if the client and
daemon agree that multiple authentication methods may be used, then they
are tried in turn. For instance, if they both agree that Kerberos or
NTSSPI may be used, then Kerberos will be tried first, and if there is a
failure for any reason, then NTSSPI will be tried.

An additional specialized method of authentication exists for
communication between the *condor\_schedd* and *condor\_startd*. It is
especially useful when operating at large scale over high latency
networks or in situations where it is inconvenient to set up one of the
other methods of strong authentication between the submit and execute
daemons. See the description of
``SEC_ENABLE_MATCH_PASSWORD_AUTHENTICATION`` on
`794 <ConfigurationMacros.html#x33-2200003.5.24>`__ for details.

If the configuration for a machine does not define any variable for
``SEC_<access-level>_AUTHENTICATION``, then HTCondor uses a default
value of OPTIONAL. Authentication will be required for any operation
which modifies the job queue, such as *condor\_qedit* and *condor\_rm*.
If the configuration for a machine does not define any variable for
``SEC_<access-level>_AUTHENTICATION_METHODS``, the default value for a
Unix machine is FS, KERBEROS, GSI. This default value for a Windows
machine is NTSSPI, KERBEROS, GSI.

GSI Authentication
~~~~~~~~~~~~~~~~~~

The GSI (Grid Security Infrastructure) protocol provides an avenue for
HTCondor to do PKI-based (Public Key Infrastructure) authentication
using X.509 certificates. The basics of GSI are well-documented
elsewhere, such as `http://www.globus.org/ <http://www.globus.org/>`__.

A simple introduction to this type of authentication defines HTCondor’s
use of terminology, and it illuminates the needed items that HTCondor
must access to do this authentication. Assume that A authenticates to B.
In this example, A is the client, and B is the daemon within their
communication. This example’s one-way authentication implies that B is
verifying the identity of A, using the certificate A provides, and
utilizing B’s own set of trusted CAs (Certification Authorities). Client
A provides its certificate (or proxy) to daemon B. B does two things: B
checks that the certificate is valid, and B checks to see that the CA
that signed A’s certificate is one that B trusts.

For the GSI authentication protocol, an X.509 certificate is required.
Files with predetermined names hold a certificate, a key, and
optionally, a proxy. A separate directory has one or more files that
become the list of trusted CAs.

Allowing HTCondor to do this GSI authentication requires knowledge of
the locations of the client A’s certificate and the daemon B’s list of
trusted CAs. When one side of the communication (as either client A or
daemon B) is an HTCondor daemon, these locations are determined by
configuration or by default locations. When one side of the
communication (as a client A) is a user of HTCondor (the process owner
of an HTCondor tool, for example *condor\_submit*), these locations are
determined by the pre-set values of environment variables or by default
locations.

 GSI certificate locations for HTCondor daemons
    For an HTCondor daemon, the certificate may be a single host
    certificate, and all HTCondor daemons on the same machine may share
    the same certificate. In some cases, the certificate can also be
    copied to other machines, where local copies are necessary. This may
    occur only in cases where a single host certificate can match
    multiple host names, something that is beyond the scope of this
    manual. The certificates must be protected by access rights to
    files, since the password file is not encrypted.

    The specification of the location of the necessary files through
    configuration uses the following precedence.

    #. Configuration variable ``GSI_DAEMON_DIRECTORY`` gives the
       complete path name to the directory that contains the
       certificate, key, and directory with trusted CAs. HTCondor uses
       this directory as follows in its construction of the following
       configuration variables:

       ::

           GSI_DAEMON_CERT           = $(GSI_DAEMON_DIRECTORY)/hostcert.pem 
           GSI_DAEMON_KEY            = $(GSI_DAEMON_DIRECTORY)/hostkey.pem 
           GSI_DAEMON_TRUSTED_CA_DIR = $(GSI_DAEMON_DIRECTORY)/certificates

       Note that no proxy is assumed in this case.

    #. If the ``GSI_DAEMON_DIRECTORY`` is not defined, or when defined,
       the location may be overridden with specific configuration
       variables that specify the complete path and file name of the
       certificate with

           ``GSI_DAEMON_CERT``

       the key with

           ``GSI_DAEMON_KEY``

       a proxy with

           ``GSI_DAEMON_PROXY``

       the complete path to the directory containing the list of trusted
       CAs with

           ``GSI_DAEMON_TRUSTED_CA_DIR``

    #. The default location assumed is ``/etc/grid-security``. Note that
       this implemented by setting the value of
       ``GSI_DAEMON_DIRECTORY``.

    When a daemon acts as the client within authentication, the daemon
    needs a listing of those from which it will accept certificates.
    This is done with ``GSI_DAEMON_NAME``. This name is specified with
    the following format

    ::

        GSI_DAEMON_NAME = /X.509/name/of/server/1,/X.509/name/of/server/2,...

    HTCondor will also need a way to map an X.509 distinguished name to
    an HTCondor user id. There are two ways to accomplish this mapping.
    For a first way to specify the mapping, see
    section \ `3.8.4 <#x36-2850003.8.4>`__ to use HTCondor’s unified map
    file. The second way to do the mapping is within an
    administrator-maintained GSI-specific file called an X.509 map file,
    mapping from X.509 Distinguished Name (DN) to HTCondor user id. It
    is similar to a Globus grid map file, except that it is only used
    for mapping to a user id, not for authorization. If the user names
    in the map file do not specify a domain for the user (specification
    would appear as user@domain), then the value of ``UID_DOMAIN`` is
    used. Entries (lines) in the file each contain two items. The first
    item in an entry is the X.509 certificate subject name, and it is
    enclosed in double quote marks (using the character "). The second
    item is the HTCondor user id. The two items in an entry are
    separated by tab or space character(s). Here is an example of an
    entry in an X.509 map file. Entries must be on a single line; this
    example is broken onto two lines for formatting reasons.

    ::

        "/C=US/O=Globus/O=University of Wisconsin/ 
        OU=Computer Sciences Department/CN=Alice Smith" asmith

    HTCondor finds the map file in one of three ways. If the
    configuration variable ``GRIDMAP`` is defined, it gives the full
    path name to the map file. When not defined, HTCondor looks for the
    map file in

    ::

        $(GSI_DAEMON_DIRECTORY)/grid-mapfile

    If ``GSI_DAEMON_DIRECTORY`` is not defined, then the third place
    HTCondor looks for the map file is given by

    ::

        /etc/grid-security/grid-mapfile

 GSI certificate locations for Users
    The user specifies the location of a certificate, proxy, etc. in one
    of two ways:

    #. Environment variables give the location of necessary items.

       ``X509_USER_PROXY`` gives the path and file name of the proxy.
       This proxy will have been created using the *grid-proxy-init*
       program, which will place the proxy in the ``/tmp`` directory
       with the file name being determined by the format:

       ::

             /tmp/x509up_uXXXX 
             

       The specific file name is given by substituting the XXXX
       characters with the UID of the user. Note that when a valid proxy
       is used, the certificate and key locations are not needed.

       ``X509_USER_CERT`` gives the path and file name of the
       certificate. It is also used if a proxy location has been
       checked, but the proxy is no longer valid.

       ``X509_USER_KEY`` gives the path and file name of the key. Note
       that most keys are password encrypted, such that knowing the
       location could not lead to using the key.

       ``X509_CERT_DIR`` gives the path to the directory containing the
       list of trusted CAs.

    #. Without environment variables to give locations of necessary
       certificate information, HTCondor uses a default directory for
       the user. This directory is given by

       ::

           $(HOME)/.globus

 Example GSI Security Configuration
    Here is an example portion of the configuration file that would
    enable and require GSI authentication, along with a minimal set of
    other variables to make it work.

    ::

        SEC_DEFAULT_AUTHENTICATION = REQUIRED 
        SEC_DEFAULT_AUTHENTICATION_METHODS = GSI 
        SEC_DEFAULT_INTEGRITY = REQUIRED 
        GSI_DAEMON_DIRECTORY = /etc/grid-security 
        GRIDMAP = /etc/grid-security/grid-mapfile 
         
        # authorize based on user names produced by the map file 
        ALLOW_READ = *@cs.wisc.edu/*.cs.wisc.edu 
        ALLOW_DAEMON = condor@cs.wisc.edu/*.cs.wisc.edu 
        ALLOW_NEGOTIATOR = condor@cs.wisc.edu/condor.cs.wisc.edu, \ 
                           condor@cs.wisc.edu/condor2.cs.wisc.edu 
        ALLOW_ADMINISTRATOR = condor-admin@cs.wisc.edu/*.cs.wisc.edu 
         
        # condor daemon certificate(s) trusted by condor tools and daemons 
        # when connecting to other condor daemons 
        GSI_DAEMON_NAME = /C=US/O=Condor/O=UW/OU=CS/CN=condor@cs.wisc.edu 
         
        # clear out any host-based authorizations 
        # (unnecessary if you leave authentication REQUIRED, 
        #  but useful if you make it optional and want to 
        #  allow some unauthenticated operations, such as 
        #  ALLOW_READ = */*.cs.wisc.edu) 
        HOSTALLOW_READ = 
        HOSTALLOW_WRITE = 
        HOSTALLOW_NEGOTIATOR = 
        HOSTALLOW_ADMINISTRATOR =

    The ``SEC_DEFAULT_AUTHENTICATION`` macro specifies that
    authentication is required for all communications. This single macro
    covers all communications, but could be replaced with a set of
    macros that require authentication for only specific communications.

    The macro ``GSI_DAEMON_DIRECTORY`` is specified to give HTCondor a
    single place to find the daemon’s certificate. This path may be a
    directory on a shared file system such as AFS. Alternatively, this
    path name can point to local copies of the certificate stored in a
    local file system.

    The macro ``GRIDMAP`` specifies the file to use for mapping GSI
    names to user names within HTCondor. For example, it might look like
    this:

    ::

        "/C=US/O=Condor/O=UW/OU=CS/CN=condor@cs.wisc.edu" condor@cs.wisc.edu

    Additional mappings would be needed for the users who submit jobs to
    the pool or who issue administrative commands.

SSL Authentication
~~~~~~~~~~~~~~~~~~

SSL authentication is similar to GSI authentication, but without GSI’s
delegation (proxy) capabilities. SSL utilizes X.509 certificates.

All SSL authentication is mutual authentication in HTCondor. This means
that when SSL authentication is used and when one process communicates
with another, each process must be able to verify the signature on the
certificate presented by the other process. The process that initiates
the connection is the client, and the process that receives the
connection is the server. For example, when a *condor\_startd* daemon
authenticates with a *condor\_collector* daemon to provide a machine
ClassAd, the *condor\_startd* daemon initiates the connection and acts
as the client, and the *condor\_collector* daemon acts as the server.

The names and locations of keys and certificates for clients, servers,
and the files used to specify trusted certificate authorities (CAs) are
defined by settings in the configuration files. The contents of the
files are identical in format and interpretation to those used by other
systems which use SSL, such as Apache httpd.

The configuration variables ``AUTH_SSL_CLIENT_CERTFILE`` and
``AUTH_SSL_SERVER_CERTFILE`` specify the file location for the
certificate file for the initiator and recipient of connections,
respectively. Similarly, the configuration variables
``AUTH_SSL_CLIENT_KEYFILE`` and ``AUTH_SSL_SERVER_KEYFILE`` specify the
locations for keys.

The configuration variables ``AUTH_SSL_SERVER_CAFILE`` and
``AUTH_SSL_CLIENT_CAFILE`` each specify a path and file name, providing
the location of a file containing one or more certificates issued by
trusted certificate authorities. Similarly, ``AUTH_SSL_SERVER_CADIR``
and ``AUTH_SSL_CLIENT_CADIR`` each specify a directory with one or more
files, each which may contain a single CA certificate. The directories
must be prepared using the OpenSSL ``c_rehash`` utility.

Kerberos Authentication
~~~~~~~~~~~~~~~~~~~~~~~

If Kerberos is used for authentication, then a mapping from a Kerberos
domain (called a realm) to an HTCondor UID domain is necessary. There
are two ways to accomplish this mapping. For a first way to specify the
mapping, see section \ `3.8.4 <#x36-2850003.8.4>`__ to use HTCondor’s
unified map file. A second way to specify the mapping defines the
configuration variable ``KERBEROS_MAP_FILE`` to define a path to an
administrator-maintained Kerberos-specific map file. The configuration
syntax is

::

    KERBEROS_MAP_FILE = /path/to/etc/condor.kmap

Lines within this map file have the syntax

::

       KERB.REALM = UID.domain.name

Here are two lines from a map file to use as an example:

::

       CS.WISC.EDU   = cs.wisc.edu 
       ENGR.WISC.EDU = ee.wisc.edu

If a ``KERBEROS_MAP_FILE`` configuration variable is defined and set,
then all permitted realms must be explicitly mapped. If no map file is
specified, then HTCondor assumes that the Kerberos realm is the same as
the HTCondor UID domain.

The configuration variable ``KERBEROS_SERVER_PRINCIPAL`` defines the
name of a Kerberos principal. If ``KERBEROS_SERVER_PRINCIPAL`` is not
defined, then the default value used is host. A principal specifies a
unique name to which a set of credentials may be assigned.

HTCondor takes the specified (or default) principal and appends a slash
character, the host name, an ’@’ (at sign character), and the Kerberos
realm. As an example, the configuration

::

    KERBEROS_SERVER_PRINCIPAL = condor-daemon

results in HTCondor’s use of

::

    condor-daemon/the.host.name@YOUR.KERB.REALM

as the server principal.

Here is an example of configuration settings that use Kerberos for
authentication and require authentication of all communications of the
write or administrator access level.

::

    SEC_WRITE_AUTHENTICATION                 = REQUIRED 
    SEC_WRITE_AUTHENTICATION_METHODS         = KERBEROS 
    SEC_ADMINISTRATOR_AUTHENTICATION         = REQUIRED 
    SEC_ADMINISTRATOR_AUTHENTICATION_METHODS = KERBEROS

Kerberos authentication on Unix platforms requires access to various
files that usually are only accessible by the root user. At this time,
the only supported way to use KERBEROS authentication on Unix platforms
is to start daemons HTCondor as user root.

Password Authentication
~~~~~~~~~~~~~~~~~~~~~~~

The password method provides mutual authentication through the use of a
shared secret. This is often a good choice when strong security is
desired, but an existing Kerberos or X.509 infrastructure is not in
place. Password authentication is available on both Unix and Windows. It
currently can only be used for daemon-to-daemon authentication. The
shared secret in this context is referred to as the pool password.

Before a daemon can use password authentication, the pool password must
be stored on the daemon’s local machine. On Unix, the password will be
placed in a file defined by the configuration variable
``SEC_PASSWORD_FILE`` . This file will be accessible only by the UID
that HTCondor is started as. On Windows, the same secure password store
that is used for user passwords will be used for the pool password (see
section `8.2.3 <MicrosoftWindows.html#x76-5760008.2.3>`__).

Under Unix, the password file can be generated by using the following
command to write directly to the password file:

::

    condor_store_cred -f /path/to/password/file

Under Windows (or under Unix), storing the pool password is done with
the **-c** option when using to *condor\_store\_cred* **add**. Running

::

    condor_store_cred -c add

prompts for the pool password and store it on the local machine, making
it available for daemons to use in authentication. The *condor\_master*
must be running for this command to work.

In addition, storing the pool password to a given machine requires
CONFIG-level access. For example, if the pool password should only be
set locally, and only by root, the following would be placed in the
global configuration file.

::

    ALLOW_CONFIG = root@mydomain/$(IP_ADDRESS)

It is also possible to set the pool password remotely, but this is
recommended only if it can be done over an encrypted channel. This is
possible on Windows, for example, in an environment where common
accounts exist across all the machines in the pool. In this case,
ALLOW\_CONFIG can be set to allow the HTCondor administrator (who in
this example has an account condor common to all machines in the pool)
to set the password from the central manager as follows.

::

    ALLOW_CONFIG = condor@mydomain/$(CONDOR_HOST)

The HTCondor administrator then executes

::

    condor_store_cred -c -n host.mydomain add

from the central manager to store the password to a given machine. Since
the condor account exists on both the central manager and host.mydomain,
the NTSSPI authentication method can be used to authenticate and encrypt
the connection. *condor\_store\_cred* will warn and prompt for
cancellation, if the channel is not encrypted for whatever reason
(typically because common accounts do not exist or HTCondor’s security
is misconfigured).

When a daemon is authenticated using a pool password, its security
principle is condor\_pool@$(UID\_DOMAIN), where $(UID\_DOMAIN) is taken
from the daemon’s configuration. The ALLOW\_DAEMON and ALLOW\_NEGOTIATOR
configuration variables for authorization should restrict access using
this name. For example,

::

    ALLOW_DAEMON = condor_pool@mydomain/*, condor@mydomain/$(IP_ADDRESS) 
    ALLOW_NEGOTIATOR = condor_pool@mydomain/$(CONDOR_HOST)

This configuration allows remote DAEMON-level and NEGOTIATOR-level
access, if the pool password is known. Local daemons authenticated as
condor@mydomain are also allowed access. This is done so local
authentication can be done using another method such as FS.

 Example Security Configuration Using Pool Password
    The following example configuration uses pool password
    authentication and network message integrity checking for all
    communication between HTCondor daemons.

    ::

        SEC_PASSWORD_FILE = $(LOCK)/pool_password 
        SEC_DAEMON_AUTHENTICATION = REQUIRED 
        SEC_DAEMON_INTEGRITY = REQUIRED 
        SEC_DAEMON_AUTHENTICATION_METHODS = PASSWORD 
        SEC_NEGOTIATOR_AUTHENTICATION = REQUIRED 
        SEC_NEGOTIATOR_INTEGRITY = REQUIRED 
        SEC_NEGOTIATOR_AUTHENTICATION_METHODS = PASSWORD 
        SEC_CLIENT_AUTHENTICATION_METHODS = FS, PASSWORD, KERBEROS, GSI 
        ALLOW_DAEMON = condor_pool@$(UID_DOMAIN)/*.cs.wisc.edu, \ 
                       condor@$(UID_DOMAIN)/$(IP_ADDRESS) 
        ALLOW_NEGOTIATOR = condor_pool@$(UID_DOMAIN)/negotiator.machine.name

 Example Using Pool Password for *condor\_startd* Advertisement
    One problem with the pool password method of authentication is that
    it involves a single, shared secret. This does not scale well with
    the addition of remote users who flock to the local pool. However,
    the pool password may still be used for authenticating portions of
    the local pool, while others (such as the remote *condor\_schedd*
    daemons involved in flocking) are authenticated by other means.

    In this example, only the *condor\_startd* daemons in the local pool
    are required to have the pool password when they advertise
    themselves to the *condor\_collector* daemon.

    ::

        SEC_PASSWORD_FILE = $(LOCK)/pool_password 
        SEC_ADVERTISE_STARTD_AUTHENTICATION = REQUIRED 
        SEC_ADVERTISE_STARTD_INTEGRITY = REQUIRED 
        SEC_ADVERTISE_STARTD_AUTHENTICATION_METHODS = PASSWORD 
        SEC_CLIENT_AUTHENTICATION_METHODS = FS, PASSWORD, KERBEROS, GSI 
        ALLOW_ADVERTISE_STARTD = condor_pool@$(UID_DOMAIN)/*.cs.wisc.edu

File System Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~

This form of authentication utilizes the ownership of a file in the
identity verification of a client. A daemon authenticating a client
requires the client to write a file in a specific location (``/tmp``).
The daemon then checks the ownership of the file. The file’s ownership
verifies the identity of the client. In this way, the file system
becomes the trusted authority. This authentication method is only
appropriate for clients and daemons that are on the same computer.

File System Remote Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Like file system authentication, this form of authentication utilizes
the ownership of a file in the identity verification of a client. In
this case, a daemon authenticating a client requires the client to write
a file in a specific location, but the location is not restricted to
``/tmp``. The location of the file is specified by the configuration
variable ``FS_REMOTE_DIR`` .

Windows Authentication
~~~~~~~~~~~~~~~~~~~~~~

This authentication is done only among Windows machines using a
proprietary method. The Windows security interface SSPI is used to
enforce NTLM (NT LAN Manager). The authentication is based on challenge
and response, using the user’s password as a key. This is similar to
Kerberos. The main difference is that Kerberos provides an access token
that typically grants access to an entire network, whereas NTLM
authentication only verifies an identity to one machine at a time.
NTSSPI is best-used in a way similar to file system authentication in
Unix, and probably should not be used for authentication between two
computers.

Ask MUNGE for Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ask the MUNGE service to validate both sides of the authentication. See:
https://dun.github.io/munge/ for instructions on installing.

Claim To Be Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~

Claim To Be authentication accepts any identity claimed by the client.
As such, it does not authenticate. It is included in HTCondor and in the
list of authentication methods for testing purposes only.

Anonymous Authentication
~~~~~~~~~~~~~~~~~~~~~~~~

Anonymous authentication causes authentication to be skipped entirely.
As such, it does not authenticate. It is included in HTCondor and in the
list of authentication methods for testing purposes only.

The Unified Map File for Authentication
---------------------------------------

HTCondor’s unified map file allows the mappings from authenticated names
to an HTCondor canonical user name to be specified as a single list
within a single file. The location of the unified map file is defined by
the configuration variable ``CERTIFICATE_MAPFILE`` ; it specifies the
path and file name of the unified map file. Each mapping is on its own
line of the unified map file. Each line contains 3 fields, separated by
white space (space or tab characters):

#. The name of the authentication method to which the mapping applies.
#. A name or a regular expression representing the authenticated name to
   be mapped.
#. The canonical HTCondor user name.

Allowable authentication method names are the same as used to define any
of the configuration variables ``SEC_*_AUTHENTICATION_METHODS``, as
repeated here:

::

        GSI 
        SSL 
        KERBEROS 
        PASSWORD 
        FS 
        FS_REMOTE 
        NTSSPI 
        MUNGE 
        CLAIMTOBE 
        ANONYMOUS

The fields that represent an authenticated name and the canonical
HTCondor user name may utilize regular expressions as defined by PCRE
(Perl-Compatible Regular Expressions). Due to this, more than one line
(mapping) within the unified map file may match. Look ups are therefore
defined to use the first mapping that matches.

For HTCondor version 8.5.8 and later, the authenticated name field will
be interpreted as a regular expression or as a simple string based on
the value of the ``CERTIFICATE_MAPFILE_ASSUME_HASH_KEYS`` configuration
variable. If this configuration varible is true, then the authenticated
name field is a regular expression only when it begins and ends with the
/ character. If this configuration variable is false, or on HTCondor
versions older than 8.5.8, the authenticated name field is always a
regular expression.

A regular expression may need to contain spaces, and in this case the
entire expression can be surrounded by double quote marks. If a double
quote character also needs to appear in such an expression, it is
preceded by a backslash.

The default behavior of HTCondor when no map file is specified is to do
the following mappings, with some additional logic noted below:

::

    FS (.*) \1 
    FS_REMOTE (.*) \1 
    GSI (.*) GSS_ASSIST_GRIDMAP 
    SSL (.*) ssl@unmapped 
    KERBEROS ([^/]*)/?[^@]*@(.*) \1@\2 
    NTSSPI (.*) \1 
    MUNGE (.*) \1 
    CLAIMTOBE (.*) \1 
    PASSWORD (.*) \1

For GSI (or SSL), the special name ``GSS_ASSIST_GRIDMAP`` instructs
HTCondor to use the GSI grid map file (configured with ``GRIDMAP`` as
shown in section \ `3.8.3 <#x36-2750003.8.3>`__) to do the mapping. If
no mapping can be found for GSI (with or without the use of
``GSS_ASSIST_GRIDMAP``), the user is mapped to gsi@unmapped.

For Kerberos, if ``KERBEROS_MAP_FILE`` is specified, the domain portion
of the name is obtained by mapping the Kerberos realm to the value
specified in the map file, rather than just using the realm verbatim as
the domain portion of the condor user name. See
section \ `3.8.3 <#x36-2770003.8.3>`__ for details.

If authentication did not happen or failed and was not required, then
the user is given the name unauthenticated@unmapped.

With the integration of VOMS for GSI authentication, the interpretation
of the regular expression representing the authenticated name may
change. First, the full serialized DN and FQAN are used in attempting a
match. If no match is found using the full DN and FQAN, then the DN is
then used on its own without the FQAN. Using this, roles or user names
from the VOMS attributes may be extracted to be used as the target for
mapping. And, in this case the FQAN are verified, permitting reliance on
their authenticity.

Encryption
----------

Encryption provides privacy support between two communicating parties.
Through configuration macros, both the client and the daemon can specify
whether encryption is required for further communication.

The client uses one of two macros to enable or disable encryption:

::

        SEC_DEFAULT_ENCRYPTION 
        SEC_CLIENT_ENCRYPTION

For the daemon, there are seven macros to enable or disable encryption:

::

        SEC_DEFAULT_ENCRYPTION 
        SEC_READ_ENCRYPTION 
        SEC_WRITE_ENCRYPTION 
        SEC_ADMINISTRATOR_ENCRYPTION 
        SEC_CONFIG_ENCRYPTION 
        SEC_OWNER_ENCRYPTION 
        SEC_DAEMON_ENCRYPTION 
        SEC_NEGOTIATOR_ENCRYPTION 
        SEC_ADVERTISE_MASTER_ENCRYPTION 
        SEC_ADVERTISE_STARTD_ENCRYPTION 
        SEC_ADVERTISE_SCHEDD_ENCRYPTION

As an example, the macro defined in the configuration file for a daemon
as

::

    SEC_CONFIG_ENCRYPTION = REQUIRED

signifies that any communication that changes a daemon’s configuration
must be encrypted. If a daemon’s configuration contains

::

    SEC_DEFAULT_ENCRYPTION = REQUIRED

and does not contain any other security configuration for ENCRYPTION,
then this default defines the daemon’s needs for encryption over all
access levels. Where a specific macro is present, its value takes
precedence over any default given.

If encryption is to be done, then the communicating parties must find
(negotiate) a mutually acceptable method of encryption to be used. A
list of acceptable methods may be provided by the client, using the
macros

::

        SEC_DEFAULT_CRYPTO_METHODS 
        SEC_CLIENT_CRYPTO_METHODS

A list of acceptable methods may be provided by the daemon, using the
macros

::

        SEC_DEFAULT_CRYPTO_METHODS 
        SEC_READ_CRYPTO_METHODS 
        SEC_WRITE_CRYPTO_METHODS 
        SEC_ADMINISTRATOR_CRYPTO_METHODS 
        SEC_CONFIG_CRYPTO_METHODS 
        SEC_OWNER_CRYPTO_METHODS 
        SEC_DAEMON_CRYPTO_METHODS 
        SEC_NEGOTIATOR_CRYPTO_METHODS 
        SEC_ADVERTISE_MASTER_CRYPTO_METHODS 
        SEC_ADVERTISE_STARTD_CRYPTO_METHODS 
        SEC_ADVERTISE_SCHEDD_CRYPTO_METHODS

The methods are given as a comma-separated list of acceptable values.
These variables list the encryption methods that are available to be
used. The ordering of the list gives preference; the first item in the
list indicates the highest preference. Possible values are

::

        3DES 
        BLOWFISH

Integrity
---------

An integrity check assures that the messages between communicating
parties have not been tampered with. Any change, such as addition,
modification, or deletion can be detected. Through configuration macros,
both the client and the daemon can specify whether an integrity check is
required of further communication.

Note at this time, integrity checks are not performed upon job data
files that are transferred by HTCondor via the File Transfer Mechanism
described in section \ `2.5.9 <SubmittingaJob.html#x17-380002.5.9>`__.

The client uses one of two macros to enable or disable an integrity
check:

::

        SEC_DEFAULT_INTEGRITY 
        SEC_CLIENT_INTEGRITY

For the daemon, there are seven macros to enable or disable an integrity
check:

::

        SEC_DEFAULT_INTEGRITY 
        SEC_READ_INTEGRITY 
        SEC_WRITE_INTEGRITY 
        SEC_ADMINISTRATOR_INTEGRITY 
        SEC_CONFIG_INTEGRITY 
        SEC_OWNER_INTEGRITY 
        SEC_DAEMON_INTEGRITY 
        SEC_NEGOTIATOR_INTEGRITY 
        SEC_ADVERTISE_MASTER_INTEGRITY 
        SEC_ADVERTISE_STARTD_INTEGRITY 
        SEC_ADVERTISE_SCHEDD_INTEGRITY

As an example, the macro defined in the configuration file for a daemon
as

::

    SEC_CONFIG_INTEGRITY = REQUIRED

signifies that any communication that changes a daemon’s configuration
must have its integrity assured. If a daemon’s configuration contains

::

    SEC_DEFAULT_INTEGRITY = REQUIRED

and does not contain any other security configuration for INTEGRITY,
then this default defines the daemon’s needs for integrity checks over
all access levels. Where a specific macro is present, its value takes
precedence over any default given.

A signed MD5 check sum is currently the only available method for
integrity checking. Its use is implied whenever integrity checks occur.
If more methods are implemented, then there will be further macros to
allow both the client and the daemon to specify which methods are
acceptable.

Authorization
-------------

Authorization protects resource usage by granting or denying access
requests made to the resources. It defines who is allowed to do what.

Authorization is defined in terms of users. An initial implementation
provided authorization based on hosts (machines), while the current
implementation relies on user-based authorization.
Section \ `3.8.9 <#x36-2920003.8.9>`__ on Setting Up IP/Host-Based
Security in HTCondor describes the previous implementation. This
IP/Host-Based security still exists, and it can be used, but
significantly stronger and more flexible security can be achieved with
the newer authorization based on fully qualified user names. This
section discusses user-based authorization.

The authorization portion of the security of an HTCondor pool is based
on a set of configuration macros. The macros list which user will be
authorized to issue what request given a specific access level. When a
daemon is to be authorized, its user name is the login under which the
daemon is executed.

These configuration macros define a set of users that will be allowed to
(or denied from) carrying out various HTCondor commands. Each access
level may have its own list of authorized users. A complete list of the
authorization macros:

::

        ALLOW_READ 
        ALLOW_WRITE 
        ALLOW_ADMINISTRATOR 
        ALLOW_CONFIG 
        ALLOW_OWNER 
        ALLOW_NEGOTIATOR 
        ALLOW_DAEMON 
        DENY_READ 
        DENY_WRITE 
        DENY_ADMINISTRATOR 
        DENY_CONFIG 
        DENY_OWNER 
        DENY_NEGOTIATOR 
        DENY_DAEMON

In addition, the following are used to control authorization of specific
types of HTCondor daemons when advertising themselves to the pool. If
unspecified, these default to the broader ``ALLOW_DAEMON`` and
``DENY_DAEMON`` settings.

::

        ALLOW_ADVERTISE_MASTER 
        ALLOW_ADVERTISE_STARTD 
        ALLOW_ADVERTISE_SCHEDD 
        DENY_ADVERTISE_MASTER 
        DENY_ADVERTISE_STARTD 
        DENY_ADVERTISE_SCHEDD

Each client side of a connection may also specify its own list of
trusted servers. This is done using the following settings. Note that
the FS and CLAIMTOBE authentication methods are not symmetric. The
client is authenticated by the server, but the server is not
authenticated by the client. When the server is not authenticated to the
client, only the network address of the host may be authorized and not
the specific identity of the server.

::

      ALLOW_CLIENT 
      DENY_CLIENT

The names ``ALLOW_CLIENT`` and ``DENY_CLIENT`` should be thought of as
“when I am acting as a client, these are the servers I allow or deny.”
It should not be confused with the incorrect thought “when I am the
server, these are the clients I allow or deny.”

All authorization settings are defined by a comma-separated list of
fully qualified users. Each fully qualified user is described using the
following format:

::

        username@domain/hostname

The information to the left of the slash character describes a user
within a domain. The information to the right of the slash character
describes one or more machines from which the user would be issuing a
command. This host name may take the form of either a fully qualified
host name of the form

::

    bird.cs.wisc.edu

or an IP address of the form

::

    128.105.128.0

An example is

::

    zmiller@cs.wisc.edu/bird.cs.wisc.edu

Within the format, wild card characters (the asterisk, \*) are allowed.
The use of wild cards is limited to one wild card on either side of the
slash character. A wild card character used in the host name is further
limited to come at the beginning of a fully qualified host name or at
the end of an IP address. For example,

::

    *@cs.wisc.edu/bird.cs.wisc.edu

refers to any user that comes from cs.wisc.edu, where the command is
originating from the machine bird.cs.wisc.edu. Another valid example,

::

    zmiller@cs.wisc.edu/*.cs.wisc.edu

refers to commands coming from any machine within the cs.wisc.edu
domain, and issued by zmiller. A third valid example,

::

    *@cs.wisc.edu/*

refers to commands coming from any user within the cs.wisc.edu domain
where the command is issued from any machine. A fourth valid example,

::

    *@cs.wisc.edu/128.105.*

refers to commands coming from any user within the cs.wisc.edu domain
where the command is issued from machines within the network that match
the first two octets of the IP address.

If the set of machines is specified by an IP address, then further
specification using a net mask identifies a physical set (subnet) of
machines. This physical set of machines is specified using the form

::

    network/netmask

The network is an IP address. The net mask takes one of two forms. It
may be a decimal number which refers to the number of leading bits of
the IP address that are used in describing a subnet. Or, the net mask
may take the form of

::

    a.b.c.d

where a, b, c, and d are decimal numbers that each specify an 8-bit
mask. An example net mask is

::

    255.255.192.0

which specifies the bit mask

::

    11111111.11111111.11000000.00000000

A single complete example of a configuration variable that uses a net
mask is

::

    ALLOW_WRITE = joesmith@cs.wisc.edu/128.105.128.0/17

User joesmith within the cs.wisc.edu domain is given write authorization
when originating from machines that match their leftmost 17 bits of the
IP address.

For Unix platforms where netgroups are implemented, a netgroup may
specify a set of fully qualified users by using an extension to the
syntax for all configuration variables of the form ``ALLOW_*`` and
``DENY_*``. The syntax is the plus sign character (``+``) followed by
the netgroup name. Permissions are applied to all members of the
netgroup.

This flexible set of configuration macros could be used to define
conflicting authorization. Therefore, the following protocol defines the
precedence of the configuration macros.

    1. ``DENY_*`` macros take precedence over ``ALLOW_* macros`` where
    there is a conflict. This implies that if a specific user is both
    denied and granted authorization, the conflict is resolved by
    denying access.
    2. If macros are omitted, the default behavior is to grant
    authorization for every user.

In addition, there are some hard-coded authorization rules that cannot
be modified by configuration.

#. Connections with a name matching \*@unmapped are not allowed to do
   any job management commands (e.g. submitting, removing, or modifying
   jobs). This prevents these operations from being done by
   unauthenticated users and users who are authenticated but lacking a
   name in the map file.
#. To simplify flocking, the *condor\_schedd* automatically grants the
   *condor\_startd* ``READ`` access for the duration of a claim so that
   claim-related communications are possible. The *condor\_shadow*
   grants the *condor\_starter* ``DAEMON`` access so that file transfers
   can be done. The identity that is granted access in both these cases
   is the authenticated name (if available) and IP address of the
   *condor\_startd* when the *condor\_schedd* initially connects to it
   to request the claim. It is important that only trusted
   *condor\_startd*\ s are allowed to publish themselves to the
   collector or that the *condor\_schedd*\ ’s ``ALLOW_CLIENT`` setting
   prevent it from allowing connections to *condor\_startd*\ s that it
   does not trust to run jobs.
#. When ``SEC_ENABLE_MATCH_PASSWORD_AUTHENTICATION`` is true,
   execute-side@matchsession is automatically granted ``READ`` access to
   the *condor\_schedd* and ``DAEMON`` access to the *condor\_shadow*.

Example of Authorization Security Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An example of the configuration variables for the user-side
authorization is derived from the necessary access levels as described
in Section \ `3.8.1 <#x36-2700003.8.1>`__.

::

    ALLOW_READ            = *@cs.wisc.edu/* 
    ALLOW_WRITE           = *@cs.wisc.edu/*.cs.wisc.edu 
    ALLOW_ADMINISTRATOR   = condor-admin@cs.wisc.edu/*.cs.wisc.edu 
    ALLOW_CONFIG          = condor-admin@cs.wisc.edu/*.cs.wisc.edu 
    ALLOW_NEGOTIATOR      = condor@cs.wisc.edu/condor.cs.wisc.edu, \ 
                            condor@cs.wisc.edu/condor2.cs.wisc.edu 
    ALLOW_DAEMON          = condor@cs.wisc.edu/*.cs.wisc.edu 
     
    # Clear out any old-style HOSTALLOW settings: 
    HOSTALLOW_READ = 
    HOSTALLOW_WRITE = 
    HOSTALLOW_DAEMON = 
    HOSTALLOW_NEGOTIATOR = 
    HOSTALLOW_ADMINISTRATOR = 
    HOSTALLOW_OWNER =

This example configuration authorizes any authenticated user in the
cs.wisc.edu domain to carry out a request that requires the ``READ``
access level from any machine. Any user in the cs.wisc.edu domain may
carry out a request that requires the ``WRITE`` access level from any
machine in the cs.wisc.edu domain. Only the user called condor-admin may
carry out a request that requires the ``ADMINISTRATOR`` access level
from any machine in the cs.wisc.edu domain. The administrator, logged
into any machine within the cs.wisc.edu domain is authorized at the
``CONFIG`` access level. Only the negotiator daemon, running as condor
on the two central managers are authorized with the ``NEGOTIATOR``
access level. And, the last line of the example presumes that there is a
user called condor, and that the daemons have all been started up as
this user. It authorizes only programs (which will be the daemons)
running as condor to carry out requests that require the ``DAEMON``
access level, where the commands originate from any machine in the
cs.wisc.edu domain.

In the local configuration file for each host, the host’s owner should
be authorized as the owner of the machine. An example of the entry in
the local configuration file:

::

    ALLOW_OWNER           = username@cs.wisc.edu/hostname.cs.wisc.edu

In this example the owner has a login of username, and the machine’s
name is represented by hostname.

Debugging Security Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the authorization policy denies a network request, an explanation of
why the request was denied is printed in the log file of the daemon that
denied the request. The line in the log file contains the words
PERMISSION DENIED.

To get HTCondor to generate a similar explanation of why requests are
accepted, add ``D_SECURITY`` to the daemon’s debug options (and restart
or reconfig the daemon). The line in the log file for these cases will
contain the words PERMISSION GRANTED. If you do not want to see a full
explanation but just want to see when requests are made, add
``D_COMMAND`` to the daemon’s debug options.

If the authorization policy makes use of host or domain names, then be
aware that HTCondor depends on DNS to map IP addresses to names. The
security and accuracy of your DNS service is therefore a requirement.
Typos in DNS mappings are an occasional source of unexpected behavior.
If the authorization policy is not behaving as expected, carefully
compare the names in the policy with the host names HTCondor mentions in
the explanations of why requests are granted or denied.

Security Sessions
-----------------

To set up and configure secure communications in HTCondor,
authentication, encryption, and integrity checks can be used. However,
these come at a cost: performing strong authentication can take a
significant amount of time, and generating the cryptographic keys for
encryption and integrity checks can take a significant amount of
processing power.

The HTCondor system makes many network connections between different
daemons. If each one of these was to be authenticated, and new keys were
generated for each connection, HTCondor would not be able to scale well.
Therefore, HTCondor uses the concept of sessions to cache relevant
security information for future use and greatly speed up the
establishment of secure communications between the various HTCondor
daemons.

A new session is established the first time a connection is made from
one daemon to another. Each session has a fixed lifetime after which it
will expire and a new session will need to be created again. But while a
valid session exists, it can be re-used as many times as needed, thereby
preventing the need to continuously re-establish secure connections.
Each entity of a connection will have access to a session key that
proves the identity of the other entity on the opposing side of the
connection. This session key is exchanged securely using a strong
authentication method, such as Kerberos or GSI. Other authentication
methods, such as ``NTSSPI``, ``FS_REMOTE``, ``CLAIMTOBE``, and
``ANONYMOUS``, do not support secure key exchange. An entity listening
on the wire may be able to impersonate the client or server in a session
that does not use a strong authentication method.

Establishing a secure session requires that either the encryption or the
integrity options be enabled. If the encryption capability is enabled,
then the session will be restarted using the session key as the
encryption key. If integrity capability is enabled, then the check sum
includes the session key even though it is not transmitted. Without
either of these two methods enabled, it is possible for an attacker to
use an open session to make a connection to a daemon and use that
connection for nefarious purposes. It is strongly recommended that if
you have authentication turned on, you should also turn on integrity
and/or encryption.

The configuration parameter ``SEC_DEFAULT_NEGOTIATION`` will allow a
user to set the default level of secure sessions in HTCondor. Like other
security settings, the possible values for this parameter can be
REQUIRED, PREFERRED, OPTIONAL, or NEVER. If you disable sessions and you
have authentication turned on, then most authentication (other than
commands like *condor\_submit*) will fail because HTCondor requires
sessions when you have security turned on. On the other hand, if you are
not using strong security in HTCondor, but you are relying on the
default host-based security, turning off sessions may be useful in
certain situations. These might include debugging problems with the
security session management or slightly decreasing the memory
consumption of the daemons, which keep track of the sessions in use.

Session lifetimes for specific daemons are already properly configured
in the default installation of HTCondor. HTCondor tools such as
*condor\_q* and *condor\_status* create a session that expires after one
minute. Theoretically they should not create a session at all, because
the session cannot be reused between program invocations, but this is
difficult to do in the general case. This allows a very small window of
time for any possible attack, and it helps keep the memory footprint of
running daemons down, because they are not keeping track of all of the
sessions. The session durations may be manually tuned by using macros in
the configuration file, but this is not recommended.

Host-Based Security in HTCondor
-------------------------------

This section describes the mechanisms for setting up HTCondor’s
host-based security. This is now an outdated form of implementing
security levels for machine access. It remains available and documented
for purposes of backward compatibility. If used at the same time as the
user-based authorization, the two specifications are merged together.

The host-based security paradigm allows control over which machines can
join an HTCondor pool, which machines can find out information about
your pool, and which machines within a pool can perform administrative
commands. By default, HTCondor is configured to allow anyone to view or
join a pool. It is recommended that this parameter is changed to only
allow access from machines that you trust.

This section discusses how the host-based security works inside
HTCondor. It lists the different levels of access and what parts of
HTCondor use which levels. There is a description of how to configure a
pool to grant or deny certain levels of access to various machines.
Configuration examples and the settings of configuration variables using
the *condor\_config\_val* command complete this section.

Inside the HTCondor daemons or tools that use DaemonCore (see
section \ `3.11 <DaemonCore.html#x39-3300003.11>`__ for details), most
tasks are accomplished by sending commands to another HTCondor daemon.
These commands are represented by an integer value to specify which
command is being requested, followed by any optional information that
the protocol requires at that point (such as a ClassAd, capability
string, etc). When the daemons start up, they will register which
commands they are willing to accept, what to do with arriving commands,
and the access level required for each command. When a command request
is received by a daemon, HTCondor identifies the access level required
and checks the IP address of the sender to verify that it satisfies the
allow/deny settings from the configuration file. If permission is
granted, the command request is honored; otherwise, the request will be
aborted.

Settings for the access levels in the global configuration file will
affect all the machines in the pool. Settings in a local configuration
file will only affect the specific machine. The settings for a given
machine determine what other hosts can send commands to that machine. If
a machine foo is to be given administrator access on machine bar, place
foo in bar’s configuration file access list (not the other way around).

The following are the various access levels that commands within
HTCondor can be registered with:

 ``READ``
    Machines with ``READ`` access can read information from the HTCondor
    daemons. For example, they can view the status of the pool, see the
    job queue(s), and view user permissions. ``READ`` access does not
    allow a machine to alter any information, and does not allow job
    submission. A machine listed with ``READ`` permission will be unable
    join an HTCondor pool; the machine can only view information about
    the pool.
 ``WRITE``
    Machines with ``WRITE`` access can write information to the HTCondor
    daemons. Most important for granting a machine with this access is
    that the machine will be able to join a pool since they are allowed
    to send ClassAd updates to the central manager. The machine can talk
    to the other machines in a pool in order to submit or run jobs. In
    addition, any machine with ``WRITE`` access can request the
    *condor\_startd* daemon to perform periodic checkpoints on an
    executing job. After the checkpoint is completed, the job will
    continue to execute and the machine will still be claimed by the
    original *condor\_schedd* daemon. This allows users on the machines
    where they submitted their jobs to use the *condor\_checkpoint*
    command to get their jobs to periodically checkpoint, even if the
    users do not have an account on the machine where the jobs execute.

    **IMPORTANT:** For a machine to join an HTCondor pool, the machine
    must have both ``WRITE`` permission **AND** ``READ`` permission.
    ``WRITE`` permission is not enough.

 ``ADMINISTRATOR``
    Machines with ``ADMINISTRATOR`` access are granted additional
    HTCondor administrator rights to the pool. This includes the ability
    to change user priorities with the command *condor\_userprio*, and
    the ability to turn HTCondor on and off using *condor\_on* and
    *condor\_off*. It is recommended that few machines be granted
    administrator access in a pool; typically these are the machines
    that are used by HTCondor and system administrators as their primary
    workstations, or the machines running as the pool’s central manager.

    **IMPORTANT:** Giving ``ADMINISTRATOR`` privileges to a machine
    grants administrator access for the pool to **ANY USER** on that
    machine. This includes any users who can run HTCondor jobs on that
    machine. It is recommended that ``ADMINISTRATOR`` access is granted
    with due diligence.

 ``OWNER``
    This level of access is required for commands that the owner of a
    machine (any local user) should be able to use, in addition to the
    HTCondor administrators. For example, the *condor\_vacate* command
    causes the *condor\_startd* daemon to vacate any running HTCondor
    job. It requires ``OWNER`` permission, so that any user logged into
    a local machine can issue a *condor\_vacate* command.
 ``NEGOTIATOR``
    This access level is used specifically to verify that commands are
    sent by the *condor\_negotiator* daemon. The *condor\_negotiator*
    daemon runs on the central manager of the pool. Commands requiring
    this access level are the ones that tell the *condor\_schedd* daemon
    to begin negotiating, and those that tell an available
    *condor\_startd* daemon that it has been matched to a
    *condor\_schedd* with jobs to run.
 ``CONFIG``
    This access level is required to modify a daemon’s configuration
    using the *condor\_config\_val* command. By default, machines with
    this level of access are able to change any configuration parameter,
    except those specified in the ``condor_config.root`` configuration
    file. Therefore, one should exercise extreme caution before granting
    this level of host-wide access. Because of the implications caused
    by ``CONFIG`` privileges, it is disabled by default for all hosts.
 ``DAEMON``
    This access level is used for commands that are internal to the
    operation of HTCondor. An example of this internal operation is when
    the *condor\_startd* daemon sends its ClassAd updates to the
    *condor\_collector* daemon (which may be more specifically
    controlled by the ``ADVERTISE_STARTD`` access level). Authorization
    at this access level should only be given to hosts that actually run
    HTCondor in your pool. The ``DAEMON`` level of access implies both
    ``READ`` and ``WRITE`` access. Any setting for this access level
    that is not defined will default to the corresponding setting in the
    ``WRITE`` access level.
 ``ADVERTISE_MASTER``
    This access level is used specifically for commands used to
    advertise a *condor\_master* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``ADVERTISE_STARTD``
    This access level is used specifically for commands used to
    advertise a *condor\_startd* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``ADVERTISE_SCHEDD``
    This access level is used specifically for commands used to
    advertise a *condor\_schedd* daemon to the collector. Any setting
    for this access level that is not defined will default to the
    corresponding setting in the ``DAEMON`` access level.
 ``CLIENT``
    This access level is different from all the others. Whereas all of
    the other access levels refer to the security policy for accepting
    connections from others, the ``CLIENT`` access level applies when an
    HTCondor daemon or tool is connecting to some other HTCondor daemon.
    In other words, it specifies the policy of the client that is
    initiating the operation, rather than the server that is being
    contacted.

``ADMINISTRATOR`` and ``NEGOTIATOR`` access default to the central
manager machine. ``OWNER`` access defaults to the local machine, as well
as any machines given with ``ADMINISTRATOR`` access. ``CONFIG`` access
is not granted to any machine as its default. These defaults are
sufficient for most pools, and should not be changed without a
compelling reason. If machines other than the default are to have to
have ``OWNER`` access, they probably should also have ``ADMINISTRATOR``
access. By granting machines ``ADMINISTRATOR`` access, they will
automatically have ``OWNER`` access, given how ``OWNER`` access is set
within the configuration.

Examples of Security Configuration
----------------------------------

Here is a sample security configuration:

::

    ALLOW_ADMINISTRATOR = $(CONDOR_HOST) 
    ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR) 
    ALLOW_READ = * 
    ALLOW_WRITE = * 
    ALLOW_NEGOTIATOR = $(COLLECTOR_HOST) 
    ALLOW_NEGOTIATOR_SCHEDD = $(COLLECTOR_HOST), $(FLOCK_NEGOTIATOR_HOSTS) 
    ALLOW_WRITE_COLLECTOR = $(ALLOW_WRITE), $(FLOCK_FROM) 
    ALLOW_WRITE_STARTD    = $(ALLOW_WRITE), $(FLOCK_FROM) 
    ALLOW_READ_COLLECTOR  = $(ALLOW_READ), $(FLOCK_FROM) 
    ALLOW_READ_STARTD     = $(ALLOW_READ), $(FLOCK_FROM) 
    ALLOW_CLIENT = *

This example configuration presumes that the *condor\_collector* and
*condor\_negotiator* daemons are running on the same machine.

For each access level, an ALLOW or a DENY may be added.

-  If there is an ALLOW, it means "only allow these machines". No ALLOW
   means allow anyone.
-  If there is a DENY, it means "deny these machines". No DENY means
   deny nobody.
-  If there is both an ALLOW and a DENY, it means allow the machines
   listed in ALLOW except for the machines listed in DENY.
-  Exclusively for the ``CONFIG`` access, no ALLOW means allow no one.
   Note that this is different than the other ALLOW configurations. It
   is different to enable more stringent security where older
   configurations are used, since older configuration files would not
   have a ``CONFIG`` configuration entry.

Multiple machine entries in the configuration files may be separated by
either a space or a comma. The machines may be listed by

-  Individual host names, for example: ``condor.cs.wisc.edu``
-  Individual IP address, for example: ``128.105.67.29``
-  IP subnets (use a trailing ``*``), for example:
   ``144.105.*, 128.105.67.*``
-  Host names with a wild card ``*`` character (only one ``*`` is
   allowed per name), for example: ``*.cs.wisc.edu, sol*.cs.wisc.edu``

To resolve an entry that falls into both allow and deny: individual
machines have a higher order of precedence than wild card entries, and
host names with a wild card have a higher order of precedence than IP
subnets. Otherwise, DENY has a higher order of precedence than ALLOW.
This is how most people would intuitively expect it to work.

In addition, the above access levels may be specified on a per-daemon
basis, instead of machine-wide for all daemons. Do this with the
subsystem string (described in
section \ `3.3.12 <IntroductiontoConfiguration.html#x31-1810003.3.12>`__
on Subsystem Names), which is one of: ``STARTD``, ``SCHEDD``,
``MASTER``, ``NEGOTIATOR``, or ``COLLECTOR``. For example, to grant
different read access for the *condor\_schedd*:

::

    ALLOW_READ_SCHEDD = <list of machines>

Here are more examples of configuration settings. Notice that
``ADMINISTRATOR`` access is only granted through an ``ALLOW`` setting to
explicitly grant access to a small number of machines. We recommend
this.

-  Let any machine join the pool. Only the central manager has
   administrative access.

   ::

       ALLOW_ADMINISTRATOR = $(CONDOR_HOST) 
       ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

-  Only allow machines at NCSA to join or view the pool. The central
   manager is the only machine with ``ADMINISTRATOR`` access.

   ::

       ALLOW_READ = *.ncsa.uiuc.edu 
       ALLOW_WRITE = *.ncsa.uiuc.edu 
       ALLOW_ADMINISTRATOR = $(CONDOR_HOST) 
       ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

-  Only allow machines at NCSA and the U of I Math department join the
   pool, except do not allow lab machines to do so. Also, do not allow
   the 177.55 subnet (perhaps this is the dial-in subnet). Allow anyone
   to view pool statistics. The machine named bigcheese administers the
   pool (not the central manager).

   ::

       ALLOW_WRITE = *.ncsa.uiuc.edu, *.math.uiuc.edu 
       DENY_WRITE = lab-*.edu, *.lab.uiuc.edu, 177.55.* 
       ALLOW_ADMINISTRATOR = bigcheese.ncsa.uiuc.edu 
       ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

-  Only allow machines at NCSA and UW-Madison’s CS department to view
   the pool. Only NCSA machines and the machine raven.cs.wisc.edu can
   join the pool. Note: the machine raven.cs.wisc.edu has the read
   access it needs through the wild card setting in ``ALLOW_READ``).
   This example also shows how to use the continuation character, \\, to
   continue a long list of machines onto multiple lines, making it more
   readable. This works for all configuration file entries, not just
   host access entries.

   ::

       ALLOW_READ = *.ncsa.uiuc.edu, *.cs.wisc.edu 
       ALLOW_WRITE = *.ncsa.uiuc.edu, raven.cs.wisc.edu 
       ALLOW_ADMINISTRATOR = $(CONDOR_HOST), bigcheese.ncsa.uiuc.edu, \ 
                                 biggercheese.uiuc.edu 
       ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

-  Allow anyone except the military to view the status of the pool, but
   only let machines at NCSA view the job queues. Only NCSA machines can
   join the pool. The central manager, bigcheese, and biggercheese can
   perform most administrative functions. However, only biggercheese can
   update user priorities.

   ::

       DENY_READ = *.mil 
       ALLOW_READ_SCHEDD = *.ncsa.uiuc.edu 
       ALLOW_WRITE = *.ncsa.uiuc.edu 
       ALLOW_ADMINISTRATOR = $(CONDOR_HOST), bigcheese.ncsa.uiuc.edu, \ 
                                 biggercheese.uiuc.edu 
       ALLOW_ADMINISTRATOR_NEGOTIATOR = biggercheese.uiuc.edu 
       ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

Changing the Security Configuration
-----------------------------------

A new security feature introduced in HTCondor version 6.3.2 enables more
fine-grained control over the configuration settings that can be
modified remotely with the *condor\_config\_val* command. The manual
page for *condor\_config\_val* on
page \ `1835 <Condorconfigval.html#x105-73100012>`__ details how to use
*condor\_config\_val* to modify configuration settings remotely. Since
certain configuration attributes can have a large impact on the
functioning of the HTCondor system and the security of the machines in
an HTCondor pool, it is important to restrict the ability to change
attributes remotely.

For each security access level described, the HTCondor administrator can
define which configuration settings a host at that access level is
allowed to change. Optionally, the administrator can define separate
lists of settable attributes for each HTCondor daemon, or the
administrator can define one list that is used by all daemons.

For each command that requests a change in configuration setting,
HTCondor searches all the different possible security access levels to
see which, if any, the request satisfies. (Some hosts can qualify for
multiple access levels. For example, any host with ``ADMINISTRATOR``
permission probably has ``WRITE`` permission also). Within the qualified
access level, HTCondor searches for the list of attributes that may be
modified. If the request is covered by the list, the request will be
granted. If not covered, the request will be refused.

The default configuration shipped with HTCondor is exceedingly
restrictive. HTCondor users or administrators cannot set configuration
values from remote hosts with *condor\_config\_val*. Enabling this
feature requires a change to the settings in the configuration file. Use
this security feature carefully. Grant access only for attributes which
you need to be able to modify in this manner, and grant access only at
the most restrictive security level possible.

The most secure use of this feature allows HTCondor users to set
attributes in the configuration file which are not used by HTCondor
directly. These are custom attributes published by various HTCondor
daemons with the ``<SUBSYS>_ATTRS`` setting described in
section \ `3.5.3 <ConfigurationMacros.html#x33-1900003.5.3>`__ on
page \ `619 <ConfigurationMacros.html#x33-1900003.5.3>`__. It is secure
to grant access only to modify attributes that are used by HTCondor to
publish information. Granting access to modify settings used to control
the behavior of HTCondor is not secure. The goal is to ensure no one can
use the power to change configuration attributes to compromise the
security of your HTCondor pool.

The control lists are defined by configuration settings that contain
``SETTABLE_ATTRS`` in their name. The name of the control lists have the
following form:

::

    <SUBSYS>.SETTABLE_ATTRS_<PERMISSION-LEVEL>

The two parts of this name that can vary are the <PERMISSION-LEVEL> and
the <SUBSYS>. The <PERMISSION-LEVEL> can be any of the security access
levels described earlier in this section. Examples include ``WRITE``,
``OWNER``, and ``CONFIG``.

The <SUBSYS> is an optional portion of the name. It can be used to
define separate rules for which configuration attributes can be set for
each kind of HTCondor daemon (for example, ``STARTD``, ``SCHEDD``, and
``MASTER``). There are many configuration settings that can be defined
differently for each daemon that use this <SUBSYS> naming convention.
See
section \ `3.3.12 <IntroductiontoConfiguration.html#x31-1810003.3.12>`__
on page \ `567 <IntroductiontoConfiguration.html#x31-1810003.3.12>`__
for a list. If there is no daemon-specific value for a given daemon,
HTCondor will look for ``SETTABLE_ATTRS_<PERMISSION-LEVEL>`` .

Each control list is defined by a comma-separated list of attribute
names which should be allowed to be modified. The lists can contain wild
cards characters (\*).

Some examples of valid definitions of control lists with explanations:

-  ::

       SETTABLE_ATTRS_CONFIG = *

   Grant unlimited access to modify configuration attributes to any
   request that came from a machine in the ``CONFIG`` access level. This
   was the default behavior before HTCondor version 6.3.2.

-  ::

       SETTABLE_ATTRS_ADMINISTRATOR = *_DEBUG, MAX_*_LOG

   Grant access to change any configuration setting that ended with
   \_DEBUG (for example, ``STARTD_DEBUG``) and any attribute that
   matched MAX\_\*\_LOG (for example, ``MAX_SCHEDD_LOG``) to any host
   with ``ADMINISTRATOR`` access.

-  ::

       STARTD.SETTABLE_ATTRS_OWNER = HasDataSet

   Allows any request to modify the ``HasDataSet`` attribute that came
   from a host with ``OWNER`` access. By default, ``OWNER`` covers any
   request originating from the local host, plus any machines listed in
   the ``ADMINISTRATOR`` level. Therefore, any HTCondor job would
   qualify for OWNER access to the machine where it is running. So, this
   setting would allow any process running on a given host, including an
   HTCondor job, to modify the ``HasDataSet`` variable for that host.
   ``HasDataSet`` is not used by HTCondor, it is an invented attribute
   included in the ``STARTD_ATTRS`` setting in order for this example to
   make sense.

Using HTCondor w/ Firewalls, Private Networks, and NATs
-------------------------------------------------------

This topic is now addressed in more detail in
section \ `3.9 <NetworkingincludessectionsonPortUsageandCCB.html#x37-3000003.9>`__,
which explains network communication in HTCondor.

User Accounts in HTCondor on Unix Platforms
-------------------------------------------

On a Unix system, UIDs (User IDentification numbers) form part of an
operating system’s tools for maintaining access control. Each executing
program has a UID, a unique identifier of a user executing the program.
This is also called the real UID. A common situation has one user
executing the program owned by another user. Many system commands work
this way, with a user (corresponding to a person) executing a program
belonging to (owned by) root. Since the program may require privileges
that root has which the user does not have, a special bit in the
program’s protection specification (a setuid bit) allows the program to
run with the UID of the program’s owner, instead of the user that
executes the program. This UID of the program’s owner is called an
effective UID.

HTCondor works most smoothly when its daemons run as root. The daemons
then have the ability to switch their effective UIDs at will. When the
daemons run as root, they normally leave their effective UID and GID
(Group IDentification) to be those of user and group condor. This allows
access to the log files without changing the ownership of the log files.
It also allows access to these files when the user condor’s home
directory resides on an NFS server. root can not normally access NFS
files.

If there is no condor user and group on the system, an administrator can
specify which UID and GID the HTCondor daemons should use when they do
not need root privileges in two ways: either with the ``CONDOR_IDS``
environment variable or the ``CONDOR_IDS`` configuration variable. In
either case, the value should be the UID integer, followed by a period,
followed by the GID integer. For example, if an HTCondor administrator
does not want to create a condor user, and instead wants their HTCondor
daemons to run as the daemon user (a common non-root user for system
daemons to execute as), the daemon user’s UID was 2, and group daemon
had a GID of 2, the corresponding setting in the HTCondor configuration
file would be ``CONDOR_IDS = 2.2``.

On a machine where a job is submitted, the *condor\_schedd* daemon
changes its effective UID to root such that it has the capability to
start up a *condor\_shadow* daemon for the job. Before a
*condor\_shadow* daemon is created, the *condor\_schedd* daemon switches
back to root, so that it can start up the *condor\_shadow* daemon with
the (real) UID of the user who submitted the job. Since the
*condor\_shadow* runs as the owner of the job, all remote system calls
are performed under the owner’s UID and GID. This ensures that as the
job executes, it can access only files that its owner could access if
the job were running locally, without HTCondor.

On the machine where the job executes, the job runs either as the
submitting user or as user nobody, to help ensure that the job cannot
access local resources or do harm. If the ``UID_DOMAIN`` matches, and
the user exists as the same UID in password files on both the submitting
machine and on the execute machine, the job will run as the submitting
user. If the user does not exist in the execute machine’s password file
and ``SOFT_UID_DOMAIN`` is True, then the job will run under the
submitting user’s UID anyway (as defined in the submitting machine’s
password file). If ``SOFT_UID_DOMAIN`` is False, and ``UID_DOMAIN``
matches, and the user is not in the execute machine’s password file,
then the job execution attempt will be aborted.

Running HTCondor as Non-Root
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While we strongly recommend starting up the HTCondor daemons as root, we
understand that it is not always possible to do so. The main problems of
not running HTCondor daemons as root appear when one HTCondor
installation is shared by many users on a single machine, or if machines
are set up to only execute HTCondor jobs. With a submit-only
installation for a single user, there is no need for or benefit from
running as root.

The effects of HTCondor of running both with and without root access are
classified for each daemon:

 *condor\_startd*
    An HTCondor machine set up to execute jobs where the
    *condor\_startd* is not started as root relies on the good will of
    the HTCondor users to agree to the policy configured for the
    *condor\_startd* to enforce for starting, suspending, vacating, and
    killing HTCondor jobs. When the *condor\_startd* is started as root,
    however, these policies may be enforced regardless of malicious
    users. By running as root, the HTCondor daemons run with a different
    UID than the HTCondor job. The user’s job is started as either the
    UID of the user who submitted it, or as user nobody, depending on
    the ``UID_DOMAIN`` settings. Therefore, the HTCondor job cannot do
    anything to the HTCondor daemons. Without starting the daemons as
    root, all processes started by HTCondor, including the user’s job,
    run with the same UID. Only root can switch UIDs. Therefore, a
    user’s job could kill the *condor\_startd* and *condor\_starter*. By
    doing so, the user’s job avoids getting suspended or vacated. This
    is nice for the job, as it obtains unlimited access to the machine,
    but it is awful for the machine owner or administrator. If there is
    trust of the users submitting jobs to HTCondor, this might not be a
    concern. However, to ensure that the policy chosen is enforced by
    HTCondor, the *condor\_startd* should be started as root.

    In addition, some system information cannot be obtained without root
    access on some platforms. As a result, when running without root
    access, the *condor\_startd* must call other programs such as
    *uptime*, to get this information. This is much less efficient than
    getting the information directly from the kernel, as is done when
    running as root. On Linux, this information is available without
    root access, so it is not a concern on those platforms.

    If all of HTCondor cannot be run as root, at least consider
    installing the *condor\_startd* as setuid root. That would solve
    both problems. Barring that, install it as a setgid sys or kmem
    program, depending on whatever group has read access to
    ``/dev/kmem`` on the system. That would solve the system information
    problem.

 *condor\_schedd*
    The biggest problem with running the *condor\_schedd* without root
    access is that the *condor\_shadow* processes which it spawns are
    stuck with the same UID that the *condor\_schedd* has. This requires
    users to go out of their way to grant write access to user or group
    that the *condor\_schedd* is run as for any files or directories
    their jobs write or create. Similarly, read access must be granted
    to their input files.

    Consider installing *condor\_submit* as a setgid condor program so
    that at least the ``stdout``, ``stderr`` and job event log files get
    created with the right permissions. If *condor\_submit* is a setgid
    program, it will automatically set its umask to 002 and create
    group-writable files. This way, the simple case of a job that only
    writes to ``stdout`` and ``stderr`` will work. If users have
    programs that open their own files, they will need to know and set
    the proper permissions on the directories they submit from.

 *condor\_master*
    The *condor\_master* spawns both the *condor\_startd* and the
    *condor\_schedd*. To have both running as root, have the
    *condor\_master* run as root. This happens automatically if the
    *condor\_master* is started from boot scripts.
 *condor\_negotiator* and *condor\_collector*
    There is no need to have either of these daemons running as root.
 *condor\_kbdd*
    On platforms that need the *condor\_kbdd*, the *condor\_kbdd* must
    run as root. If it is started as any other user, it will not work.
    Consider installing this program as a setuid root binary if the
    *condor\_master* will not be run as root. Without the
    *condor\_kbdd*, the *condor\_startd* has no way to monitor USB mouse
    or keyboard activity, although it will notice keyboard activity on
    ttys such as xterms and remote logins.

If HTCondor is not run as root, then choose almost any user name. A
common choice is to set up and use the condor user; this simplifies the
setup, because HTCondor will look for its configuration files in the
condor user’s directory. If condor is not selected, then the
configuration must be placed properly such that HTCondor can find its
configuration files.

If users will be submitting jobs as a user different than the user
HTCondor is running as (perhaps you are running as the condor user and
users are submitting as themselves), then users have to be careful to
only have file permissions properly set up to be accessible by the user
HTCondor is using. In practice, this means creating world-writable
directories for output from HTCondor jobs. This creates a potential
security risk, in that any user on the machine where the job is
submitted can alter the data, remove it, or do other undesirable things.
It is only acceptable in an environment where users can trust other
users.

Normally, users without root access who wish to use HTCondor on their
machines create a ``condor`` home directory somewhere within their own
accounts and start up the daemons (to run with the UID of the user). As
in the case where the daemons run as user condor, there is no ability to
switch UIDs or GIDs. The daemons run as the UID and GID of the user who
started them. On a machine where jobs are submitted, the
*condor\_shadow* daemons all run as this same user. But, if other users
are using HTCondor on the machine in this environment, the
*condor\_shadow* daemons for these other users’ jobs execute with the
UID of the user who started the daemons. This is a security risk, since
the HTCondor job of the other user has access to all the files and
directories of the user who started the daemons. Some installations have
this level of trust, but others do not. Where this level of trust does
not exist, it is best to set up a condor account and group, or to have
each user start up their own Personal HTCondor submit installation.

When a machine is an execution site for an HTCondor job, the HTCondor
job executes with the UID of the user who started the *condor\_startd*
daemon. This is also potentially a security risk, which is why we do not
recommend starting up the execution site daemons as a regular user. Use
either root or a user such as condor that exists only to run HTCondor
jobs.

Who Jobs Run As
~~~~~~~~~~~~~~~

Under Unix, HTCondor runs jobs as one of

-  the user called nobody

   Running jobs as the nobody user is the least preferable. HTCondor
   uses user nobody if the value of the ``UID_DOMAIN`` configuration
   variable of the submitting and executing machines are different, or
   if configuration variable ``STARTER_ALLOW_RUNAS_OWNER`` is ``False``,
   or if the job ClassAd contains ``RunAsOwner=False``.

   When HTCondor cleans up after executing a vanilla universe job, it
   does the best that it can by deleting all of the processes started by
   the job. During the life of the job, it also does its best to track
   the CPU usage of all processes created by the job. There are a
   variety of mechanisms used by HTCondor to detect all such processes,
   but, in general, the only foolproof mechanism is for the job to run
   under a dedicated execution account (as it does under Windows by
   default). With all other mechanisms, it is possible to fool HTCondor,
   and leave processes behind after HTCondor has cleaned up. In the case
   of a shared account, such as the Unix user nobody, it is possible for
   the job to leave a lurker process lying in wait for the next job run
   as nobody. The lurker process may prey maliciously on the next nobody
   user job, wreaking havoc.

   HTCondor could prevent this problem by simply killing all processes
   run by the nobody user, but this would annoy many system
   administrators. The nobody user is often used for non-HTCondor system
   processes. It may also be used by other HTCondor jobs running on the
   same machine, if it is a multi-processor machine.

-  dedicated accounts called slot users set up for the purpose of
   running HTCondor jobs

   Better than the nobody user will be to create user accounts for
   HTCondor to use. These can be low-privilege accounts, just as the
   nobody user is. Create one of these accounts for each job execution
   slot per computer, so that distinct user names can be used for
   concurrently running jobs. This prevents malicious or naive behavior
   from one slot to affect another slot. For a sample machine with two
   compute slots, create two users that are intended only to be used by
   HTCondor. As an example, call them cndrusr1 and cndrusr2.
   Configuration identifies these users with the ``SLOT<N>_USER``
   configuration variable, where ``<N>`` is replaced with the slot
   number. Here is configuration for this example:

   ::

          SLOT1_USER = cndrusr1 
          SLOT2_USER = cndrusr2

   Also tell HTCondor that these accounts are intended only to be used
   by HTCondor, so HTCondor can kill all the processes belonging to
   these users upon job completion. The configuration variable
   ``DEDICATED_EXECUTE_ACCOUNT_REGEXP`` is introduced and set to a
   regular expression that matches the account names just created:

   ::

          DEDICATED_EXECUTE_ACCOUNT_REGEXP = cndrusr[0-9]+

   Finally, tell HTCondor not to run jobs as the job owner:

   ::

          STARTER_ALLOW_RUNAS_OWNER = False

-  the user that submitted the jobs

   Four conditions must be set correctly to run jobs as the user that
   submitted the job.

   #. In the configuration, the value of variable
      ``STARTER_ALLOW_RUNAS_OWNER`` must be ``True`` on the machine that
      will run the job. Its default value is ``True`` on Unix platforms
      and ``False`` on Windows platforms.
   #. The job’s ClassAd must have attribute ``RunAsOwner`` set to
      ``True``. This can be set up for all users by adding an attribute
      to configuration variable ``SUBMIT_ATTRS`` . If this were the only
      attribute to be added to all job ClassAds, it would be set up with

      ::

            SUBMIT_ATTRS = RunAsOwner 
            RunAsOwner = True

   #. The value of configuration variable ``UID_DOMAIN`` must be the
      same for both the *condor\_startd* and *condor\_schedd* daemons.
   #. The UID\_DOMAIN must be trusted. For example, if the
      *condor\_starter* daemon does a reverse DNS lookup on the
      *condor\_schedd* daemon, and finds that the result is not the same
      as defined for configuration variable ``UID_DOMAIN``, then it is
      not trusted. To correct this, set in the configuration for the
      *condor\_starter*

      ::

            TRUST_UID_DOMAIN = True

Notes:

#. Currently, none of these configuration settings apply to standard
   universe jobs. Normally, standard universe jobs do not create
   additional processes.
#. Under Windows, HTCondor by default runs jobs under a dynamically
   created local account that exists for the duration of the job, but it
   can optionally run the job as the user account that owns the job if
   ``STARTER_ALLOW_RUNAS_OWNER`` is ``True`` and the job contains
   ``RunAsOwner``\ =True.

   ``SLOT<N>_USER`` will only work if the credential of the specified
   user is stored on the execute machine using *condor\_store\_cred*.
   for details of this command. However, the default behavior in Windows
   is to run jobs under a dynamically created dedicated execution
   account, so just using the default behavior is sufficient to avoid
   problems with lurker processes. See
   section \ `8.2.4 <MicrosoftWindows.html#x76-5770008.2.4>`__,
    `8.2.5 <MicrosoftWindows.html#x76-5780008.2.5>`__, and the
   *condor\_store\_cred* manual page at
   section \ `12 <Condorstorecred.html#x148-107300012>`__ for details.

#. The *condor\_starter* logs a line similar to

   ::

       Tracking process family by login "cndrusr1"

   when it treats the account as a dedicated account.

Working Directories for Jobs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every executing process has a notion of its current working directory.
This is the directory that acts as the base for all file system access.
There are two current working directories for any HTCondor job: one
where the job is submitted and a second where the job executes. When a
user submits a job, the submit-side current working directory is the
same as for the user when the *condor\_submit* command is issued. The
**initialdir** submit command may change this, thereby allowing
different jobs to have different working directories. This is useful
when submitting large numbers of jobs. This submit-side current working
directory remains unchanged for the entire life of a job. The
submit-side current working directory is also the working directory of
the *condor\_shadow* daemon. This is particularly relevant for standard
universe jobs, since file system access for the job goes through the
*condor\_shadow* daemon, and therefore all accesses behave as if they
were executing without HTCondor.

There is also an execute-side current working directory. For standard
universe jobs, it is set to the ``execute`` subdirectory of HTCondor’s
home directory. This directory is world-writable, since an HTCondor job
usually runs as user nobody. Normally, standard universe jobs would
never access this directory, since all I/O system calls are passed back
to the *condor\_shadow* daemon on the submit machine. In the event,
however, that a job crashes and creates a core dump file, the
execute-side current working directory needs to be accessible by the job
so that it can write the core file. The core file is moved back to the
submit machine, and the *condor\_shadow* daemon is informed. The
*condor\_shadow* daemon sends e-mail to the job owner announcing the
core file, and provides a pointer to where the core file resides in the
submit-side current working directory.

      
