# Data Structures

 In essense, we preprocess information into data structures (i.e., saving state) in order to avoid recomputations. Following this idea, good data structures reduce a big program to a small program. Representation, and therefore data structures, is the essence for program writing. Let the data structure the program [Programming Pearls].


## Pratical advice

Many applications just rely on dynamic list structures, hashmaps, and sorting. This is fine in most cases. However, here are some observations:

* _Orderness_ seems to be underutilized. Instead of storing elements without a particular order, consider keeping them sorted. This can help to [speed up operations][SICP on Sets] on them. So for example, instead of hashing and sorting, also consider an ordered associative array (e.g., Java's `SortedMap` or `NaviagableMap`).

* Integer keys seem to be underutilized. This also implies hashing is favored in cases where plain arrays or bit sets (e.g., Java's `BitSet`) would do just fine (and would even be faster and require less space). Therefore, consider enumerating the elements you are dealing with.

* Using the implementation of an abstract data type does not relieve from having a good mental model of its associate costs. For example, when using a resizable array implementation (e.g. Java's `ArrayList`):

    - Try to avoid inserts/deletes at all positions beside the end of the list as these require the array to be shifted.
    - When the number of elements that the list shall hold is (roughly) known but elements can only be inserted one by one, correctly initialize the list in order to avoid the numerous internal array copies.


## Categories

The data structures commonly seen in the wild (and tought in school) can be classified using a few abstract data types, i.e. a defined set of operations defined over a type, without knowing or relying on concrete implementation details:

* Stacks and Qeueues (FIFO, LIFO, DEQUE)

  - powerful as limited operation subset provide a significant freedom for the implementation
  - common implementations rely on arrays, lists, ring buffers, and a combination of all of them.

* Arrays (static, dynamic size)

  - the most important thing an array is providing is random access and space efficent storage
  - both are helpful for operations such as binary search

* Lists (single linked, double linked)

  - somewhat a generalisation of stacks and queues as insert/delete are efficient anywhere and not just
    at the beginning and end.

* Trees

  - essentially a 2D genralisation of linked list that provide us with O(log n) operations in case we
    ensure the tree does not degenerate back to a list.
  - it helps to think of a tree as a O(log n) navigation structure on top of a sorted sequence / list.

* Graphs

  - generalisation of trees which allow cycles and multiple predecessors

* Map / Associative Array
* Set
* Priority Qeueues

  - relax the strictness of fully sorted sequences (e.g in a binary tree we don't care which child is smaller as long as the node itself is the smallest).
  - relaxation helps to provide us with const time minimum retrieval, and linear time construction.

In addition to supported set of operations, data structures can also be classified according to a few other dimensions. For example, orderdness:

* Unordered: Iteration order is undefined, e.g many hash tables or hash sets. This is a viable tradeoff for achiving O(1) lookups.
* Sorted: Items are maintained in a given pre-defined order such as from smallest to largest element, e.g sorted array, skip-list, balanced binary tree. Sorting order can be very helpful to speed up lookups.
* Insertion-order: Items are maintained in ther order they where inserted, e.g. array, list, deque.

 For example, binary search on a large sorted array is significantly faster than a sequential scanning.


## Trees and Tries

Trees can be constructed in $\mathcal{O}(n)$ if their elements are inserted in the order of their leafs. Starting from the last that has been inserted, one has to move up until the edge / node is found where the new node shall be added. As we only operate on the right-most path, the runtime follows by a simple amortized argument. Examples:

* Deriving _Suffix Trees_ from _Suffix_ & _LCP Arrays_

* Constructing _Cartesian Trees_ (heap-ordered binary trees for which a symmetric (in-order) traversal returns the original integer sequence)

A _trie_ is a special kind of edge labeled tree. If used over a collection of keys, it can be used to find the significant difference between these keys (i.e., the _important positions_ sufficient to distinguish all keys). Examples:

* _[Fusion Trees]_ compress keys within _B-Tree_ nodes by reducing them to the bits at the important bit positions required to distinguish the keys. All keys of a node can then be fused into a single machine word and compared to a query element in parallel using a single bitparallel subtraction.
* _[String B-Trees]_ use _Patricia Tries_ (aka _radix tries_ or _compact prefix trees_) to identify the subset of characters relevant for the comparison of a string pattern to the keys of a _B-Tree_. Knowing these characters and the lengths of the common prefixes of keys, the number of required I/Os per traversal can be limited.
* _[Signature Sort]_ splits keys into chunks and compresses these chunks using a hash function. A trie is then used to filter the chunks that are not relevant for the sort order of the keys. The keys therefore become smaller and sorting them becomes easier.


# Tree and Graph Traversal

* Trees:

    - Depth-first search (DFS): commonly implemented via a LIFO (ie. call stack or explicit stack)
    - Breadth-first search (BFS): commonly implemented via a FIFO (ie. visit nodes in the order they where encountered)

* Graphs: In principle, the idea is the same as for trees. However, we might cross a node multiple times and need to prevent visiting it twice. Options includes hashsets, node marking, or separate, node-id-index data structures keep track if a node has already been visited.

Many graph algorithm, such as Dijkstra, just add a spin to the idea: Instead of using a LIFO or FIFO they use a priority queue to decide which node to expand next.


## Suffix Arrays and Suffix Trees

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


[SICP on Sets]: http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-16.html#%_sec_2.3.3
    (SICP: Building Abstractions with Data. Example: Representing Sets)
