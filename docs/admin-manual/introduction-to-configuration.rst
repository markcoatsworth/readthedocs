      

Introduction to Configuration
=============================

This section of the manual contains general information about HTCondor
configuration, relating to all parts of the HTCondor system. If you’re
setting up an HTCondor pool, you should read this section before you
read the other configuration-related sections:

-  Section \ `3.4 <ConfigurationTemplates.html#x32-1820003.4>`__
   contains information about configuration templates, which are now the
   preferred way to set many configuration macros.
-  Section \ `3.5 <ConfigurationMacros.html#x33-1870003.5>`__ contains
   information about the hundreds of individual configuration macros. In
   general, it is best to try to achieve your desired configuration
   using configuration templates before resorting to setting individual
   configuration macros, but it is sometimes necessary to set individual
   configuration macros.
-  The settings that control the policy under which HTCondor will start,
   suspend, resume, vacate or kill jobs are described in
   section \ `3.7 <PolicyConfigurationforExecuteHostsandforSubmitHosts.html#x35-2410003.7>`__
   on Policy Configuration for the *condor\_startd*.

HTCondor Configuration Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The HTCondor configuration files are used to customize how HTCondor
operates at a given site. The basic configuration as shipped with
HTCondor can be used as a starting point, but most likely you will want
to modify that configuration to some extent.

Each HTCondor program will, as part of its initialization process,
configure itself by calling a library routine which parses the various
configuration files that might be used, including pool-wide,
platform-specific, and machine-specific configuration files. Environment
variables may also contribute to the configuration.

The result of configuration is a list of key/value pairs. Each key is a
configuration variable name, and each value is a string literal that may
utilize macro substitution (as defined below). Some configuration
variables are evaluated by HTCondor as ClassAd expressions; some are
not. Consult the documentation for each specific case. Unless otherwise
noted, configuration values that are expected to be numeric or boolean
constants can be any valid ClassAd expression of operators on constants.
Example:

::

    MINUTE          = 60
     HOUR            = (60 * $(MINUTE))
     SHUTDOWN_GRACEFUL_TIMEOUT = ($(HOUR)*24)

Ordered Evaluation to Set the Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Multiple files, as well as a program’s environment variables, determine
the configuration. The order in which attributes are defined is
important, as later definitions override earlier definitions. The order
in which the (multiple) configuration files are parsed is designed to
ensure the security of the system. Attributes which must be set a
specific way must appear in the last file to be parsed. This prevents
both the naive and the malicious HTCondor user from subverting the
system through its configuration. The order in which items are parsed
is:

#. a single initial configuration file, which has historically been
   known as the global configuration file (see below);
#. other configuration files that are referenced and parsed due to
   specification within the single initial configuration file (these
   files have historically been known as local configuration files);
#. if HTCondor daemons are not running as root on Unix platforms, the
   file $(HOME)/.condor/user\_config if it exists, or the file defined
   by configuration variable USER\_CONFIG\_FILE ;

   if HTCondor daemons are not running as Local System on Windows
   platforms, the file %USERPROFILE\\.condor\\user\_config if it exists,
   or the file defined by configuration variable USER\_CONFIG\_FILE ;

#. specific environment variables whose names are prefixed with
   \_CONDOR\_ (note that these environment variables directly define
   macro name/value pairs, not the names of configuration files).

Some HTCondor tools utilize environment variables to set their
configuration; these tools search for specifically-named environment
variables. The variable names are prefixed by the string \_CONDOR\_ or
\_condor\_. The tools strip off the prefix, and utilize what remains as
configuration. As the use of environment variables is the last within
the ordered evaluation, the environment variable definition is used. The
security of the system is not compromised, as only specific variables
are considered for definition in this manner, not any environment
variables with the \_CONDOR\_ prefix.

The location of the single initial configuration file differs on Windows
from Unix platforms. For Unix platforms, the location of the single
initial configuration file starts at the top of the following list. The
first file that exists is used, and then remaining possible file
locations from this list become irrelevant.

#. the file specified by the CONDOR\_CONFIG environment variable. If
   there is a problem reading that file, HTCondor will print an error
   message and exit right away.
#. /etc/condor/condor\_config
#. /usr/local/etc/condor\_config
#. ˜condor/condor\_config

