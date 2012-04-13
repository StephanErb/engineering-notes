# Algorithm & Data Structures Design Toolbox

## Data Structure Abuse
Most applications come away

## Data Structure Use

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
    - _Fusion Trees_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.


## Succinct Data Structures
Succinct Data Structures are space efficient implementations of abstract data types (e.g., trees, bit sets) that still allow for efficient queries. 

## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of _bloom filters_ or _[Approximate Distance Oracles]_).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that call operations with _expected_ runtime bounds and that have to be synchronized before and afterwards. The runtime will suffer whenever at least one of the processes hits an expensive case. 


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
