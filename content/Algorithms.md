# Algorithms

If in doubt, first think about the data structures and only then about the algorithms using them.


## Randomized Algorithms

* Use random numbers with care. Treat them as a scarce resource.

* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).

* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality, and ease of implementation (e.g., think of _bloom filters_ or _[Approximate Distance Oracles]_).

* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that have to be synchronized before and after a call of an operation with _expected_ runtime bounds. The runtime will suffer whenever at least one of the processes hits an expensive case. The same problems applies to algorithms with _amortized_ bounds.


## Cache-Efficient and External Memory Algorithms

* CPU cycles are [orders of magnitudes faster](https://gist.github.com/jboner/2841832) than memory accesses. The cost of a memory access depends on the level of the memory hierarchy serving the request.

* External algorithms are a way to exploit the [time-memory tradeoff](https://en.wikipedia.org/wiki/Space-time_tradeoff)

* As IO is expensive, internal memory becomes an important and scarce resource. It should always be used completely and efficiently. In many algorithms you can tell exactly how much internal memory you want to use. This is also useful in multi-user cluster environments.

* There is a trade-off with how much memory shall be used for buffering of accesses to lower levels of the memory hierarchy. The buffer block size is not a technology constant but a tradeoff of wasted space per empty buffered block and wasted space per block pointer. (TODO probably this statement is slightly wrong as it presents two different concepts as one...)

* Incorporate locality directly into the algorithm:

    - dismiss random access patterns in favor of scanning, streaming, and block-wise memory access
    - if scanning is not possible immediately, consider preprocessing (e.g. sorting)
    - use I/O efficient data structures (e.g. with buffers)
    - consider simulating a parallel algorithms. Those have been tuned for locality already

* Approaches:

    - _Recursive divide'n'conquer:_ For example a recursive binary heap construction is more cache efficient than the iterative one, as memory accesses are limited to a smaller region
    - _List neighborhood operations:_ Given a linked list we might want to perform an operation for each node with the predecessor and successor as input. Accessing the latter directly would result in random memory accesses. Instead: Duplicate the list two more times. Sort one by ID, one by predecessor ID, one by successor ID. Neighbors of node at position i are now in the other arrays at the same position i.  Neighborhood operations are now cache efficient and can be parallelized.


## Parallel Algorithms

* Don't confuse concurrency with parallelism. The former is about independent operations that could happen in any order, not just in parallel.

* Don't forget to first tune your sequential reference algorithm; probably this is already fast enough.

* Goal is to come up with a parallel algorithm that has an appropriate ratio of computation to communication time for the designated target architecture (e.g., more coarse grained for NORMA or NUMA systems than for SMP systems).

* The _absolut_ speedup over the best sequential competitor is what counts, not the arbitrary _relative_ speedup.

* Watch out for sequential portions of the code. They may heavily limit the overall speedup, as can be shown by Amdahl's Law: $T(n) = T(1) \frac{1-a}{n} + a T(1)$ with $a$ being the fraction non-parallelized portion of the code. For $n \rightarrow \inf$ observe that the speedup is bound by $S(n) = \frac{1}{a}$.


### Parallelization Toolbox

Most parallel algorithms are based on a set of recurring primitives:

* Sorting
* Collective communication:

    - broadcast
    - gather / scatter
    - all-to-all personalized communication
    - reduce using associative operations (+, max, min)
    - combinations such as all-reduce or all-gather (gossiping) where all participating PEs get the whole result
    - prefix-sum computations (scan)

* Selection and multisequence selection (e.g., a form of quickselect)

Besides the primitives there are several design approaches seen rather often:

* _Tree-shaped computations:_ Trees spanning the PEs to achive logarithmic communication paths and execution times (e.g., binary, binominal, fibonacci, ...)

* _Pipelining:_ It can help to distribute data more quickly, so that all PEs can start working earlier

* _Load balancing:_ Found at the core of many parallel algorithms. Some examples:

    - Prefix-sums / scan operations are commonly used to enumerate items on the different PEs. Knowing how many of these items exist in total and on each predecessor PE, the items can be distributed equally (e.g., used in a distributed quicksort)
    - Randomized work stealing used to evenly distribute (dynamic) work among PEs
    - Sample sort uses _sampling_ to find splitters that split up the data in (hopefully) equally sized chunks. Each PE is then responsible to sort one of these chunks.

* _Batching:_ Data structures designed to operate on multiple elements at a time (e.g insert whole set), instead of just a single one. Operations are performed by all PEs simultanously in a cooperative maner instead of just _concurrently_ (eventually protected by locks).

    - The Pareto Queue
    - Best-first Branch-and-bound with PE local priority queues

* _Recursion:_ A malleable approach adapting to the available parallelism. However, mind that we often want to expose much parallelism from the beginning (e.g., don't spawn threads for the multiple recursive calls within a recursive algorithms such as quicksort)

* _'Array-ification':_ Long paths (e.g., linked-lists, long paths within trees) are difficult to parallelize. Sorting the nodes of a path (e.g., via _list ranking_ based on _doubling_ or _independent set removal_) and storing them in an array, enables parallelization. Every PE can then operate on a particular index-range on the array.


### Parallelization Methodology

(based on [Designing Parallel Algorithms])

1. Start with the problem. Not with a particular algorithm.

    - For example, we were only able to parallelize the multi-criteria shortest path problem by abandoning the priority heap used in state-of-the-art algorithms and replacing it with a _Pareto Queue_. We sticked to the general idea of label setting without blindly immitating existing sequential algorithms.

2. Partition the problem. Expose as much potential parallelism as possible by finding _all_ concurrent tasks. Use _Domain_ Decomposition or _Functional_ Decomposition. You can even combine both techniques recursively.

    * __Functional Decomposition:__

        - Inspect the different computational steps. Group them to components that can operate in parallel. Finally, inspect the data required by the different components.
        - Functional decomposition yields modular program but which has often a limited scalability (i.e., the number of components is fixed and cannot increased easily)
        - Examples: A pipeline is a special kind of functional decomposition (offering high throughput even in case of high latency)

    * __Data Parallelism / Domain Decomposition:__

        - Partitioning of the data so that we can run computations simultanously in parallel on the different partitions. This applies to input, output and heavily used data structures.
        - As a guidline, start with a simple PRAM algorithms and take as many PEs as you want to and place them in an appropriate layout (e.g., hypercube, 3D-cube, 2D-grid). This allows you to learn about the problem and how it can be parallelized (e.g., organization and shapes suitable for data and PEs). Commonly, the next step is then to apply _Brent's Principle_ to make the algorithm more efficient by reducing the number of PEs. This can be done by decoupling the strict mapping of elements to PEs and assigning $\frac{n}{p}$ elements per PE for a now arbitrary $p$.
        - Commonly used and formulated using the _Single Program Multiple Data (SPMD)_ principle. The  PE index is then used to break the inherint symmetrie
        - Examples:
            + Often there is more than one obivous data partitioning. E.g., vs the cubed sub-matrix algorithm of Dekel Nassimi Sahni
        - Hints
            + Perform data composition via chunks of fixed size instead of composition on a fixed number of chunks, i.e., use the chunk size to account for the parallelization overhead.

3. Understand the communication paths and the required data flow between tasks.

4. Aim to reduce communication costs by merging some of the fine-grained tasks that have too many data-dependencies or by duplicating data or some of the computations whose results are required by many different tasks. Basically, in this phase you perform manual graph clustering.

5. Map the resulting tasks to the target architecture and its available PEs. Aim to reduce the overall execution time (i.e., maximizing processor utilization and minimizing communication costs) by allocating the tasks wisely. If required, add a (distributed) load-balancing mechanism.



## Random Bits'n'Pieces

* Part of quicksorts speed in pratice can be attributed to the fact that for random input, only about every other element is moved on each level in the recursion, whereas binary mergesort moves all elements on each level.

* Quicksort only guarantees that one element will be in its correct position after one round. This leads to its bad worstcase behaviour. Mergesort does ot suffer the same fate as it is always performing the favorible binary split.


[Approximate Distance Oracles]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.94.333
    (Approximate Distance Oracles)
[Fusion Trees]: http://stephanerb.eu/files/erb2011b_Fusion_Trees.pdf
    (KIT Lecture Notes on Advanced Data Structures: Fusion Trees)
[Signature Sort]: http://algo2.iti.kit.edu/download/ads_lec6.pdf
    (KIT Lecture Notes on Advanced Data Structures: Signature Sort)
[Super Scalar Sample Sort]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.72.366&rep=rep1&type=pdf
    (A fast variant of Sample Sort for super scalar architectures)
[External Memory Mergesort]: http://algo2.iti.kit.edu/dementiev/files/DS03.pdf
    (Asynchronous Parallel Disk Sorting)
[Designing Parallel Algorithms]: http://www-unix.mcs.anl.gov/dbpp/
    (Designing and Building Parallel Programs, Ian Foster)
