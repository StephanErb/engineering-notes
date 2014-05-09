# Algorithm & Data Structures Design Toolbox

Its about finding the right data structure and accompaning algorithm for the job. Generally, this depends on the number of elements involved in the computation (e.g., _internal memory_ vs _external memory algorithms_, _van Emde Boas Trees_ vs _[Fusion Trees]_, ...).


## Algorithm Engineering

Performance depends on technological properties of machines like parallelism, data dependencies and memory hierarchies. These play a role even in lower order terms.


General approach:

1. Inspect all existing asymptotically optimal algorithms
2. Choose the the simplest one.
3. Start to optimize it.

    - identify and eliminate computations which are not required in all cases (excessive work)
    - optimize memory access patterns
    - eliminate branch miss-predictions (e.g., see _[Quicksort Branch Misspredictions]_)
    - ...

    These optimizations are meant to be driven by theory and not just bit-level tricks.
4. Always run your experiments on:

    - different architectures (e.g., current Intel, AMD, MIPS) to cover both CISC and RISC architectures
    - different types of inputs (e.g., uniformly distributed, skewed)
    - highly tuned competitors codes (i.e., how do you compare two medicore implementations?)

5. Repeat


## Data Structures

Many applications just rely on dynamic list structures, hashmaps and sorting. This is fine in most cases. However, here are some observations:

* _Orderness_ seems to be underutilized. Instead of storing elements without a particular order, consider keeping them sorted. This can help to [speed up operations][SICP on Sets] on them. So for example, instead of hashing and sorting, also consider an ordered associative array (e.g., Java's `SortedMap` or `NaviagableMap`).

* Integer keys seem to be underutilized. This also implies hashing is favored in cases where plain arrays or bit sets (e.g., Java's `BitSet`) would do just fine (and would even be faster and require less space). Therefore, consider enumerating the elements you are dealing with.

* Using the implementation of an abstract data type does not relieve from having a good mental model of its associate costs. For example, when using a resizable array implementation (e.g. Java's `ArrayList`):

    - Try to avoid inserts/deletes at all positions beside the end of the list as these require the array to be shifted.
    - When the number of elements that the list shall hold is (roughly) known but elements can only be inserted one by one, correctly initialize the list in order to avoid the numerous internal array copies.


### Trees / Tries

A _trie_ is a special kind of edge labeled tree. If used over a collection of keys, it can be used to find the significant difference between these keys (i.e., the _important bit positions_ sufficient to distinguish all keys). Examples:

* _[Fusion Trees]_ compress keys within _B-Tree_ nodes by reducing them to the bits at the important bit positions required to distinguish the keys. All keys of a node can then be fused into a single machine word and compared to a query element in parallel using a single bitparallel subtraction.
* _[String B-Trees]_ use _Patricia Tries_ (aka _radix tries_ or _compact prefix_ trees) to identify the subset of characters relevant for the comparison of a string pattern to the keys of a _B-Tree_. Knowing these characters and the lengths of the common prefixes of keys,  the number of required I/Os per traversal can be limited.
* _[Signature Sort]_ splits keys into chunks and compresses these chunks using a hash function. A trie is then used to filter the chunks that are not relevant for the sort order of the keys. The keys therefore become smaller and sorting them becomes easier.

Trees can be constructed in $\mathcal{O}(n)$ if their elements are inserted in the order of their leafs. Starting from the last that has been inserted, one has to move up until the edge / node is found where the new node shall be added. As we only operate on the right-most path, the runtime follows by a simple amortized argument. Examples:

* Deriving _Suffix Trees_ from _Suffix_ & _LCP Arrays_
* Constructing _Cartesian Trees_ (heap-ordered binary trees for which a symmetric (in-order) traversal returns the original integer sequence)


### Suffix Arrays and Suffix Trees

Suffix trees are very powerful, i.e., the _repeat problem_ (the pattern mining problem to find all maximal strings that are repeated more than once within the document) can be solved very easily on suffix trees.

The longer the LCP of two suffixes, the closer those are placed to each other within the suffix array. This grouping / locality information is used in various ways. Examples
* during pattern matching
* finding the longest previous substring for computing the LZ77 factorization. Only inspect the suffix in close proximity that stand refer to a previous text position --> previous and next smaller values.


### Succinct Data Structures
Succinct Data Structures are space efficient implementations of abstract data types (e.g., trees, bit sets) that still allow for efficient queries without having to unpack it first. Everything is accessed in-place, by reading bits at various positions in the data. To achieve optimal encoding, we use bits instead of bytes. All of our structures are encoded as a series of 0's and 1's.

Common / usefull operations:
* __ranke__ large universe with gaps -> small universe (think of perfect hashing for integers)
* __select__

A common implementation technique is to split the data structure / problem into blocks:

* on the first block level, the blocks are few enough so that we can spend many bits for each pre-computed result per block
* on the second block level which splits existing blocks into sub-blocks, there are many blocks but the results are stored relatively to the surrounding blocks and therefore require fewer bits.
* if required, sub-blocks can be splitted even further. They may then be small enough for their results to fit into a full lookup-table.



### List of other nice Data Structures

* __Union-find Data structure:__ Commonly used to find cycles and connected components within graphs.
* _Wavelet Trees_
* _Tournament Trees / Loser Trees_ for _k-way_-merging of large data sets (assuming a large _k_ such as 256)
* _2D Min Heaps_
* _RMQ & LCA_

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

* __Decomposition:__ Instead of dealing with elements of objects as a whole, split them into logical subparts. Exploit this inner structure to achieve higher efficiency and eventually solve the problem within a richer model of computation (e.g., compare bits instead of whole integers) . Examples:
    - _X-Fast Tries_ split integer keys into their common prefixes and use a binary search to find the longest common prefix.
    - _van Emde Boas Trees_ recursively split keys into a top and bottom halve in order to efficiently navigate within buckets and summaries over these buckets.
    - [Level Ancestor Queries] can be implemented via the idea of recursively splitting a tree into its longests paths (_longest path decomposition_) and precomputing the results within these paths.

* __Input Reduction/Simplification:__ Reduce the problem set at hand until it is simple enough so that it can be solved using basic means (e.g., another algorithm). This idea is at the core of most recursive algorithms.
    - _Independet-Set Removal_ is used to speed up list ranking.
    - _Signature Sort_ recursively reduces the size of the keys until they can be sorted with _Packed Sorting_.
    - The _findclose_ operation on _Succinct Trees_ finds the position of a closing bracket within the bitstring representing the tree. The idea is to solve the problem for a corresponding, so-called pioneer and then deduce the actual closing position from the closing position of the corresponding pioneer.

* __Broadword Computing:__ Fuse data elements into machine words and run operation on then in parallel, instead of sequentially. You can get more done within fewer instructions and without having to hit memory.
    - _[Fusion Trees]_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.

* __Two Phase Computation:__ If something is complicated (and thus slow) to do in a single pass, feel free to use several phases. Two pass approach: Can remove dependencies within subsequent iterations of a loop and therefore enable sotware piplining (overlapping loop iterations -> out of order execution). Examples:
    - _[Super Scalar Sample Sort]_ sorts in two phases. In the first pass it is only decides in which bucket an element shall be assigned to. The actual data movement into the preallocated subarrays is then performed in the second pass once the total bucket sizes are known.
    - Pipelined Prefix Sum (Paralag und Sanders Paper?)
    - All to all for irregular message sizes

* __K-Way approach:__ Instead of binary operations that are scattered over a deep recursion, perform a k-way operation. This limits the number of recursion levels and gives room for clever implementations of the (k-way) operation. Examples:
    - An [External Memory Mergesort] performs less IOs due to the limit recursion depth. Its k-way merge function can be implemented efficiently with help of _tournament trees_.
    - Samplesort generalizes over Quicksort by recursively sorting $K$ partitions. It can be parallelized more efficiently.

* __Batch Processing:__ E.g. order the data to be added than use this information to perform the insertion clever. Tree construction, pareto queue, external memory section on batching, Idee der Pre-Buffer Datenstruktur: In kleine Datenstruktur einfügen, dann irgendwann flush in eine Große als vorbereitete Batch-Op (e.g., External PrioQues mit interner und großer externer PQ.

Idee der Pre-Buffer Datenstruktur: In kleine Datenstruktur einfügen, dann irgendwann flush in eine Große als vorbereitete Batch-Op (e.g., External PrioQues mit interner und großer externer PQ

- _[Priority Queues for Cached Memory]_ use a priority queue in internal memory that buffers elements so that the expensive write operations to the external memory can be performed in batches.

nodaris independent set stuff.

## Common Low-Level Optimizations

A common rule is that the less instructions are issued, the faster runs an algorithm. Sophisticated checks for special cases are therefore not always worth it.

* __Tail Call Optimization:__  Two recursive calls: One can be replaced with while loop (by making the recursion end if a loop). Only suitable of the work done by a recursive call is potentially small. (--> tail call optimization)

* __Sentinals:__ Special elements that added to the data (e.g., beginning and end of list) and remove the need for special case handling. Instead of several only one loop condition has to be checked, simplifying and thus improving the performance of the code.  use sentinals to limit actual comparisions for boundary cases (e.g., quicksort inner loop, dummy element in lists: cycluar)

* __Hard to Predict Branches:__ Conditional branches within loops may be hard to predict because both branches may be both likely to be taken. The branch predictor will fail often enough for the performance to suffer greatly. Mind that end-of-loop conditions are easy to predict. A missprediction only happens when the loop is exited. Some branches cannot be predicted, because they always produce valuable information (e.g., quicksort pivot comparison). Predictor off in 50% of the cases. Nicht unbedingt die Anzahl Branches wichtig, sondern die Anzahl der schwer vorhersagbaren Branches zählt!


    - _[Super Scalar Sample Sort]_ mitigates the hard to predict conditional branches of _quicksort_ by using a _two phase computation_ approach where comparisions for neighboring elements are independet from each other. These comparisons can then be executed (in parallel) as _[predicated instructions](http://en.wikipedia.org/wiki/Branch_predication)_ which do not trigger branch miss predictions and expensive pipeline flushes.
    - Mitigating branches requires to _translate control to data dependencies:_ `cmp` operations (or the equivilant substractions) return 0 and 1. Instead as a branch condition these can be used with index computations of _[implicit data structures](http://en.wikipedia.org/wiki/Implicit_data_structure)_. For example, this works in _binary heaps_ embedded into arrays and in the implicit search tree of _[Super Scalar Sample Sort]_.

* __Data-dependencies:__ Try to limit or defer unneeded data dependencies by following a (two-pass approach)[#recurring-esign-ideas]. Less data-dependencies make it easier to fully exploit the super scalar instruction units of modern CPUs (e.g., see _[Super Scalar Sample Sort]_).

* __Early Recursion End:__ If the data set is small then algorithms with better asymptotic behaviour but better constant factors can become faster (e.g., quicksort implementations fall back to insertion sort)

* __Required Register Count:__ The close the number of required registers is to the actual available register count the better. Mind that when setting tuning paramets (e.g., the _k_ in _[k-way algorithms](#recurring-design-ideas)_).

For memory efficency, see [here](#cache-efficient-and-external-memory-algorithms). Mind that depending on the hardware and the algorithm either branches or memory access can be the limiting factor.


## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of _bloom filters_ or _[Approximate Distance Oracles]_).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that call operations with _expected_ runtime bounds and that have to be synchronized before and afterwards. The runtime will suffer whenever at least one of the processes hits an expensive case.



## Cache-Efficient and External Memory Algorithms

cpu cycles are orders of magnitudes faster than memory accesses. The cost of a memory access depends on the level of the memory hierarhcy that serves a request.

Efficient algorithms become compute bound (i.e. more memory won't help).

Iterating a linked list -> random access in emmory. Instead duplicate lists & sort by id, predecessor, successor id then scan those in parallel. Neighbors of i are in the other arrays at the same position. This is cache efficient and can enable parallelization.

Incorporate locality directly into the algorithm:

* access memory in a block-wise fashion
* dismiss random access patterns in favor of scanning / streaming
* as IO is expensive, the main memory becomes an important and scarce resource. The available memory should always be used completely and efficiently (there is a trade off with how much memory shall be used for buffering (i.e., blocks and the pointers to them) to enable faster IOs).

Block size not a technology constant but a tradeoff of maximal wasted space per empty, buffered block and wasted space per block pointer.

Approaches:

* Recursive divide'n'conquer. E.g., recursive binary heap construction is more cache efficienz thatn the iterative one
* neighbor hood ops via duplicated sort of pred /succ then simple scan.
* TODO: algo eng ZF has many more (goldene regeln)

Processor cache effects:
* L1, L2 cache sizes
* Instruction level parallelism
* Cache associativity (direct, n-way, fully)
* False cache line sharing


SPLIT the two topics. It is not exactly the same...

Advantage of many external algorithms: You can tell exactly how much internal memory you want to use.


## Parallel Algorithms
Goal is to come up with a parallel algorithm that has an appropriate ratio of computation to communication time for the designated target architecture (e.g., more coarse grained for NORMA or NUMA systems than for SMP systems). Don't forget to first tune your sequential reference algorithm; probably it is already fast enough.


### Parallele Maschinenmodelle

* PRAM: parallele Version des RAM/von Neumann Modell
* Distributed memory machine

Many computations can be represented as DAGs. Can easily be computed on PRAMs by computing layer _i_ in phase _i_. A computation on a distributed machine is possible just as well.


### Basic Toolbox
Most parallel algorithms are based on a set of recurring primitives

* Assoziative Operationens (reduce, e.g., +, max, min)
* Broadcast
* Gather, scatter
* All-to-all personalized communication
* Sorting
* Kollektive Kommunikation
* Gossiping ( = All-Gather = Gather + Broadcast)
* Combinations such as all-reduce or all-gather where all participating PEs get the whole result
* Recursive algorithms
   - Algorithmus ist “malleable”, d.h. dynamisch an den jeweils
verfügbaren Parallelismus anpassbar
   - Gut für task parallele shared memory Systeme
(z.B. Cilk, Intel TBB)
   - Anpassbar an hierarchisch aufgebaute Systeme
* Selection & multisequence selection

* Leverage trees over PEs to achive logarithmic communication paths and execution times (e.g., binary, binominal, fibonacci, ...)

* Long paths (e.g., linked-lists, long paths within trees) are difficult to parallelize. Sorting the nodes of a path (e.g., via _list ranking_ based on _doubling_ and _independent set removal_) and storing them in an array, enables parallelization. Every PE can then operate on a particular index-range on the array.

* Load balancing is important and therefore at the core of many parallel algorithms. Some examples:
    - Sample sort uses _sampling_ to find splitters that split up the data in (hopefully) equally sized chunks. Each PE is then responsible to sort one of these chunks.
    - Prefix-sums / scan operations are commonly used to enumerate items on the different PEs. Knowing how many of these items exist in total and on each predecessor PE, the items can be distributed equally.


* Obviously, PEs should never idle. This implies several things:

    - Tree-shaped communication paths and pipelining can help to distribute data more quickly, so that all PEs can start working earlier. This leads to logarithmic intead of linear time complexity.
    - Expose the parallelization from the beginning (e.g., don't spawn threads for the multiple recursive calls within a recursive algorithms such as quicksort)


* adapting data structures to remove multiple elements at a time, instead of just a single one. Operations are performed by all PEs simultanously / in parallel instead of just concurrently.
    - Pareto Queue
    - Best first Branch-and-bound with PE local priority queues



### A rough roadmap

(based on [Designing Parallel Algorithms])

1. Start with the problem. Not with a particular algorithm.

    - For example, we were only able to parallelize the multi-criteria shortest path problem by abandoning the priority heap used in state-of-the-art algorithms and replacing it with a _Pareto Queue_. We sticked to the general idea of label setting without blindly immitating existing sequential algorithms.

2. Partition the problem. Expose as much parallelism as possible by finding _all_ concurrent tasks. Use _Domain_ Decomposition or _Functional_ Decomposition as described below. You can even combine both techniques recursively.
3. Understand the communication paths and the required data flow between tasks.
4. Aim to reduce communication costs by merging some of the fine-grained tasks that have too many data-dependencies or by duplicating some of the computations whose results are required by many different tasks. Basically, in this phase you perform manual of graph clustering.
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





## Useful Formulars

Formulars which are often required during algorithm analysis:

* Gaus
* Hn
* gemom. Reihe
* Stearling Approx
* log. Gesetze
* markov inequality
* amdahls law

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
