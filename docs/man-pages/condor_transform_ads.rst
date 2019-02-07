      

condor\_transform\_ads
======================

Transform ClassAds according to specified rules, and output the
transformed ClassAds.

Synopsis
--------

**condor\_transform\_ads** [**-help [rules]**\ ]

**condor\_transform\_ads** **-rules **\ *rules-file*
[**-in[:<form>]  **\ *infile*] [**-out[:<form>[,
nosort]]  **\ *outfile*] [*<key>=<value>*\ ] [**-long**\ ] [**-json**\ ]
[**-xml**\ ] [**-verbose**\ ] [**-terse**\ ] [**-debug**\ ]
[**-unit-test**\ ] [**-testing**\ ] [**-convertoldroutes**\ ] [*infile1
…infileN*\ ]

Note that exactly one rules file, and at least one input file, must be
specified. If no output file is specified, output will be written to
``stdout``.

Description
-----------

*condor\_transform\_ads* reads ClassAds from a set of input files,
transforms them according to rules defined in a rules file, and outputs
the resulting transformed ClassAds.

See
`https://htcondor-wiki.cs.wisc.edu/index.cgi/wiki?p=TjsAdTransformLanguage <https://htcondor-wiki.cs.wisc.edu/index.cgi/wiki?p=TjsAdTransformLanguage>`__
for a description of the transform language.

Options
-------

 **-help [rules]**
    Display usage information and exit. **-help rules** displays
    information about the available transformation rules.
 **-rules **\ *rules-file*
    Specifies the file containing definitions of the transformation
    rules.
 **-in[:<form>] **\ *infile*
    Specifies an input file containing ClassAd(s) to be transformed.
    **<form>**, if specified, is one of:

    -  **long**: traditional long form (default)
    -  **xml**: XML form
    -  **json**: JSON ClassAd form
    -  **new**: "new" ClassAd form without newlines
    -  **auto**: guess format by reading the input

    | If ``-`` is specified for *infile*, input is read from ``stdin``.

 **-out[:<form>[, nosort] **\ *outfile*
    Specifies an output file to receive the transformed ClassAd(s).
    **<form>**, if specified, is one of:

    -  **long**: traditional long form (default)
    -  **xml**: XML form
    -  **json**: JSON ClassAd form
    -  **new**: "new" ClassAd form without newlines
    -  **auto**: use the same format as the first input

    | ClassAds are storted by attribute unless **nosort** is specified.

 [*<key>=<value>*\ ]
    Assign key/value pairs before rules file is parsed; can be used to
    pass arguments to rules. (More detail needed here.)
 **-long**
    Use long form for both input and output ClassAd(s). (This is the
    default.)
 **-json**
    Use JSON form for both input and output ClassAd(s).
 **-xml**
    Use XML form for both input and output ClassAd(s).
 **-verbose**
    Verbose mode, echo transform rules as they are executed.
 **-terse**
    Disable the **-verbose** option.
 **-debug**
    More information needed here.
 **-unit-test**
    More information needed here.
 **-testing**
    More information needed here.
 **-convertoldroutes**
    More information needed here.

Exit Status
-----------

*condor\_transform\_ads* will exit with a status value of 0 (zero) upon
success, and it will exit with the value 1 (one) upon failure.

Examples
--------

Here’s a simple example that transforms the given input ClassAds
according to the given rules:

::

      # File: my_input 
      ResidentSetSize = 500 
      DiskUsage = 2500000 
      NumCkpts = 0 
      TransferrErr = false 
      Err = "/dev/null" 
     
      # File: my_rules 
      EVALSET MemoryUsage ( ResidentSetSize / 100 ) 
      EVALMACRO WantDisk = ( DiskUsage * 2 ) 
      SET RequestDisk ( $(WantDisk) / 1024 ) 
      RENAME NumCkpts NumCheckPoints 
      DELETE /(.+)Err/ 
     
      # Command: 
      condor_transform_ads -rules my_rules -in my_input 
     
      # Output: 
      DiskUsage = 2500000 
      Err = "/dev/null" 
      MemoryUsage = 5 
      NumCheckPoints = 0 
      RequestDisk = ( 5000000 / 1024 ) 
      ResidentSetSize = 500

Author
------

Center for High Throughput Computing, University of Wisconsin–Madison

Copyright
---------

Copyright © 1990-2019 Center for High Throughput Computing, Computer
Sciences Department, University of Wisconsin-Madison, Madison, WI. All
Rights Reserved. Licensed under the Apache License, Version 2.0.

      
