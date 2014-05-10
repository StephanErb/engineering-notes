# Computer Architecture


## Layers of Parallelization
Often one has to deal with more than one layer of parallelization. The common ones:

* Interconnection of Computers (distributed systems such as clusters or grids): Parallelization of mostly independent tasks.
* Processor Coupling (Message Passing, Shared Memory, Distributed Shared Memory): Explicit communication between and synchronization of tasks.
* Processor Architecture (Pipeling, Superscalar, Multi/Hyperthreading): Parallelization of a sequential instruction stream  (via redestribution & overlapping, e.g., dynamic out of order execution by a superscalar unit) or overlapping of different instruction streams (e.g., IOs triggered by cache-faults of one thread, overlapped with the computations of another thread via hyperthreading).
* SIMD: Instructions broken up into sub-instructions that can be executed in parallel (on different data elements).


## Random Tips

* Prevent _false-sharing_ (i.e., several threads operate on different data elements that happen to reside within the same cache-line). Otherwise, the cache coherence protocol (e.g., MESI, MOESI) will make your CPUs a hard time by constantly invalidating the shared cache-line upon write operations.
* Your language probably has a _weak consistency_ assumption. Without proper synchronisation there is no way to predict when or in which order threads will see values written by other threads. Different threads will therefore probably see _different values_. Use the built-in synchronization primitives to prevent this problem.