For Windows platforms, the location of the single initial configuration
file is determined by the contents of the environment variable
CONDOR\_CONFIG. If this environment variable is not defined, then the
location is the registry value of
HKEY\_LOCAL\_MACHINE/Software/Condor/CONDOR\_CONFIG.

The single, initial configuration file may contain the specification of
one or more other configuration files, referred to here as local
configuration files. Since more than one file may contain a definition
of the same variable, and since the last definition of a variable sets
the value, the parse order of these local configuration files is fully
specified here. In order:

#. The value of configuration variable LOCAL\_CONFIG\_DIR lists one or
   more directories which contain configuration files. The list is
   parsed from left to right. The leftmost (first) in the list is parsed
   first. Within each directory, a lexicographical ordering by file name
   determines the ordering of file consideration.
#. The value of configuration variable LOCAL\_CONFIG\_FILE lists one or
   more configuration files. These listed files are parsed from left to
   right. The leftmost (first) in the list is parsed first.
#. If one of these steps changes the value (right hand side) of
   LOCAL\_CONFIG\_DIR, then LOCAL\_CONFIG\_DIR is processed for a second
   time, using the changed list of directories.

The parsing and use of configuration files may be bypassed by setting
environment variable CONDOR\_CONFIG with the string ONLY\_ENV. With this
setting, there is no attempt to locate or read configuration files. This
may be useful for testing where the environment contains all needed
information.

Configuration File Macros
^^^^^^^^^^^^^^^^^^^^^^^^^

Macro definitions are of the form:

::

    <macro_name> = <macro_definition>

The macro name given on the left hand side of the definition is a case
insensitive identifier. There may be white space between the macro name,
the equals sign (=), and the macro definition. The macro definition is a
string literal that may utilize macro substitution.

Macro invocations are of the form:

::

    $(macro_name[:<default if macro_name not defined>])

The colon and default are optional in a macro invocation. Macro
definitions may contain references to other macros, even ones that are
not yet defined, as long as they are eventually defined in the
configuration files. All macro expansion is done after all configuration
files have been parsed, with the exception of macros that reference
themselves.

::

    A = xxx
     C = $(A)

is a legal set of macro definitions, and the resulting value of C is
xxx. Note that C is actually bound to $(A), not its value.

As a further example,

::

    A = xxx
     C = $(A)
     A = yyy

is also a legal set of macro definitions, and the resulting value of C
is yyy.

A macro may be incrementally defined by invoking itself in its
definition. For example,

::

    A = xxx
     B = $(A)
     A = $(A)yyy
     A = $(A)zzz

is a legal set of macro definitions, and the resulting value of A is
xxxyyyzzz. Note that invocations of a macro in its own definition are
immediately expanded. $(A) is immediately expanded in line 3 of the
example. If it were not, then the definition would be impossible to
evaluate.

Recursively defined macros such as

::

    A = $(B)
     B = $(A)

are not allowed. They create definitions that HTCondor refuses to parse.

A macro invocation where the macro name is not defined results in a
substitution of the empty string. Consider the example

::

    MAX_ALLOC_CPUS = $(NUMCPUS)-1

If NUMCPUS is not defined, then this macro substitution becomes

::

    MAX_ALLOC_CPUS = -1

The default value may help to avoid this situation. The default value
may be a literal

::

    MAX_ALLOC_CPUS = $(NUMCPUS:4)-1

such that if NUMCPUS is not defined, the result of macro substitution
becomes

::

    MAX_ALLOC_CPUS = 4-1

The default may be another macro invocation:

::

    MAX_ALLOC_CPUS = $(NUMCPUS:$(DETECTED_CPUS))-1

These default specifications are restricted such that a macro invocation
with a default can not be nested inside of another default. An
alternative way of stating this restriction is that there can only be
one colon character per line. The effect of nested defaults can be
achieved by placing the macro definitions on separate lines of the
configuration.

All entries in a configuration file must have an operator, which will be
an equals sign (=). Identifiers are alphanumerics combined with the
underscore character, optionally with a subsystem name and a period as a
prefix. As a special case, a line without an operator that begins with a
left square bracket will be ignored. The following two-line example
treats the first line as a comment, and correctly handles the second
line.

