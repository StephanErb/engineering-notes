# Algorithm Design Toolbox

## Randomized Algorithms

* Among others, randomized algorithms help to improve robustness concerning worst-case inputs (e.g., think of the pivot selection problem in `quicksort` when the sequence is provided by a malicious adversary).
* Allowing randomized algorithms to compute a _wrong_ result (with a very low probability) can open many new possibilities concerning speed, space, quality and ease of implementation (e.g., think of `bloom filters`).
* Never use the `C` `rand()` function. If in doubt, use _Mersenne Twister_.
* Use random numbers with care. Treat them as a scarce resource.
* In certain parallel setups, _expected_ bounds of randomized algorithms do no longer hold: Consider `n` processes that call operations with _expected_ runtime bounds and that have to be synchronized before and afterwards. The runtime will suffer whenever at least one of the processes hits an expensive case. 
