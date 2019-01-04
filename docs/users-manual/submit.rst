Submitting a Job
================

A job is submitted for execution to HTCondor using the condor_submit command. condor_submit takes as an argument the name of a file called a submit description file. This file contains commands and keywords to direct the queuing of jobs. In the submit description file, HTCondor finds everything it needs to know about the job. Items such as the name of the executable to run, the initial working directory, and command-line arguments to the program all go into the submit description file. condor_submit creates a job ClassAd based upon the information, and HTCondor works toward running the job.

The contents of a submit file can save time for HTCondor users. It is easy to submit multiple runs of a program to HTCondor. To run the same program 500 times on 500 different input data sets, arrange your data files accordingly so that each run reads its own input, and each run writes its own output. Each individual run may have its own initial working directory, stdin, stdout, stderr, command-line arguments, and shell environment. A program that directly opens its own files will read the file names to use either from stdin or from the command line. A program that opens a static filename every time will need to use a separate subdirectory for the output of each run.

Sample submit description files
-------------------------------

In addition to the examples of submit description files given in the condor_submit manual page, here are a few more.

Example 1
^^^^^^^^^

Example 1 is one of the simplest submit description files possible. It queues up one copy of the program foo (which had been created by condor_compile) for execution by HTCondor. Since no platform is specified, HTCondor will use its default, which is to run the job on a machine which has the same architecture and operating system as the machine from which it was submitted. No input, output, and error commands are given in the submit description file, so the files stdin, stdout, and stderr will all refer to /dev/null. The program may produce output by explicitly opening a file and writing to it. A log file, foo.log, will also be produced that contains events the job had during its lifetime inside of HTCondor. When the job finishes, its exit conditions will be noted in the log file. It is recommended that you always have a log file so you know what happened to your jobs. ::

   ####################                                                    
   # 
   # Example 1                                                            
   # Simple condor job description file                                    
   #                                                                       
   ####################                                                    
                                                                          
   Executable   = foo                                                    
   Universe     = standard                                                    
   Log          = foo.log                                                    
   Queue

Example 2
^^^^^^^^^

Example 2 queues two copies of the program mathematica. The first copy will run in directory run_1, and the second will run in directory run_2. For both queued copies, stdin will be test.data, stdout will be loop.out, and stderr will be loop.error. There will be two sets of files written, as the files are each written to their own directories. This is a convenient way to organize data if you have a large group of HTCondor jobs to run. The example file shows program submission of mathematica as a vanilla universe job. This may be necessary if the source and/or object code to mathematica is not available.

The request_memory command is included to insure that the mathematica jobs match with and then execute on pool machines that provide at least 1 GByte of memory. ::

   ####################     
   #                       
   # Example 2: demonstrate use of multiple     
   # directories for data organization.      
   #                                        
   ####################                    
                                         
   executable     = mathematica          
   universe       = vanilla                   
   input          = test.data                
   output         = loop.out                
   error          = loop.error             
   log            = loop.log                                                    
   request_memory = 1 GB
                                  
   initialdir     = run_1         
   queue                         
                               
   initialdir     = run_2      
   queue