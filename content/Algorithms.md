# Algorithm & Data Structures Design Toolbox

Its about finding the right data structure and accompaning algorithm for the job. Generally, this depends on the number of elements involved in the computation (e.g., _internal memory_ vs _external memory algorithms_, _van Emde Boas Trees_ vs _[Fusion Trees]_, ...).




## Algorithm Engineering

Performance depends on technological properties of machines like parallelism, data dependencies and memory hierarchies. These play a role even in lower order terms.

General approach:

1. Inspect all existing asymptotically optimal algorithms
2. Choose the the simplest one.
3. Implement your algorithm targeting a suitable machine model.
4. Start to optimize it. Be aware, these optimizations are meant to be driven by theory and not just bit-level tricks.

    - identify and eliminate computations which are not required in all cases (excessive work)
    - optimize memory access patterns
    - eliminate branch miss-predictions (e.g., see _[Quicksort Branch Misspredictions]_)
    - ...

5. Run your experiments on:

    - different architectures (e.g., current Intel, AMD, MIPS) to cover both CISC and RISC architectures
    - different types of inputs (e.g., uniformly distributed, skewed)
    - highly tuned competitors codes (i.e., how do you compare two medicore implementations?)

6. Repeat




## Data Structures

Good data structures reduce a big program to a smal program. Representation, and therefore data structures, is the essence for program writing. Let the data structure the program [Programming Pearls]

Many applications just rely on dynamic list structures, hashmaps and sorting. This is fine in most cases. However, here are some observations:

