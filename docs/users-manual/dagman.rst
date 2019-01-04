DAGMan
======

A directed acyclic graph (DAG) can be used to represent a set of computations where the input, output, or execution of one or more computations is dependent on one or more other computations. The computations are nodes (vertices) in the graph, and the edges (arcs) identify the dependencies. HTCondor finds machines for the execution of programs, but it does not schedule programs based on dependencies. The Directed Acyclic Graph Manager (DAGMan) is a meta-scheduler for the execution of programs (computations). DAGMan submits the programs to HTCondor in an order represented by a DAG and processes the results. A DAG input file describes the DAG, and further submit description file(s) are used by DAGMan when submitting programs to run under HTCondor.

DAGMan is itself executed as a scheduler universe job within HTCondor. As DAGMan submits programs, it monitors log file(s) to enforce the ordering required within the DAG. DAGMan is also responsible for scheduling, recovery, and reporting on the set of programs submitted to HTCondor.

DAGMan Terminology
------------------

To DAGMan, a node in a DAG may encompass more than a single program submitted to run under HTCondor.

.. image:: /images/dagman-node.png

.. note:: At one time, the number of HTCondor jobs per node was restricted to one. This restriction is now relaxed such that all HTCondor jobs within a node must share a single cluster number. See the :doc:`/man-pages/condor_submit` manual page for a further definition of a cluster. A limitation exists such that all jobs within the single cluster must use the same log file. Separate nodes within a DAG may use different log files.

The DAG Input File: Basic Commands
----------------------------------

The input file used by DAGMan is called a DAG input file. It specifies the nodes of the DAG as well as the dependencies that order the DAG. All items are optional, except that there must be at least one JOB item.

Comments may be placed in the DAG input file. The pound character (#) as the first character on a line identifies the line as a comment. Comments do not span lines.

A simple diamond-shaped DAG, as shown in Figure 2.2 is presented as a starting point for examples. This DAG contains 4 nodes.

You can insert tickets links like :ticket:`1234` directly inline to paragraphs.