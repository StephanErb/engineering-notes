
------

------


# Stuff to look at

## Sources to review
* Study notes
    - Compiler Construction
    - Experimental Economics: Design Elements (e.g., baseline neighborhood) and the basic idea of falsification as supplement material for the algorithm engineering notes
    - Formal Systems (something in there?)
    - ~~Advanced Data Structures~~
    - Parallel Algorithms
    - Parallel Machines and Parallel Programming
    - Randomized Algorithms
    - Computerarchitecture (implications of branch predictions, cache coherence, pipelining, super scalar architecutures ...)
    - Softwareengineering II
    - Game Theory (Battle of the sexes :p)
* Lecture notes and books to skim
    - Algorithm Engineering
    - Algorithm II
    - Algorithms and Data Structures — The Basic Toolbox
    - Linder's _Things Thy Should have taught you_
* Books with potential:
    - Pragmatic Thinking and Learning
    - Notes from the Pragmatic Programmer
    - Notes from Head First Software Development (Very light stuff but maybe there is something in there. I used to enjoy reading it.)
    - ...


## Random topics ... maybe worth adding, maybe not...

* Distributed systems

* Scheduling
 - Scheduling strategies in realtime systems: does that teach about SLA based scheduling? E.g. something similar to least-laxity first (LLF) scheudling (deadline - currenttime - remaining computation time of the job)

* Embedded Systems
  - safety and reliability patterns:
    + protected single channel / sanity check (no redundancy, but we validate that we computed something useful using data validation...e.g., crc. very similar to monitoring. helps with transient failures)
    + homogenous redundancy (against random faults but not systematic ones),
    + tripple modular redundancy (similar to homogenous, but prevent restarts of the homogenous one),
    + heterogeneous redundancy,

* Security
  - practice defense in depth


* Algorithms
  - Optimize the critical path.
  - Lock free vs wait free concurrency control... No kernel involved in lock free algo (eg mutex or semaphore) but just atomic CPU operations.. To make lock free algos fast, you probably need batching
  - When tuning, there often is not a single optimal solution. Different solutions may be good for different sub classes of the problem (eg passing around large vs small messages with a given allocation cost and pre allocated buffers for small messages)
  - Implement batching on the top most stack level. Disable it on lower levels as it will only increase latency.
  - Split common Ops into at least two phases: setup and repeated actin eg slow malloc with free list. Maintainable code and good performance.
  - sanders parallels keynote:
    + Design algorithms to be message passing. You gain the flexibility to implement it on shared memory if mneeded
    + when latency matters, throw all PEs on at it even when the algo is inefficient (i.e., bad speedup) -> everything counts as long as you can reduce latency
    + don't dismiss analyis in practice --> you probably know wether it will work before you try it.
    +  a properly chosen algorithms zerfällt mit glück wieder zu embarissingly parallel subalgos

* Design
  - Unix: Do one thing, do it well. Vs batteries included systems which are powerful and highly configurable? Needs an artificially restricted problem domain whose problem can be solved correct and exhaustively.
  - If an object may not perform blocking operations, it has to become (explicitly or implicitly)  a state machine.
  - Don't use global state in libraries. They might be instantiated more than once... Instead, let the user hold the context with user data.
  - Map reduce helps with 'late binding'. Dump everything into a log file. Decide what to do with it afterwards. Extract what you want using a brute force computation
  - Solid principles, component principle?
  - list of useful diagrams and when to use them (dfd, Feature, fmc,...)?