* _Orderness_ seems to be underutilized. Instead of storing elements without a particular order, consider keeping them sorted. This can help to [speed up operations][SICP on Sets] on them. So for example, instead of hashing and sorting, also consider an ordered associative array (e.g., Java's `SortedMap` or `NaviagableMap`).

* Integer keys seem to be underutilized. This also implies hashing is favored in cases where plain arrays or bit sets (e.g., Java's `BitSet`) would do just fine (and would even be faster and require less space). Therefore, consider enumerating the elements you are dealing with.

* Using the implementation of an abstract data type does not relieve from having a good mental model of its associate costs. For example, when using a resizable array implementation (e.g. Java's `ArrayList`):

    - Try to avoid inserts/deletes at all positions beside the end of the list as these require the array to be shifted.
    - When the number of elements that the list shall hold is (roughly) known but elements can only be inserted one by one, correctly initialize the list in order to avoid the numerous internal array copies.



### Trees and Tries

Trees can be constructed in $\mathcal{O}(n)$ if their elements are inserted in the order of their leafs. Starting from the last that has been inserted, one has to move up until the edge / node is found where the new node shall be added. As we only operate on the right-most path, the runtime follows by a simple amortized argument. Examples:

* Deriving _Suffix Trees_ from _Suffix_ & _LCP Arrays_
* Constructing _Cartesian Trees_ (heap-ordered binary trees for which a symmetric (in-order) traversal returns the original integer sequence)

A _trie_ is a special kind of edge labeled tree. If used over a collection of keys, it can be used to find the significant difference between these keys (i.e., the _important positions_ sufficient to distinguish all keys). Examples:

* _[Fusion Trees]_ compress keys within _B-Tree_ nodes by reducing them to the bits at the important bit positions required to distinguish the keys. All keys of a node can then be fused into a single machine word and compared to a query element in parallel using a single bitparallel subtraction.
* _[String B-Trees]_ use _Patricia Tries_ (aka _radix tries_ or _compact prefix_ trees) to identify the subset of characters relevant for the comparison of a string pattern to the keys of a _B-Tree_. Knowing these characters and the lengths of the common prefixes of keys, the number of required I/Os per traversal can be limited.
* _[Signature Sort]_ splits keys into chunks and compresses these chunks using a hash function. A trie is then used to filter the chunks that are not relevant for the sort order of the keys. The keys therefore become smaller and sorting them becomes easier.



### Suffix Arrays and Suffix Trees

Suffix trees are very powerful, i.e., the _repeat problem_ (the pattern mining problem to find all maximal strings that are repeated more than once within the document) can be solved very easily on suffix trees.

The longer the LCP (longest common prefix) of two suffixes, the closer those are placed to each other within the suffix array. This grouping / locality information is used in various ways. Examples:

* during pattern matching
* finding the longest previous substring for computing the LZ77 factorization. Only inspect the suffix in close proximity that stand refer to a previous text position --> previous and next smaller values.



### Succinct Data Structures

Succinct Data Structures are space efficient implementations of abstract data types (e.g., trees, bit sets) that still allow for efficient queries without having to unpack/decompress the data structure first. Everything is accessed in-place, by reading bits at various positions in the data. To achieve optimal encoding, we use bits instead of bytes. All of our structures are encoded as a series of 0's and 1's.

Common / usefull operations:
* __rank__ large universe with gaps -> small universe (think of perfect hashing for integers)
* __select__

A common implementation technique is to split the data structure / problem into blocks:

* on the first block level, the blocks are few enough so that we can spend many bits for each pre-computed result per block
* on the second block level which splits existing blocks into sub-blocks, there are many blocks but the results are stored relatively to the surrounding blocks and therefore require fewer bits.
* if required, sub-blocks can be splitted even further. They may then be small enough for their results to fit into a full lookup-table.



### List of other nice Data Structures

* _Union-find Data structure:_ Commonly used to find cycles and connected components within graphs.
* _Wavelet Trees:_ TODO
* _Tournament Trees / Loser Trees_ for _k-way_-merging of large data sets (assuming a large _k_ such as 256)
* _2D Min Heaps:_ TODO
* _RMQ & LCA:_ TODO




## Recurring Design Ideas

There seem to be some simple ideas that have influenced the design of many algorithms and data structures. This list is not authoritative (in particular w.r.t. to naming), it just lists some observations. The ideas seem to be heavily connected and seldomly used in isolation.

* __Tradeoff:__ Inspect simple, naive solutions with contradicting space and runtime bounds (e.g, online computation vs. precomputation of all results) and try to find a tradeoff that achieves the best of both worlds. So for example, instead of precoumputing all results, precompute just a particular subset. Examples:

    - [Level Ancestor Queries][] (to find the tree-ancestor on a particular level) can be approached using _jump pointers_ and _ladder decomposition_, which both precompute a subset of all potential queries and run in $\mathcal{O}(\log n)$ time. However, a combination of both leads to constant query time and a linear space requirement, thus heavily improving over the computation of all results.

* __Combination:__ Combine several (different) data structures so that expensive operations of one data structure can be improved using a specialized data structure for this particular sub-problem. Examples:

    - _[String B-Trees]_ build _Patricia Tries_ on top of individual B-Tree nodes to improve over the binary search to find the insertion point within the keys of a node.
    - _[Priority Queues for Cached Memory]_ use a priority queue in internal memory that buffers elements so that the expensive write operations to the external memory can be performed in batches.

* __Indirection/Bucketing:__ Instead of working on a large problem set (with larger accompanying space & runtime bounds), first find a suitable bucket and then solve the problem only within this particular bucket. Examples:

    - _Perfect Hashing_ uses an indirection so that it is not required to find a perfect (injective) hash function for all elements, but only for the elements within the same collision bucket. This reduces the overall space requirement while retaining the expected construction and query time.
    - _Y-Fast Tries_ improve upon the space requirements of _X-Fast Tries_ by building the trie over representatives of buckets instead of over all elements. The buckets are implemented as balanced binary trees and do not just reduce the space requirement of _X-Fast Tries_ but also help to reduce update costs using amortization.
    - _Range Minimum Queries_ as implemented by [Fischer and Heun][Range Minimum Queries] use a data structure that normally requires $n \log n$ words but only insert a subset of elements so that they can reduce the space requirements to $\mathcal{O}(n)$.
    - _Succinct Data Structures_ can profit from indirection layers as they reduce the number of elements that have to be distinguished from the whole universe down to all elements within a bucket. Thus, to distinguish these elements fewer bits are required.

* __Decomposition:__ Instead of dealing with elements of objects as a whole, split them into logical subparts. Exploit this inner structure to achieve higher efficiency and eventually solve the problem within a richer model of computation (e.g., compare bits instead of whole integers). Examples:

    - _X-Fast Tries_ split integer keys into their common prefixes and use a binary search to find the longest common prefix.
    - _van Emde Boas Trees_ recursively split keys into a top and bottom halve in order to efficiently navigate within buckets and summaries over these buckets.
    - _[Level Ancestor Queries]_ can be implemented via the idea of recursively splitting a tree into its longests paths (_longest path decomposition_) and precomputing the results within these paths.

* __Input Reduction/Simplification:__ Reduce the problem set at hand until it is simple enough so that it can be solved using basic means (e.g., another algorithm). This idea is at the core of most recursive algorithms.

    - _Independet-Set Removal_ is used to speed up list ranking by removing elements form the list until the list is small enough to be ranked easily.
    - _Signature Sort_ recursively reduces the size of the keys until they can be sorted with _Packed Sorting_.
    - The _findclose_ operation on _Succinct Trees_ finds the position of a closing bracket within the bitstring representing the tree. The idea is to solve the problem for a corresponding, so-called pioneer and then deduce the actual closing position from the closing position of the corresponding pioneer.

* __Broadword Computing:__ Fuse data elements into machine words and run operation on then in parallel, instead of sequentially. You can get more done within fewer instructions and without having to hit memory.

    - _[Fusion Trees]_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.

* __N-Phase Computation:__ If something is complicated (and thus slow) to do in a single pass, feel free to use several phases. A multi pass approach can remove dependencies within subsequent iterations of a loop and therefore enable sotware piplining (overlapping loop iterations -> out of order execution). Examples:
    - _[Super Scalar Sample Sort]_ sorts in two phases. In the first pass it is only decides in which bucket an element shall be assigned to. The actual data movement into the preallocated subarrays is then performed in the second pass once the total bucket sizes are known.
    - Pipelined Prefix Sum (Paralag und Sanders Paper?)
    - All to all for irregular message sizes

* __K-Way approach:__ Instead of binary operations that are scattered over a deep recursion, perform a k-way operation. This limits the number of recursion levels and gives room for clever implementations of the (k-way) operation. Examples:

    - An [External Memory Mergesort] performs less IOs due to the limited recursion depth. Its k-way merge function can be implemented efficiently with help of _tournament trees_.
    - Samplesort generalizes over Quicksort by recursively sorting $K$ partitions. It can be parallelized more efficiently.

* __Batch Processing:__ Grouping individual operations to a batch of operations can have various advantages. To get think about elements to which the same things happens.

    - When latencies are an issue, batching can be used to amortize the latency over a number of buffered element. Examples:
        + _[Priority Queues for Cached Memory]_ use a priority queue in internal memory that buffers elements so that the expensive write operations to the external memory can be performed in batches
    - Pre-processing (such as sorting) of the buffered elements can sometimes be used to generate additional information speeding up the batch operation. Examples:
        + Constructing or update of a tree by inserting elements in sorted order, i.e., a form of _finger search_.
    - Processing elements in batches can allow us paralleize the operation, something which would not e feasible for individual elements.
        + The parallel _Pareto Search_ algorithms processes batch of lables instead of individual labels as in classic label setting algorithms. All its operations can be parallelized




## Common Low-Level Optimizations

A common rule is that the less instructions are issued, the faster runs an algorithm. Sophisticated checks for special cases are therefore not always worth it. Also mind that depending on the hardware and the algorithm either branches or memory access can be the limiting factor.

* __Tail Call Optimization:__  Given an algorithm with two recursive calls (e.g., quicksort), one call can be replaced with a while loop, by making the recursion-end the loop condition. To limit the recursion depth, the larger call should be handled in the while loop.

* __Sentinals:__  Sentinals are algorithm-specific elements added to the managed data in order to simplify and ensure that certain invariants hold. They are commonly used to limit comparisions for boundary cases. For example:

    - When implementing a linked list, we have to deal with the list beginning and list end as a special case. We can remove this special case by making the list circular and beginning/ending in a special sentinal element. We can now add an element after the last element or before the first element without any special checks for dangling pointers. The sentinal also helps with search: Just store the element you are looking for in the sentinal, you can now search the entire list for without having to check if the list end is reached. The list end if found naturally if the element is not in the list.

* __Hard to Predict Branches:__ It's the number of hard to predict branches that matters. Conditional branches within loops may be hard to predict, because the comparision produces valuable information and both branches may be both likely to be taken (e.g., quicksort pivot comparision). The branch predictor will fail often enough for the performance to suffer greatly. Mind that end-of-loop conditions are easy to predict, as a missprediction only happens when the loop is exited. Workarounds for hard to predict branches:

    - _[Super Scalar Sample Sort]_ mitigates the hard to predict conditional branches of _quicksort_ by using a _two phase computation_ approach where comparisions for neighboring elements are independet from each other. These comparisons can then be executed (in parallel) as _[predicated instructions](http://en.wikipedia.org/wiki/Branch_predication)_ which do not trigger branch miss predictions and expensive pipeline flushes.
    - _Translate control to data dependencies_ to mitigate the need for branches: `cmp` operations (or the equivilant substractions) return 0 and 1. Instead as a branch condition these can be used with index computations of _[implicit data structures](http://en.wikipedia.org/wiki/Implicit_data_structure)_. For example, this works in _binary heaps_ embedded into arrays and in the implicit search tree of _[Super Scalar Sample Sort]_.

* __Data-dependencies:__ Try to limit or defer unneeded data dependencies by following a (two-pass approach)[#recurring-esign-ideas]. Less data-dependencies make it easier to fully exploit the super scalar instruction units of modern CPUs (e.g., see _[Super Scalar Sample Sort]_). Loop unrolling / software pipelining may then be used to expose the concurrent instructions to the CPU so that they can be executed in parallel.

* __Early Recursion End:__ If the data set is small then algorithms with better asymptotic behaviour but better constant factors can become faster (e.g., quicksort implementations fall back to insertion sort)

* __Required Register Count:__ The close the number of required registers is to the actual available register count the better. Mind that when setting tuning paramets (e.g., the _k_ in _[k-way algorithms](#recurring-design-ideas)_).





## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of _bloom filters_ or _[Approximate Distance Oracles]_).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that have to be synchronized before and after a call of an operation with _expected_ runtime bounds. The runtime will suffer whenever at least one of the processes hits an expensive case. The same problems applies to algorithms with _amortized_ bounds.





## Cache-Efficient and External Memory Algorithms

* CPU cycles are [orders of magnitudes faster](https://gist.github.com/jboner/2841832) than memory accesses. The cost of a memory access depends on the level of the memory hierarhcy serving the request.
* External algorithms are a way to exploit the [time-memory tradeoff](https://en.wikipedia.org/wiki/Space-time_tradeoff)
* As IO is expensive, the internal memory becomes an important and scarce resource. It should always be used completely and efficiently. In many algorithms you can tell exactly how much internal memory you want to use. This is also useful in multi-user cluster environments.
* There is a trade-off with how much memory shall be used for buffering of accesses to lower levels of the memory hierarchy. The buffer block size is not a technology constant but a tradeoff of wasted space per empty buffered block and wasted space per block pointer. (TODO probably this statement is slightly wrong as it presents two different concepts as one...)
* Incorporate locality directly into the algorithm:

    - access memory in a block-wise fashion
    - dismiss random access patterns in favor of scanning and streaming
    - TODO: 'Goldene Regeln' of the Algo Eng ZF.

* Approaches:

    - _Recursive divide'n'conquer:_ For example a recursive binary heap construction is more cache efficienz than the iterative one, as memory accesses are limited to a smaller region
    - _List neighborhood operations:_ Given a linked list we might want to perform an operation for each node with the predecessor and successor as input. Accessing the latter directly would result in random memory accesses. Instead: Duplicate the list two more times. Sort one by ID, one by predecessor ID, one by successor ID. Neighbors of node at position i are now in the other arrays at the same position i.  Neighborhood operations are now cache efficient and can be parallelized.





## Parallel Algorithms
Goal is to come up with a parallel algorithm that has an appropriate ratio of computation to communication time for the designated target architecture (e.g., more coarse grained for NORMA or NUMA systems than for SMP systems). Don't forget to first tune your sequential reference algorithm; probably it is already fast enough.

The _absolut_ speedup over the best sequential competitor is what counts, not the arbitrary _relative_ speedup.



### Parallele Maschinenmodelle

* PRAM: parallele Version des RAM/von Neumann Modell
* Distributed memory machine

Many computations can be represented as DAGs. Can easily be computed on PRAMs by computing layer _i_ in phase _i_. A computation on a distributed machine is possible just as well.



### Basic Toolbox

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
    - Prefix-sums / scan operations are commonly used to enumerate items on the different PEs. Knowing how many of these items exist in total and on each predecessor PE, the items can be distributed equally (e.g., distributed quicksort)
    - Randomized work stealing used to evenly distribute (dynamic) work among PEs
    - Sample sort uses _sampling_ to find splitters that split up the data in (hopefully) equally sized chunks. Each PE is then responsible to sort one of these chunks.
* _Batching:_ Data structures designed to operation on multiple elements at a time, instead of just a single one. Operations are performed by all PEs simultanously in a cooperative maner  instead of just _concurrently_ (eventually protected by locks).
    - The Pareto Queue
    - Best first Branch-and-bound with PE local priority queues
* _Recursion:_ A malleable approach adapting to the available parallelism. However, mind that we often want to expose much parallelism from the beginning (e.g., don't spawn threads for the multiple recursive calls within a recursive algorithms such as quicksort)
* _'Array-ification':_ Long paths (e.g., linked-lists, long paths within trees) are difficult to parallelize. Sorting the nodes of a path (e.g., via _list ranking_ based on _doubling_ and _independent set removal_) and storing them in an array, enables parallelization. Every PE can then operate on a particular index-range on the array.



### A rough roadmap

(based on [Designing Parallel Algorithms])

1. Start with the problem. Not with a particular algorithm.

    - For example, we were only able to parallelize the multi-criteria shortest path problem by abandoning the priority heap used in state-of-the-art algorithms and replacing it with a _Pareto Queue_. We sticked to the general idea of label setting without blindly immitating existing sequential algorithms.

2. Partition the problem. Expose as much parallelism as possible by finding _all_ concurrent tasks. Use _Domain_ Decomposition or _Functional_ Decomposition as described below. You can even combine both techniques recursively.
3. Understand the communication paths and the required data flow between tasks.
4. Aim to reduce communication costs by merging some of the fine-grained tasks that have too many data-dependencies or by duplicating data or some of the computations whose results are required by many different tasks. Basically, in this phase you perform manual of graph clustering.
5. Map the resulting tasks to the target architecture and its available PEs. Aim to reduce the overall execution time (i.e., maximizing processor utilization and minimizing communication costs) by allocating the tasks wisely. If required, add a (distributed) load-balancing mechanism.


* __Functional Decomposition:__

    - Inspect the different computational steps. Group them to components that can operate in parallel. Finally, inspect the data required by the different components.
    - Functional decomposition yields modular program but which has often a limited scalability (i.e., the number of components is fixed and cannot increased easily)
    - Examples: A pipeline is a special kind of functional decomposition.


* __Data Parallelism / Domain Decomposition:__

    - Partitioning of the data so that we can run computations simultanously in parallel on the different partitions. This applies to input, output and heavily used data structures.
    - As a guidline, start with a simple PRAM algorithms and take as many PEs as you want to and place them in an appropriate layout (e.g., hypercube, 3D-cube, 2D-grid). This allows you to learn about the problem and how it can be parallelized (e.g., organization and shapes suitable for data and PEs). Commonly, the next step is then to apply _Brent's Principle_ to make the algorithm more efficient by reducing the number of PEs. This can be done by decoupling the strict mapping of elements to PEs and assigning $\frac{n}{p}$ elements per PE for a now arbitrary $p$.
    - Examples:
        + Often there is more than one obivous data partitioning. E.g., vs the cubed sub-matrix algorithm of Dekel Nassimi Sahni
    - Commonly used and formulated using the _Single Program Multiple Data (SPMD)_ principle. The  PE index is then used to break the inherint symmetrie
    - Hints
        + Perform data composition via chunks of fixed size instead of composition on a fixed number of chunks, i.e., use the chunk size to account for the parallelization overhead.





## Useful Formulars

TODO. Formulars which are often required during algorithm analysis:

* Gaus
* Hn
* gemom. Reihe
* Stearling Approx
* log. Gesetze
* markov inequality
* Watch out for sequential portions of the code. They may heavily limit the overall speedup, as can be shown by Amdahl's Law: $T(n) = T(1) \frac{1-a}{n} + a T(1)$ with $a$ being the fraction non-parallelized portion of the code. For $n \rightarrow \inf$ observe that the speedup is bound by $S(n) = \frac{1}{a}$.





## Fun Facts
* Part of quicksorts speed can be attributed to the fact that for random input, only about every other element is moved on each level in the recursion, whereas binary mergesort moves all elements on each level.





[Level Ancestor Queries]: http://cg.scs.carleton.ca/~morin/teaching/5408/refs/bf-c04.pdf
    (The Level Ancestor Problem simplified)
[String B-Trees]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.57.5939
    (The String B-Tree: A New Data Structure for String Search in External Memory and its Applications. (1998))
[Approximate Distance Oracles]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.94.333
    (Approximate Distance Oracles)
[Fusion Trees]: http://stephanerb.eu/files/erb2011b_Fusion_Trees.pdf
    (KIT Lecture Notes on Advanced Data Structures: Fusion Trees)
[Signature Sort]: http://algo2.iti.kit.edu/download/ads_lec6.pdf
    (KIT Lecture Notes on Advanced Data Structures: Signature Sort)
[SICP on Sets]: http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-16.html#%_sec_2.3.3
    (SICP: Building Abstractions with Data. Example: Representing Sets)
[Super Scalar Sample Sort]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.72.366&rep=rep1&type=pdf
    (A fast variant of Sample Sort for super scalar architectures)
[External Memory Mergesort]: http://algo2.iti.kit.edu/dementiev/files/DS03.pdf
    (Asynchronous Parallel Disk Sorting)
[Priority Queues for Cached Memory]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.16.3589&rep=rep1&type=pdf
    (Fast Priority Queues for Cached Memory)
[Range Minimum Queries]: http://www-ab.informatik.uni-tuebingen.de/people/fischer/rmq-journal.pdf
    (Space-Efficient Preprocessing Schemes for Range Minimum Queries on Static Arrays)
[Quicksort Branch Misspredictions]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.93.2653&rep=rep1&type=pdf
    (How Branch Mispredictions Affect Quicksort)
[Designing Parallel Algorithms]: http://www-unix.mcs.anl.gov/dbpp/
    (Designing and Building Parallel Programs, Ian Foster)