::

    [HTCondor Settings]
     my_classad = [ foo=bar ]

To simplify pool administration, any configuration variable name may be
prefixed by a subsystem (see the $(SUBSYSTEM) macro in
section \ `3.3.12 <#x31-1810003.3.12>`__ for the list of subsystems) and
the period (.) character. For configuration variables defined this way,
the value is applied to the specific subsystem. For example, the ports
that HTCondor may use can be restricted to a range using the HIGHPORT
and LOWPORT configuration variables.

::

      MASTER.LOWPORT   = 20000
       MASTER.HIGHPORT  = 20100

Note that all configuration variables may utilize this syntax, but
nonsense configuration variables may result. For example, it makes no
sense to define

::

      NEGOTIATOR.MASTER_UPDATE_INTERVAL = 60

since the *condor\_negotiator* daemon does not use the
MASTER\_UPDATE\_INTERVAL variable.

It makes little sense to do so, but HTCondor will configure correctly
with a definition such as

::

      MASTER.MASTER_UPDATE_INTERVAL = 60

The *condor\_master* uses this configuration variable, and the prefix of
MASTER. causes this configuration to be specific to the *condor\_master*
daemon.

As of HTCondor version 8.1.1, evaluation works in the expected manner
when combining the definition of a macro with use of a prefix that gives
the subsystem name and a period. Consider the example

::

      FILESPEC = A
       MASTER.FILESPEC = B

combined with a later definition that incorporates FILESPEC in a macro:

::

      USEFILE = mydir/$(FILESPEC)

When the *condor\_master* evaluates variable USEFILE, it evaluates to
mydir/B. Previous to HTCondor version 8.1.1, it evaluated to mydir/A.
When any other subsystem evaluates variable USEFILE, it evaluates to
mydir/A.

This syntax has been further expanded to allow for the specification of
a local name on the command line using the command line option

::

      -local-name <local-name>

This allows multiple instances of a daemon to be run by the same
*condor\_master* daemon, each instance with its own local configuration
variable.

The ordering used to look up a variable, called <parameter name>:

#. <subsystem name>.<local name>.<parameter name>
#. <local name>.<parameter name>
#. <subsystem name>.<parameter name>
#. <parameter name>

If this local name is not specified on the command line, numbers 1 and 2
are skipped. As soon as the first match is found, the search is
completed, and the corresponding value is used.

This example configures a *condor\_master* to run 2 *condor\_schedd*
daemons. The *condor\_master* daemon needs the configuration:

::

      XYZZY           = $(SCHEDD)
       XYZZY_ARGS      = -local-name xyzzy
       DAEMON_LIST     = $(DAEMON_LIST) XYZZY
       DC_DAEMON_LIST  = + XYZZY
       XYZZY_LOG       = $(LOG)/SchedLog.xyzzy

Using this example configuration, the *condor\_master* starts up a
second *condor\_schedd* daemon, where this second *condor\_schedd*
daemon is passed **-local-name **\ *xyzzy* on the command line.

Continuing the example, configure the *condor\_schedd* daemon named
xyzzy. This *condor\_schedd* daemon will share all configuration
variable definitions with the other *condor\_schedd* daemon, except for
those specified separately.

::

      SCHEDD.XYZZY.SCHEDD_NAME = XYZZY
       SCHEDD.XYZZY.SCHEDD_LOG  = $(XYZZY_LOG)
       SCHEDD.XYZZY.SPOOL       = $(SPOOL).XYZZY

Note that the example SCHEDD\_NAME and SPOOL are specific to the
*condor\_schedd* daemon, as opposed to a different daemon such as the
*condor\_startd*. Other HTCondor daemons using this feature will have
different requirements for which parameters need to be specified
individually. This example works for the *condor\_schedd*, and more
local configuration can, and likely would be specified.

Also note that each daemon’s log file must be specified individually,
and in two places: one specification is for use by the *condor\_master*,
and the other is for use by the daemon itself. In the example, the XYZZY
*condor\_schedd* configuration variable SCHEDD.XYZZY.SCHEDD\_LOG
definition references the *condor\_master* daemon’s XYZZY\_LOG.

