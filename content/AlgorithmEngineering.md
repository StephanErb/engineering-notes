# Algorithm Engineering

Not every algorithm or data structure that looks great in theory is also useful in practice. Designing fast implementations is an art that this document aims to distill to a few guiding principles.


## Methodology

In Programming Pearls, Bentley summarises different levels impacting the performance of a program. The lower we are in this hierarchy the lower the performance impact or improvement we can achieve:

* Problem Definition / Requirements

    - i.e. think end-to-end. Maybe we get away with solving the problem for a restricted input, or not at all.

* System Structure / Modularisation
* Algorithms and Data Structures
* Code Tuning
* Hardware specifica

This is also the reason why many companies are not really invested into algorithms and data structures: They can get a way with tuning their problems. However, if we really want to get fast we have to tune on all levels.

General approach:

0. Aim for solving the simplest problem possible (rather than the general case).
1. Inspect all existing asymptotically optimal algorithms.
2. Choose the the simplest one.
3. Implement your algorithm targeting a suitable machine model.
4. Start to optimize it. Be aware, these optimizations are meant to be driven by theory and not just bit-level tricks.

    - identify and eliminate computations which are not required in all cases (excessive work)
    - optimize memory access patterns
    - eliminate branch miss-predictions (e.g., see _[Quicksort Branch Misspredictions]_)
    - ...

5. Run your experiments on:

    - different architectures (e.g., current Intel, AMD, MIPS) to cover both CISC and RISC architectures
    - different types of inputs. Preferrably real world data, but also generated ones e.g., uniformly distributed, skewed, etc.
    - highly tuned competitors codes (i.e., how do you compare two medicore implementations?)

6. Repeat


## Recurring Design Ideas

There seem to be some simple ideas that have influenced the design of many algorithms and data structures. This list is not authoritative (in particular w.r.t. to naming), it just lists some observations. The ideas seem to be heavily connected and seldomly used in isolation.

* __K-Way approach:__ Instead of binary operations that are scattered over a deep recursion, perform a k-way operation. This limits the number of recursion levels and gives room for clever implementations of the (k-way) operation. Examples:

    - B-Tree are faster than binary trees in practice. Due to the larger k-way nodes they are more cache efficient.
    - An [External Memory Mergesort] performs less IOs due to the limited recursion depth. Its k-way merge function can be implemented efficiently with help of _tournament trees_.
    - Samplesort generalizes over Quicksort by recursively sorting $K$ partitions. It can be parallelized more efficiently.

* __Batch Processing:__ Grouping individual operations to a batch of operations can have various advantages. To get there, think about elements to which the same things happens.

    - When latencies are an issue, batching can be used to amortize the latency over a number of buffered element. Examples:

        + _[Priority Queues for Cached Memory]_ use a priority queue in internal memory that buffers elements so that the expensive write operations to the external memory can be performed in batches

    - Pre-processing (such as sorting) of the buffered elements can sometimes be used to generate additional information speeding up the batch operation. Examples:

        + Constructing or update of a tree by inserting elements in sorted order, i.e., a form of _finger search_.

    - Processing elements in batches can allow us to paralleize the operation, something which would not e feasible for individual elements.

        + The parallel _Pareto Search_ algorithms processes batch of lables instead of individual labels as in classic label setting algorithms. All its operations can be parallelized

* __N-Phase Computation:__ If something is complicated (and thus slow) to do in a single pass, feel free to use several phases. A multi pass approach can remove dependencies within subsequent iterations of a loop and therefore enable sotware piplining (overlapping loop iterations -> out of order execution). Examples:

    - _[Super Scalar Sample Sort]_ sorts in two phases. In the first pass it is only decides in which bucket an element shall be assigned to. The actual data movement into the preallocated subarrays is then performed in the second pass once the total bucket sizes are known.
    - A special case of this is the idea to split setup and repeated actions in many algorithms. For example, rather than doing multiple slow memory alloctions over the course of an algorithm, perform all allocations once and upfront.

* __Reduction / Input Simplification:__ Reduce the problem set at hand until it is simple enough so that it can be solved using basic means (e.g., another algorithm). This idea is at the core of most recursive algorithms.

    - _Independet-Set Removal_ is used to speed up list ranking by removing elements form the list until the list is small enough to be ranked easily.
    - _Signature Sort_ recursively reduces the size of the keys until they can be sorted with _Packed Sorting_.
    - The _findclose_ operation on _Succinct Trees_ finds the position of a closing bracket within the bitstring representing the tree. The idea is to solve the problem for a corresponding, so-called pioneer and then deduce the actual closing position from the closing position of the corresponding pioneer.

* __Tradeoff:__ Inspect simple, naive solutions with contradicting space and runtime bounds (e.g, online computation vs. precomputation of all results) and try to find a tradeoff that achieves the best of both worlds. So for example, instead of precoumputing all results, precompute just a particular subset. Examples:

    - [Level Ancestor Queries][] (to find the tree-ancestor on a particular level) can be approached using _jump pointers_ and _ladder decomposition_, which both precompute a subset of all potential queries and run in $\mathcal{O}(\log n)$ time. However, a combination of both leads to constant query time and a linear space requirement, thus heavily improving over the computation of all results.

