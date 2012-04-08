# Algorithm & Datastructures Design Toolbox

## Data Structure Use & Abuse

### Trie
A _trie_ is a special kind of edge labeled trie. If used over a collection of keys, it can be used to find the significant difference between these keys (i.e., the _important bit positions_ sufficient to distinguish all keys). For sorted sequences it can be constructed in $\mathcal{O}(n)$. Examples:

* _Fusion Trees_ compress keys within _B-Tree_ nodes by reducing them to the bits at the important bit positions. Keys of a node can then be fused into a single machine word and 
compared to a query element in parallel, using a single subtraction.
* _String B-Trees_ use _Patricia Tries_ over keys to limit the number of required I/Os by identifying the subset of characters relevant for the string comparison. 
* _Signature Sort_ splits keys into chunks before hashing (thus compressing) and sorting them. A trie is then used to filter the chunks that are not relevant for the sort order of the keys. The keys therefore become smaller and can be sorted more easily using integer sort.



## Recurring Design Ideas
* __Tradeoff:__ Inspect simple, naive solutions with contradicting space and runtime bounds (e.g, online computation vs precomputation of all results) and try to find a tradeoff that achieves the best of both worlds.  So for example, instead of precoumputing all results, precompute for just a particular subset. Examples:
    - Level Ancestor:
        Jump Pointer -> nicht mehr alles vorberechnen
        Ladder Decomposition -> Baum in längste Pfade zerlegen. Nur für Knoten auf selben längsten Pfaden vorberechnen.
        Combination of Ladder Algorithm and Jump Pointers lead to constant query time! Though both have query time in O(log n)
    - TODO: LCA & Level Ancestors  (not just a bad tradeoff: using jump pointer and ladders we do actually improve both runtime and space!)

* __Combination:__ Combine several different datastructures to improve them.
    - _String B-Trees_ build _Patricia Tries_ on top of individual B-Tree nodes.

* __Indirection/Bucketing:__ Instead of working on a large problem set (with larger accompanying space & runtime bounds), first find a suitable bucket and then only solve the problem within this particular bucket. Examples:
    - _Perfect Hashing_ uses an indirection so that a perfect hash function only has to be found for each collision bucket of the first layer, instead of for all elements. This reduces the overall space requirement while retaining the expected construction and query time.
    - _Y-Fast Tries_ improve upon the space requirements of _X-Fast Tries_ by building the trie over representatives of buckets, instead of over all elements. The buckets are implemented as balanced binary trees. 
    - _Succinct Data Structures_ can profit from indirection layers as they reduce the number of elements that have to be distinguished from the whole universe down to all elements within a bucket. Thus, to dinstinguish these elements less bits are required.

* __Decomposition:__ Instead of dealing with elements of objects as a whole, split them into logical subparts and solve the problem within a richer model of computation. Exploit the inner structure of these elements to achieve higher efficiency (e.g., compare bits instead of whole integers) . Examples:
    - _X-Fast Tries_ split integer keys into their common prefixes keys and use a binary search to find the longest common prefix. 
    - _van Emde Boas Trees_ split recursively split keys into a top and bottom halve in order to efficiently navigate within buckets and summaries over these buckets. 
    - TODO: LCA & Level Ancestors

* __Input Reduction/Simplification:__ Reduce the problem set at hand until it is simple enough so that it can be solved using basic means. 
    - _Independet-Set Removal_ is used to speed up list ranking.
    - _Signature Sort_ recursively reduces the size of the keys until they can be sorted with _Packed Sorting_.
    - TODO: Findclose on succinct trees.
    - TODO: Approximate Distance Oracles

* __Broadword Computing:__ Fuse data elements into machine words and run operation on then in parallel, instead of sequentially. You can get more done within fewer instructions and without having to hit memory.
    - _Fusion Trees_ compare several integer keys with a single bitparallel computation.
    - _Packed Sorting_ is a variant of mergesort that packs several short integer keys into a machine word. It then uses bitparallel computations to speed up the base case and the merge of sorted words. In particular, it relies on a bitparallel version of _Bitonic Sorting_.


## Succinct Data Structures
Succinct Data Structures are space efficient implementations of abstract data types (e.g., trees, bit sets). 

## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of `bloom filters`).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that call operations with _expected_ runtime bounds and that have to be synchronized before and afterwards. The runtime will suffer whenever at least one of the processes hits an expensive case. 


[Level Ancestor] http://cg.scs.carleton.ca/~morin/teaching/5408/refs/bf-c04.pdf