Comments and Line Continuations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An HTCondor configuration file may contain comments and line
continuations. A comment is any line beginning with a pound character
(#). A continuation is any entry that continues across multiples lines.
Line continuation is accomplished by placing the backslash character (/)
at the end of any line to be continued onto another. Valid examples of
line continuation are

::

      START = (KeyboardIdle > 15 * $(MINUTE)) && \
       ((LoadAvg - CondorLoadAvg) <= 0.3)

and

::

      ADMIN_MACHINES = condor.cs.wisc.edu, raven.cs.wisc.edu, \
       stork.cs.wisc.edu, ostrich.cs.wisc.edu, \
       bigbird.cs.wisc.edu
       HOSTALLOW_ADMINISTRATOR = $(ADMIN_MACHINES)

Where a line continuation character directly precedes a comment, the
entire comment line is ignored, and the following line is used in the
continuation. Line continuation characters within comments are ignored.

Both this example

::

      A = $(B) \
       # $(C)
       $(D)

and this example

::

      A = $(B) \
       # $(C) \
       $(D)

result in the same value for A:

::

      A = $(B) $(D)

Multi-Line Values
^^^^^^^^^^^^^^^^^

As of version 8.5.6, the value for a macro can comprise multiple lines
of text. The syntax for this is as follows:

::

    <macro_name> @=<tag>
     <macro_definition lines>
     @<tag>

For example:

::

    JOB_ROUTER_DEFAULTS @=jrd
       [
         requirements=target.WantJobRouter is True;
         MaxIdleJobs = 10;
         MaxJobs = 200;
     
         /* now modify routed job attributes */
         /* remove routed job if it goes on hold or stays idle for over 6 hours */
         set_PeriodicRemove = JobStatus == 5 ||
                             (JobStatus == 1 && (time() - QDate) > 3600*6);
         delete_WantJobRouter = true;
         set_requirements = true;
       ]
       @jrd

Note that in this example, the square brackets are part of the
JOB\_ROUTER\_DEFAULTS value.

Executing a Program to Produce Configuration Macros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of reading from a file, HTCondor can run a program to obtain
configuration macros. The vertical bar character (\|) as the last
character defining a file name provides the syntax necessary to tell
HTCondor to run a program. This syntax may only be used in the
definition of the CONDOR\_CONFIG environment variable, or the
LOCAL\_CONFIG\_FILE configuration variable.

The command line for the program is formed by the characters preceding
the vertical bar character. The standard output of the program is parsed
as a configuration file would be.

An example:

::

    LOCAL_CONFIG_FILE = /bin/make_the_config|

Program */bin/make\_the\_config* is executed, and its output is the set
of configuration macros.

Note that either a program is executed to generate the configuration
macros or the configuration is read from one or more files. The syntax
uses space characters to separate command line elements, if an executed
program produces the configuration macros. Space characters would
otherwise separate the list of files. This syntax does not permit
distinguishing one from the other, so only one may be specified.

(Note that the include command syntax (see below) is now the preferred
way to execute a program to generate configuration macros.)

Including Configuration from Elsewhere
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Externally defined configuration can be incorporated using the following
syntax:

::

      include [ifexist] : <file>
       include : <cmdline>|
       include [ifexist] command [into <cache-file>] : <cmdline>

(Note that the ifexist and into options were added in version 8.5.7.
Also note that the command option must be specified in order to use the
into option – just using the bar after <cmdline> will not work.)

In the file form of the include command, the <file> specification must
describe a single file, the contents of which will be parsed and
incorporated into the configuration. Unless the ifexist option is
specified, the non-existence of the file is a fatal error.

In the command line form of the include command (specified with either
the command option or by appending a bar (\|) character after the
<cmdline> specification), the <cmdline> specification must describe a
command line (program and arguments); the command line will be executed,
and the output will be parsed and incorporated into the configuration.

If the into option is not used, the command line will be executed every
time the configuration file is referenced. This may well be undesirable,
and can be avoided by using the into option. The into keyword must be
followed by the full pathname of a file into which to write the output
of the command line. If that file exists, it will be read and the
command line will not be executed. If that file does not exist, the
output of the command line will be written into it and then the cache
file will be read and incorporated into the configuration. If the
command line produces no output, a zero length file will be created. If
the command line returns a non-zero exit code, configuration will abort
and the cache file will not be created unless the ifexist keyword is
also specified.

The include key word is case insensitive. There are no requirements for
white space characters surrounding the colon character.

Consider the example

::

      FILE = config.$(FULL_HOSTNAME)
       include : $(LOCAL_DIR)/$(FILE)

Values are acquired for configuration variables FILE, and LOCAL\_DIR by
immediate evaluation, causing variable FULL\_HOSTNAME to also be
immediately evaluated. The resulting value forms a full path and file
name. This file is read and parsed. The resulting configuration is
incorporated into the current configuration. This resulting
configuration may contain further nested include specifications, which
are also parsed, evaluated, and incorporated. Levels of nested includes
are limited, such that infinite nesting is discovered and thwarted,
while still permitting nesting.

Consider the further example

::

      SCRIPT_FILE = script.$(IP_ADDRESS)
       include : $(RELEASE_DIR)/$(SCRIPT_FILE) |

In this example, the bar character at the end of the line causes a
script to be invoked, and the output of the script is incorporated into
the current configuration. The same immediate parsing and evaluation
occurs in this case as when a file’s contents are included.

For pools that are transitioning to using this new syntax in
configuration, while still having some tools and daemons with HTCondor
versions earlier than 8.1.6, special syntax in the configuration will
cause those daemons to fail upon startup, rather than continuing, but
incorrectly parsing the new syntax. Newer daemons will ignore the extra
syntax. Placing the @ character before the include key word causes the
older daemons to fail when they attempt to parse this syntax.

Here is the same example, but with the syntax that causes older daemons
to fail when reading it.

::

      FILE = config.$(FULL_HOSTNAME)
       @include : $(LOCAL_DIR)/$(FILE)

A daemon older than version 8.1.6 will fail to start. Running an older
*condor\_config\_val* identifies the @include line as being bad. A
daemon of HTCondor version 8.1.6 or more recent sees:

::

      FILE = config.$(FULL_HOSTNAME)
       include : $(LOCAL_DIR)/$(FILE)

and starts up successfully.

Here is an example using the new ifexist and into options:

::

      # stuff.pl writes "STUFF=1" to stdout
       include ifexist command into $(LOCAL_DIR)/stuff.config : perl $(LOCAL_DIR)/stuff.pl

Reporting Errors and Warnings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As of version 8.5.7, warning and error messages can be included in
HTCondor configuration files.

The syntax for warning and error messages is as follows:

::

      warning : <warning message>
       error : <error message>

The warning and error messages will be printed when the configuration
file is used (when almost any HTCondor command is run, for example).
Error messages (unlike warnings) will prevent the successful use of the
configuration file. This will, for example, prevent a daemon from
starting, and prevent *condor\_config\_val* from returning a value.

Here’s an example of using an error message in a configuration file
(combined with some of the new include features documented above):

::

    # stuff.pl writes "STUFF=1" to stdout
     include command into $(LOCAL_DIR)/stuff.config : perl $(LOCAL_DIR)/stuff.pl
     if ! defined stuff
       error : stuff is needed!
     endif

Conditionals in Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conditional if/else semantics are available in a limited form. The
syntax:

::

      if <simple condition>
          <statement>
          . . .
          <statement>
       else
          <statement>
          . . .
          <statement>
       endif

An else key word and statements are not required, such that simple if
semantics are implemented. The <simple condition> does not permit
compound conditions. It optionally contains the exclamation point
character (!) to represent the not operation, followed by

-  the defined keyword followed by the name of a variable. If the
   variable is defined, the statement(s) are incorporated into the
   expanded input. If the variable is not defined, the statement(s) are
   not incorporated into the expanded input. As an example,

   ::

         if defined MY_UNDEFINED_VARIABLE
             X = 12
          else
             X = -1
          endif

   results in X = -1, when MY\_UNDEFINED\_VARIABLE is not yet defined.

-  the version keyword, representing the version number of of the daemon
   or tool currently reading this conditional. This keyword is followed
   by an HTCondor version number. That version number can be of the form
   x.y.z or x.y. The version of the daemon or tool is compared to the
   specified version number. The comparison operators are

   -  == for equality. Current version 8.2.3 is equal to 8.2.
   -  >= to see if the current version number is greater than or equal
      to. Current version 8.2.3 is greater than 8.2.2, and current
      version 8.2.3 is greater than or equal to 8.2.
   -  <= to see if the current version number is less than or equal to.
      Current version 8.2.0 is less than 8.2.2, and current version
      8.2.3 is less than or equal to 8.2.

   As an example,

   ::

         if version >= 8.1.6
             DO_X = True
          else
             DO_Y = True
          endif

   results in defining DO\_X as True if the current version of the
   daemon or tool reading this if statement is 8.1.6 or a more recent
   version.

-  True or yes or the value 1. The statement(s) are incorporated.
-  False or no or the value 0 The statement(s) are not incorporated.
-  $(<variable>) may be used where the immediately evaluated value is a
   simple boolean value. A value that evaluates to the empty string is
   considered False, otherwise a value that does not evaluate to a
   simple boolean value is a syntax error.

The syntax

::

      if <simple condition>
          <statement>
          . . .
          <statement>
       elif <simple condition>
          <statement>
          . . .
          <statement>
       endif

is the same as syntax

::

      if <simple condition>
          <statement>
          . . .
          <statement>
       else
          if <simple condition>
             <statement>
             . . .
             <statement>
          endif
       endif

Function Macros in Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A set of predefined functions increase flexibility. Both submit
description files and configuration files are read using the same
parser, so these functions may be used in both submit description files
and configuration files.

Case is significant in the function’s name, so use the same letter case
as given in these definitions.

 $CHOICE(index, listname) or $CHOICE(index, item1, item2, …)
    An item within the list is returned. The list is represented by a
    parameter name, or the list items are the parameters. The index
    parameter determines which item. The first item in the list is at
    index 0. If the index is out of bounds for the list contents, an
    error occurs.
 $ENV(environment-variable-name[:default-value])
    Evaluates to the value of environment variable
    environment-variable-name. If there is no environment variable with
    that name, Evaluates to UNDEFINED unless the optional :default-value
    is used; in which case it evaluates to default-value. For example,

    ::

          A = $ENV(HOME)

    binds A to the value of the HOME environment variable.

 $F[fpduwnxbqa](filename)
    One or more of the lower case letters may be combined to form the
    function name and thus, its functionality. Each letter operates on
    the filename in its own way.

    -  f convert relative path to full path by prefixing the current
       working directory to it. This option works only in
       *condor\_submit* files.
    -  p refers to the entire directory portion of filename, with a
       trailing slash or backslash character. Whether a slash or
       backslash is used depends on the platform of the machine. The
       slash will be recognized on Linux platforms; either a slash or
       backslash will be recognized on Windows platforms, and the parser
       will use the same character specified.
    -  d refers to the last portion of the directory within the path, if
       specified. It will have a trailing slash or backslash, as
       appropriate to the platform of the machine. The slash will be
       recognized on Linux platforms; either a slash or backslash will
       be recognized on Windows platforms, and the parser will use the
       same character specified unless u or w is used. if b is used the
       trailing slash or backslash will be omitted.
    -  u convert path separators to Unix style slash characters
    -  w convert path separators to Windows style backslash characters
    -  n refers to the file name at the end of any path, but without any
       file name extension. As an example, the return value from
       $Fn(/tmp/simulate.exe) will be simulate (without the .exe
       extension).
    -  x refers to a file name extension, with the associated period
       (.). As an example, the return value from $Fn(/tmp/simulate.exe)
       will be .exe.
    -  b when combined with the d option, causes the trailing slash or
       backslash to be omitted. When combined with the x option, causes
       the leading period (.) to be omitted.
    -  q causes the return value to be enclosed within quotes. Double
       quote marks are used unless a is also specified.
    -  a When combined with the q option, causes the return value to be
       enclosed within single quotes.

 $DIRNAME(filename) is the same as $Fp(filename)
 $BASENAME(filename) is the same as $Fnx(filename)
 $INT(item-to-convert) or $INT(item-to-convert, format-specifier)
    Expands, evaluates, and returns a string version of item-to-convert.
    The format-specifier has the same syntax as a C language or Perl
    format specifier. If no format-specifier is specified, "%d" is used
    as the format specifier.
 $RANDOM\_CHOICE(choice1, choice2, choice3, …)
    A random choice of one of the parameters in the list of parameters
    is made. For example, if one of the integers 0-8 (inclusive) should
    be randomly chosen:

    ::

          $RANDOM_CHOICE(0,1,2,3,4,5,6,7,8)

 $RANDOM\_INTEGER(min, max [, step])
    A random integer within the range min and max, inclusive, is
    selected. The optional step parameter controls the stride within the
    range, and it defaults to the value 1. For example, to randomly
    chose an even integer in the range 0-8 (inclusive):

    ::

          $RANDOM_INTEGER(0, 8, 2)

 $REAL(item-to-convert) or $REAL(item-to-convert, format-specifier)
    Expands, evaluates, and returns a string version of item-to-convert
    for a floating point type. The format-specifier is a C language or
    Perl format specifier. If no format-specifier is specified, "%16G"
    is used as a format specifier.
 $SUBSTR(name, start-index) or $SUBSTR(name, start-index, length)
    Expands name and returns a substring of it. The first character of
    the string is at index 0. The first character of the substring is at
    index start-index. If the optional length is not specified, then the
    substring includes characters up to the end of the string. A
    negative value of start-index works back from the end of the string.
    A negative value of length eliminates use of characters from the end
    of the string. Here are some examples that all assume

    ::

          Name = abcdef

    -  $SUBSTR(Name, 2) is cdef.
    -  $SUBSTR(Name, 0, -2) is abcd.
    -  $SUBSTR(Name, 1, 3) is bcd.
    -  $SUBSTR(Name, -1) is f.
    -  $SUBSTR(Name, 4, -3) is the empty string, as there are no
       characters in the substring for this request.

Environment references are not currently used in standard HTCondor
configurations. However, they can sometimes be useful in custom
configurations.

Macros That Will Require a Restart When Changed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When any of the following listed configuration variables are changed,
HTCondor must be restarted. Reconfiguration using *condor\_reconfig*
will not be enough.

-  BIND\_ALL\_INTERFACES
-  FetchWorkDelay
-  MAX\_NUM\_CPUS
-  MAX\_TRACKING\_GID
-  MEMORY
-  MIN\_TRACKING\_GID
-  NETWORK\_HOSTNAME
-  NETWORK\_INTERFACE
-  NUM\_CPUS
-  PREEMPTION\_REQUIREMENTS\_STABLE
-  PRIVSEP\_ENABLED
-  PROCD\_ADDRESS
-  SLOT\_TYPE\_<N>
-  OFFLINE\_MACHINE\_RESOURCE\_<name>

Pre-Defined Macros
^^^^^^^^^^^^^^^^^^

HTCondor provides pre-defined macros that help configure HTCondor.
Pre-defined macros are listed as $(macro\_name).

This first set are entries whose values are determined at run time and
cannot be overwritten. These are inserted automatically by the library
routine which parses the configuration files. This implies that a change
to the underlying value of any of these variables will require a full
restart of HTCondor in order to use the changed value.

 $(FULL\_HOSTNAME)
    The fully qualified host name of the local machine, which is host
    name plus domain name.
 $(HOSTNAME)
    The host name of the local machine, without a domain name.
 $(IP\_ADDRESS)
    The ASCII string version of the local machine’s “most public” IP
    address. This address may be IPv4 or IPv6, but the macro will always
    be set.

    HTCondor selects the “most public” address heuristically. Your
    configuration should not depend on HTCondor picking any particular
    IP address for this macro; this macro’s value may not even be one of
    the IP addresses HTCondor is configured to advertise.

    labelparam:IPv4Address

 $(IPV4\_ADDRESS)
    The ASCII string version of the local machine’s “most public” IPv4
    address; unset if the local machine has no IPv4 address.

    See IP\_ADDRESS about “most public”.

 $(IPV6\_ADDRESS)
    The ASCII string version of the local machine’s “most public” IPv6
    address; unset if the local machine has no IPv6 address.

    See IP\_ADDRESS about “most public”.

 $(IP\_ADDRESS\_IS\_V6)
    A boolean which is true if and only if IP\_ADDRESS is an IPv6
    address. Useful for conditonal configuration.
 $(TILDE)
    The full path to the home directory of the Unix user condor, if such
    a user exists on the local machine.
 $(SUBSYSTEM)
    The subsystem name of the daemon or tool that is evaluating the
    macro. This is a unique string which identifies a given daemon
    within the HTCondor system. The possible subsystem names are:

    -  C\_GAHP
    -  C\_GAHP\_WORKER\_THREAD
    -  CKPT\_SERVER
    -  COLLECTOR
    -  DBMSD
    -  DEFRAG
    -  EC2\_GAHP
    -  GANGLIAD
    -  GCE\_GAHP
    -  GRIDMANAGER
    -  HAD
    -  JOB\_ROUTER
    -  KBDD
    -  LEASEMANAGER
    -  MASTER
    -  NEGOTIATOR
    -  REPLICATION
    -  ROOSTER
    -  SCHEDD
    -  SHADOW
    -  SHARED\_PORT
    -  STARTD
    -  STARTER
    -  SUBMIT
    -  TOOL
    -  TRANSFERER

 $(DETECTED\_CPUS)
    The integer number of hyper-threaded CPUs, as given by
    $(DETECTED\_CORES), when COUNT\_HYPERTHREAD\_CPUS is True. The
    integer number of physical (non hyper-threaded) CPUs, as given by
    $(DETECTED\_PHYSICAL\_CPUS), when COUNT\_HYPERTHREAD\_CPUS is False.
    When COUNT\_HYPERTHREAD\_CPUS is True.
 $(DETECTED\_PHYSICAL\_CPUS)
    The integer number of physical (non hyper-threaded) CPUs. This will
    be equal the number of unique CPU IDs.

This second set of macros are entries whose default values are
determined automatically at run time but which can be overwritten.

 $(ARCH)
    Defines the string used to identify the architecture of the local
    machine to HTCondor. The *condor\_startd* will advertise itself with
    this attribute so that users can submit binaries compiled for a
    given platform and force them to run on the correct machines.
    *condor\_submit* will append a requirement to the job ClassAd that
    it must run on the same ARCH and OPSYS of the machine where it was
    submitted, unless the user specifies ARCH and/or OPSYS explicitly in
    their submit file. See the *condor\_submit* manual page on
    page \ `2135 <Condorsubmit.html#x149-108000012>`__ for details.
 $(OPSYS)
    Defines the string used to identify the operating system of the
    local machine to HTCondor. If it is not defined in the configuration
    file, HTCondor will automatically insert the operating system of
    this machine as determined by *uname*.
 $(OPSYS\_VER)
    Defines the integer used to identify the operating system version
    number.
 $(OPSYS\_AND\_VER)
    Defines the string used prior to HTCondor version 7.7.2 as $(OPSYS).
 $(UNAME\_ARCH)
    The architecture as reported by *uname*\ (2)’s machine field. Always
    the same as ARCH on Windows.
 $(UNAME\_OPSYS)
    The operating system as reported by *uname*\ (2)’s sysname field.
    Always the same as OPSYS on Windows.
 $(DETECTED\_MEMORY)
    The amount of detected physical memory (RAM) in MiB.
 $(DETECTED\_CORES)
    The number of CPU cores that the operating system schedules. On
    machines that support hyper-threading, this will be the number of
    hyper-threads.
 $(PID)
    The process ID for the daemon or tool.
 $(PPID)
    The process ID of the parent process for the daemon or tool.
 $(USERNAME)
    The user name of the UID of the daemon or tool. For daemons started
    as root, but running under another UID (typically the user condor),
    this will be the other UID.
 $(FILESYSTEM\_DOMAIN)
    Defaults to the fully qualified host name of the machine it is
    evaluated on. See
    section \ `3.5.5 <ConfigurationMacros.html#x33-1920003.5.5>`__,
    Shared File System Configuration File Entries for the full
    description of its use and under what conditions it could be
    desirable to change it.
 $(UID\_DOMAIN)
    Defaults to the fully qualified host name of the machine it is
    evaluated on. See
    section \ `3.5.5 <ConfigurationMacros.html#x33-1920003.5.5>`__ for
    the full description of this configuration variable.

Since $(ARCH) and $(OPSYS) will automatically be set to the correct
values, we recommend that you do not overwrite them.

      
