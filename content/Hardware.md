# Computer Architecture

## Numbers and Measurements
* The _absolut_ speedup over the best sequential competitor is what counts, not the arbitrary _relative_ speedup.
* Watch out for sequential portions of the code. They may heavily limit the overall speedup, as can be shown by Amdahl's Law: $T(n) = T(1) \frac{1-a}{n} + a T(1)$ with $a$ being the fraction non-parallelized portion of the code. For $n \rightarrow \inf$ observe that the speedup is bound by $S(n) = \frac{1}{a}$.


## Layers of Parallelization
Often one has to deal with more than one layer of parallelization. The common ones:

* Interconnection of Computers (distributed systems such as clusters or grids): Parallelization of mostly independent tasks.
* Processor Coupling (Message Passing, Shared Memory, Distributed Shared Memory): Explicit communication between and synchronization of tasks.
* Processor Architecture (Pipeling, Superscalar, Multi/Hyperthreading): Parallelization of a sequential instruction stream  (via redestribution & overlapping, e.g., dynamic out of order execution by a superscalar unit) or overlapping of different instruction streams (e.g., IOs triggered by cache-faults of one thread, overlapped with the computations of another thread via hyperthreading) .
* SIMD: Instructions broken up into sub-instructions that can be executed in parallel (on different data elements).


## Random Tips
* If the compiler is bad, consider loop unrolling / software pipelining to expose the concurrent instructions to the CPU so that they can be executed in parallel.
* For simplificiation, just assume that the branch-predictor will predict the branch that was taken _the last time_. When designing algorithms, try to void hard-to-predict branches (e.g., the comparison-if in a simple _quicksort_). If possible, convert these convert these control-dependencies to data-dependencies. Using predicated instructions these are then easier/faster to execute because there is no need to flush the pipeline. Examples:
    - [Super Scalar Sample Sort] with the algorithmic insight that element comparisons can be decoupled from expensive conditional branching.
* Prevent _false-sharing_ (i.e., several threads operate on different data elements that happen to reside within the same cache-line). Otherwise, the cache coherence protocol (e.g., MESI, MOESI) will make your CPUs a hard time by constantly invalidating the shared cache-line upon write operations.
* Your language probably has a _weak consistency_ assumption. Without proper synchronisation there is no way to predict when or in which order threads will see values written by other threads. Different threads will therefore probably see _different values_. Use the built-in synchronization primitives to prevent this problem.

[Super Scalar Sample Sort]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.72.366&rep=rep1&type=pdf
    (A fast variant of Sample Sort for super scalar architectures)
