# Computer Architecture

## Layers of Parallelization

Often one has to deal with more than one layer of parallelization. The common ones:

* Interconnection of computers

    - Idea: Parallelization of mostly independent tasks.
    - Technology: distributed systems such as clusters or grids

* Processor Coupling

    - Idea: Explicit communication between and synchronization of tasks.
    - Technology: Message Passing, Shared Memory, Distributed Shared Memory

* Processor Architecture

    - Idea: Parallelization of a sequential instruction stream or overlapping of different instruction streams.
    - Technology: Pipeling, Superscalar (out of order execution), Multi/Hyperthreading (e.g., IOs triggered by cache-faults of one thread, overlapped with the computations of another thread)

* SIMD:

    - Idea: Instructions broken up into sub-instructions that can be executed in parallel (on different data elements).


## Random Tips

* Prevent _false-sharing_ (i.e., several threads operate on different data elements that happen to reside within the same cache-line). Otherwise, the cache coherence protocol (e.g., MESI, MOESI) will make your CPUs a hard time by constantly invalidating the shared cache-line upon write operations.
* Your programming language probably has a _weak consistency_ assumption. Without proper synchronisation there is no way to predict when or in which order threads will see values written by other threads. Different threads will therefore probably see _different values_. Use the built-in synchronization primitives to prevent this problem.