* __Datastructure Combination:__ Combine several (different) data structures so that expensive operations of one data structure can be improved using a specialized data structure for this particular sub-problem. Examples:

    - _[String B-Trees]_ build _Patricia Tries_ on top of individual B-Tree nodes to improve over the binary search to find the insertion point within the keys of a node.
    - _[Priority Queues for Cached Memory]_ use a priority queue in internal memory that buffers elements so that the expensive write operations to the external memory can be performed in batches.

* __Indirection / Bucketing:__ Instead of working on a large problem set (with larger accompanying space & runtime bounds), first find a suitable bucket and then solve the problem only within this particular bucket. Examples:

    - _Perfect Hashing_ uses an indirection so that it is not required to find a perfect (injective) hash function for all elements, but only for the elements within the same collision bucket. This reduces the overall space requirement while retaining the expected construction and query time.
    - _Y-Fast Tries_ improve upon the space requirements of _X-Fast Tries_ by building the trie over representatives of buckets instead of over all elements. The buckets are implemented as balanced binary trees and do not just reduce the space requirement of _X-Fast Tries_ but also help to reduce update costs using amortization.
    - _Range Minimum Queries_ as implemented by [Fischer and Heun][Range Minimum Queries] use a data structure that normally requires $n \log n$ words but only insert a subset of elements so that they can reduce the space requirements to $\mathcal{O}(n)$.
    - _Succinct Data Structures_ can profit from indirection layers as they reduce the number of elements that have to be distinguished from the whole universe down to all elements within a bucket. Thus, to distinguish these elements fewer bits are required.

* __Universe Representation:__ Represent a dense set over a finite domain by noting its existance in the universe as an alternative to representing/storing individual elements. The representation then often comes with optimization to reduce space requirements. Examples:

    - bitmaps
    - _van Emde Boas Trees_


## Common Low-Level Optimizations

A common rule is that the less instructions are issued, the faster runs an algorithm. Sophisticated checks for special cases are therefore not always worth it. Also mind that depending on the hardware and the algorithm either branches or memory access can be the limiting factor.

* __Broadword Computing:__ Fuse data elements into machine words and run operation on then in parallel, instead of sequentially. You can get more done within fewer instructions and without having to hit memory.

    - _[Fusion Trees]_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.

* __Tail Call Optimization:__  Given an algorithm with recursive calls (e.g., quicksort), one call can be replaced with a while loop, by making the recursion-end the loop condition. To limit the recursion depth, the larger call should be handled in the while loop.

* __Sentinals:__  Sentinals are algorithm-specific elements added to the managed data in order to simplify and ensure that certain invariants hold. They are commonly used to limit comparisions for boundary cases. For example:

    - When implementing a linked list, we have to deal with the list beginning and list end as a special case. We can remove this special case by making the list circular and beginning/ending in a special sentinal element. We can now add an element after the last element or before the first element without any special checks for dangling pointers. The sentinal also helps with search: Just store the element you are looking for in the sentinal, you can now search the entire list for without having to check if the list end is reached. The list end if found naturally if the element is not in the list.

* __Branch Predictions:__ It's the number of hard to predict branches that matters. Conditional branches within loops may be hard to predict, because the comparision produces valuable information and both branches may be both likely to be taken (e.g., quicksort pivot comparision). The branch predictor will fail often enough for the performance to suffer greatly. Mind that end-of-loop conditions are easy to predict, as a missprediction only happens when the loop is exited. Workarounds for hard to predict branches:

    - _[Super Scalar Sample Sort]_ mitigates the hard to predict conditional branches of _quicksort_ by using a _two phase computation_ approach where comparisions for neighboring elements are independet from each other (i.e we limit or defer unneeded data dependencies). These comparisons can then be executed (in parallel) as _[predicated instructions](http://en.wikipedia.org/wiki/Branch_predication)_ which do not trigger branch miss predictions and expensive pipeline flushes.
    - _Translate control to data dependencies_ to mitigate the need for branches: `cmp` operations (or the equivilant substractions) return 0 and 1. Instead as a branch condition these can be used with index computations of _[implicit data structures](http://en.wikipedia.org/wiki/Implicit_data_structure)_. For example, this works in _binary heaps_ embedded into arrays and in the implicit search tree of _[Super Scalar Sample Sort]_.

* __Early Recursion End:__ If the data set is small then algorithms with worse asymptotic behaviour but better constant factors can become faster (e.g., quicksort implementations fall back to insertion sort)

* __Required Register Count:__ The close the number of required registers is to the actual available register count the better. Mind that when setting tuning paramets (e.g., the _k_ in _[k-way algorithms](#recurring-design-ideas)_).



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
