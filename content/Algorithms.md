# Algorithm & Data Structures Design Toolbox

## Data Structures
Many applications just rely on dynamic list structures, hashmaps and sorting. This is fine in most cases. However, here are some observations:

* _Orderness_ seems to be underutilized. Instead of storing elements without a particular order, consider keeping them sorted. This can help to [speed up operations][SICP on Sets] on them. So for example, instead of hashing and sorting, also consider an ordered associative array (e.g., Java's `SortedMap` or `NaviagableMap`).
* Integer keys seem to be underutilized. This also implies that hashing is favored in cases where plain arrays or bit sets (e.g., Java's `BitSet`) would do just fine (and would even be faster and require less space). Therefore, consider enumerating the elements you are dealing with.
* Using the implementation of an abstract data type does not relieve from having a good mental model of its associate costs. For example, when using a resizable array implementation (e.g. Java's `ArrayList`):
    - Try to avoid inserts/deletes at all positions beside the end of the list, as these require the array to be shifted.
    - When the number of elements that the list shall hold is known, but elements can only be inserted one by one, correctly initialize the list in order to avoid the numerous internal array copies.

### Trie
A _trie_ is a special kind of edge labeled tree. If used over a collection of keys, it can be used to find the significant difference between these keys (i.e., the _important bit positions_ sufficient to distinguish all keys). For sorted sequences it can be constructed in $\mathcal{O}(n)$. Examples:

* _[Fusion Trees]_ compress keys within _B-Tree_ nodes by reducing them to the bits at the important bit positions. All keys of a node can then be fused into a single machine word and compared to a query element in parallel using a single bitparallel subtraction.
* _[String B-Trees]_ use _Patricia Tries_ to identify the subset of characters relevant for the comparison of a string pattern to the keys of a _B-Tree_. Knowing these characters and the lengths of the common prefixes of keys,  the number of required I/Os per traversal can be limited.
* _[Signature Sort]_ splits keys into chunks and compresses these chunks using a hash function. A trie is then used to filter the chunks that are not relevant for the sort order of the keys. The keys therefore become smaller and sorting them becomes easier.


## Recurring Design Ideas
There seem to be some simple ideas that have influenced the design of many algorithms and data structures. This list is not authoritative (in particular w.r.t. to naming), it just lists some observations. The ideas seem to be heavily connected and seldomly used in isolation. 

* __Tradeoff:__ Inspect simple, naive solutions with contradicting space and runtime bounds (e.g, online computation vs. precomputation of all results) and try to find a tradeoff that achieves the best of both worlds. So for example, instead of precoumputing all results, precompute just a particular subset. Examples:
    - [Level Ancestor Queries][] (to find the tree-ancestor on a particular level) can be approached using _jump pointers_ and _ladder decomposition_, which both precompute a subset of all potential queries and run in $\mathcal{O}(\log n)$ time. However, a combination of both leads to constant query time and a linear space requirement, thus heavily improving over the computation of all results.

* __Combination:__ Combine several different data structures so that expensive operations of one data structure can be improved using a specialized data structure for this particular sub-problem. Examples:
    - _[String B-Trees]_ build _Patricia Tries_ on top of individual B-Tree nodes to improve over the binary search to find the insertion point within the keys of a node.

* __Indirection/Bucketing:__ Instead of working on a large problem set (with larger accompanying space & runtime bounds), first find a suitable bucket and then solve the problem only within this particular bucket. Examples:
    - _Perfect Hashing_ uses an indirection so that it is not required to find a perfect (injective) hash function for all elements, but only for the elements within the same collision bucket. This reduces the overall space requirement while retaining the expected construction and query time.
    - _Y-Fast Tries_ improve upon the space requirements of _X-Fast Tries_ by building the trie over representatives of buckets instead of over all elements. The buckets are implemented as balanced binary trees and do not just reduce the space requirement of _X-Fast Tries_ but also help to reduce update costs using amortization. 
    - _Succinct Data Structures_ can profit from indirection layers as they reduce the number of elements that have to be distinguished from the whole universe down to all elements within a bucket. Thus, to distinguish these elements less bits are required.

* __Decomposition:__ Instead of dealing with elements of objects as a whole, split them into logical subparts. Exploit this inner structure to achieve higher efficiency and eventually solve the problem within a richer model of computation (e.g., compare bits instead of whole integers) . Examples:
    - _X-Fast Tries_ split integer keys into their common prefixes and use a binary search to find the longest common prefix. 
    - _van Emde Boas Trees_ split recursively split keys into a top and bottom halve in order to efficiently navigate within buckets and summaries over these buckets. 
    - [Level Ancestor Queries] can be implemented via the idea of recursively splitting a tree into its longests paths (_longest path decomposition_) and precomputing the results within these paths.

* __Input Reduction/Simplification:__ Reduce the problem set at hand until it is simple enough so that it can be solved using basic means. This idea is at the core of most recursive algorithms.
    - _Independet-Set Removal_ is used to speed up list ranking.
    - _Signature Sort_ recursively reduces the size of the keys until they can be sorted with _Packed Sorting_.
    - The _findclose_ operation on _Succinct Trees_ finds the position of a closing bracket within the bitstring representing the tree. The idea is to solve the problem for a corresponding, so-called pioneer and then deduce the actual closing position from the closing position of the corresponding pioneer.

* __Broadword Computing:__ Fuse data elements into machine words and run operation on then in parallel, instead of sequentially. You can get more done within fewer instructions and without having to hit memory.
    - _[Fusion Trees]_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.

* __Two Phase Computation:__ If something is complicated (and thus slow) to do in a single pass, feel free to use several phases. Examples:
    - _[Super Scalar Sample Sort]_ sorts in two phases....
    - Pipelined Prefix Sum (Paralag und Sanders Paper?)
    - All to all for irregular message sizes 

## Succinct Data Structures
Succinct Data Structures are space efficient implementations of abstract data types (e.g., trees, bit sets) that still allow for efficient queries. 

## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of _bloom filters_ or _[Approximate Distance Oracles]_).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that call operations with _expected_ runtime bounds and that have to be synchronized before and afterwards. The runtime will suffer whenever at least one of the processes hits an expensive case. 


## Parallel Algorithms
PE stands for _processing element_ (i.e., an actively running thread).

* Start with a simple PRAM algorithms and take as many PEs as you want to and place them in an appropriate layout (e.g., hypercube, 3D-cube, 2D-grid). This allows you to learn about the problem and how it can be parallelized. Commonly, the next step is then to apply _Brent's Principle_ to make the algorithm more efficient by reducing the number of PEs. This can be done by decoupling the strict mapping of elements to PEs and assigning $\frac{n}{p}$ elements per PE for a now arbitrary $p$.

* Obviously, PEs should never idle. This implies several things:
    - Tree-shaped communication paths and pipelining can help to distribute data more quickly, so that all PEs can start working earlier.
    - Expose the parallelization from the beginning (e.g., don't spawn threads for the multiple recursive calls within a recursive algorithms such as quicksort)

* Load balancing is important at the core of many parallel algorithms. Some examples:
    - Sample sort uses samples to find splitters that split up the data in (hopefully) equally sized chunks. Each PE is then responsible to sort one of these chunks.
    - Prefix-sums / scan operations are commonly used to enumerate items on the different PEs. Knowing how many of these items exist in total and on each predecessor PE, the items can be distributed equally.
    - Master-Worker does not scale very well :-).

* Long paths (e.g., linked-lists, long paths within trees) are difficult to parallelize. Sorting the nodes of a path (e.g., via _list ranking_ based on _doubling_ and _independent set removal_) and storing them in an array, enables parallelization. Every PE can then operate on a particular index-range on the array.


## Algorithm Engineering
Always run your experiments on:

* different architectures (e.g., current Intel, AMD, MIPS to cover both CISC and RISC architectures)
* different types of inputs (e.g., uniformly distributed, skewed)


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