# Unstructured Inbox

This is a staging area for stuff that might be added in the future.

Sometimes stuff seems super important, but reads pretty boring 2 months later. If this is the case, we should drop it.


## Reliability

Without doubt, there is a connection between what a webshop is doing to what has been done in the embedded system community

* Embedded Systems
  - safety and reliability patterns:
    + protected single channel / sanity check (no redundancy, but we validate that we computed something useful using data validation...e.g., crc. very similar to monitoring. helps with transient failures)
    + homogenous redundancy (against random faults but not systematic ones),
    + tripple modular redundancy (similar to homogenous, but prevent restarts of the homogenous one),
    + heterogeneous redundancy,


## Algorithms & Data Structures

* Algorithms
  - Find th esimplest form of the problem. It makes it easier to solve than the general case.
  - Optimize the critical path.
  - Lock free vs wait free concurrency control... No kernel involved in lock free algo (eg mutex or semaphore) but just atomic CPU operations.. To make lock free algos fast, you probably need batching
  - When tuning, there often is not a single optimal solution. Different solutions may be good for different sub classes of the problem (eg passing around large vs small messages with a given allocation cost and pre allocated buffers for small messages)
  - Implement batching on the top most stack level. Disable it on lower levels as it will only increase latency.
  - sanders parallels keynote:
    + Design algorithms to be message passing. You gain the flexibility to implement it on shared memory if mneeded
    + when latency matters, throw all PEs on at it even when the algo is inefficient (i.e., bad speedup) -> everything counts as long as you can reduce latency
    + don't dismiss analyis in practice --> you probably know wether it will work before you try it.
    +  a properly chosen algorithms zerfällt mit glück wieder zu embarissingly parallel subalgos
  - Algorithm usages:
    + Get an unserstanding where and what for certain stuff is used. Should be specific enough to understand. For example: what are euler tour and list ranking used for?
  - Proper description / intuition needed for:
    + Tricks with virtual memory
      * allocate too much (Wassenberg' Trick) and then rely on page faults
      * realloc trick (reorder packges instead of copying stuff)
    + Quickselect as a generalization of binary search (probing method, decision on which side to continue, ...)
    + 'Universe Representation' as a new design technique: Represent a dense set(!) over a finite domain by noting its existance in the universe. Is an alternative to representing/storing individual elements. Used by bitmaps, van-emde boas trees. Then often comes with optimization to reduce space requirements.
    + Divide and Conquer as a general solution strategy (we can throw it at almost any problem...)
  - Programming by Contract: Pre and post conditions. Loop invariants holding the truth in between: Shown at init time. Then, via mathematical induction shown that it is true also at the end. Assertion showing these invariants are more than just test. Tests are only andecdotal evindence. Assertions test functions also in their scaffolding, when we move from unit tests to component/integration tests. Disabling assertions is like a sailor without a life west (Source: Programming Pearls, Maybe see for more: http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=1203056)


* Nice data structures probably worth covering
  - _Union-find Data structure:_ Commonly used to find cycles and connected components within graphs.
  - _Wavelet Trees:_ TODO
  - _Tournament Trees / Loser Trees_ for _k-way_-merging of large data sets (assuming a large _k_ such as 256)
  - _2D Min Heaps:_ TODO
  - _RMQ & LCA:_ TODO


## Design Ideas

  - If an object may not perform blocking operations, it has to become (explicitly or implicitly) a state machine. If you have the choice, make this state machine explicit.
  - Map reduce helps with 'late binding'. Dump everything into a log file. Decide what to do with it afterwards. Extract what you want using a brute force computation
  - Code as Data: Move special-casing from code (in form of if-else conditions) to data (e.g., table lookups, polymorphic calls (which are also just table lookups using the object type as key))
  - Software engineering is about separating the 'what' from the 'how'.
  - Software muss am Ende einer Story so aussehen wie als wäre es von Anfang an so gedacht. Nicht nur so aussehen weil das Feature zu einem bestimmten Zeitpunkt implementiert habe (e.g. weil dann klasse X schon da war und ich mein feature einfach dran flanschen konnte).
  - No is temporary, Yes is forever. If you're not sure about a new feature, say no. You can change your mind later
  - Clean architecutre: Functional core, imperative shell. Core has no i/o, no deps, but lots of branches.... Procedure part has boring execution path as logic remains elsewhere. Core should be reusable, shell is probably less reusable but that is OK.
* Architecture and design: should be stateless... You should not see its history... As if designed from scratch today


* Operations / Debugging:
  - Finding a single root cause is not enough. If a problem 'escaped' or 'jumped' different layers, then you need a fix on all of them!

* State
  - If you need state, keep it separate. See out of the tar pit paper.
  - there is essential (existential) state and non-essential state. Good example on when you have non-essential state: graph + job queue. You only need the graph and a function on the graph. the job queue itself is not necessary and only some unnecessary additional state. So, even though you got well-tested modules you don't have an ideal design.
  - external naming: don't enforce a user to remember a UUID for something he creates using ur API. He would need state to store it. Let him tell you the he name somehow, instead..
  - data has mass. "trägheit" making it difficult to juggle it around. the more you have the more difficult it gets.

* Standardization
  - tighter iteration cycles ar eproductivity multipliers. Fast iterations ylield non-linear value incerase.
  - When you have high marginal cost, people will not experiment
  - standardized tooling has unexpected multiplicative effects

* Testing
  - Goal: give a non changing interface, I want to change the implementation of a class or any of the internal methos withoug having to change the test (no whitebox mocking).
  - Mock objects tell you what you want to hear. But what about the mocked interface? Is it still the same? Write tests to the interface. not to the implementation.
  - Only mock the expensive stuff (not everything you could).
  - For mcoked stuff, have one well tested mock. Share it with users of your library/code. "Fakes": full felshed in-memory implementation of the thing you want to test.
  - Don't test glue code. Test behaviourl interesting suuff. If you tested the extracted function, no need to test the instance method callig it...
  - Don't write tests where there is no clear interface to test.

* multi-threaded programming:
  - when you launch one, be sure how errors are handled for that thread: logging and application tear down are probably a must. a dead thread is no use for anyone.


# Abstractions

* Abstractions that are helpful are the ones that significantly reduce complexity.
* The quality of abstraction is in the weakest link.
* Duplication is better than the wrong abstraction. It is easer to deal with duplicated code than with a bad, unclear, leaky abstraction. Therefore, only introduce abstractions once their boundaries are clear.


# Scalability

there are different aspects of "scale"

* machine / hosts / data sizes
* organizational scalability (multi-user friendly, users can troubleshoot on their own, intern cannot wrack the side, etc)
* scalability of the code base (add new features without any major refactoring, have multiple people working on it without stepping on their toes)
* investment scale


# Sys design

* A platform centralizes mistakes (and their corrections)
* Most engineering time is spend debugging. Most time spend debugging is looking for information. Most time looking for information is spend due to unfamiliia of the code/system. This can be solved on various layers. In particular, a consistent tool approach is helping here..
* Tighter iteration cycles are productivity multipliers. If yo have high marginal cost, peoople don't experiment. They will not do the high risk high reward projects but the low risk low reward tasks/stories/projects.
* In summary: standardizes tooling has unexpected (positive) multiplicative effects.
* OH on unbounded queues, implicit/explicit limits—"same way someone could claim they know when to stop drinking b/c they eventually pass out"

# Software Engineering Socials

* When writing code you get Stockholm syndrome all the time
* The Peter principle applies to software as well: Peter Principle, the idea that in an organization where promotion is based on achievement, success, and merit, that organization's members will eventually be promoted beyond their level of ability. The principle is commonly phrased, "Employees tend to rise to their level of incompetence." Applying the principle to software


# SWE X-ities

* security
* scalability
* resilience (and graceful degradation)
* availability
* maintainability
* operatability (incl instrumentation and visibility)
* simplicity in design of complex systems,


# Principles

* Single Responsibility Principle
    - as of Robert C. Martin: 'one reason to change'
    - as of Markus Klein: 'knowledge of just one thing'
* DRY:  If it's domain logic, like calculating the total for a shopping cart then you gotta follow DRY. The risk of application inconsistencies are too high. But if it's anything else then I go with KISS. I really think DRY is far more important for business logic than it is for infrastructure logic. If you calculate what taxes someone owes in two different ways that's terrible. If you serialize two different things in your application in two different ways, probably doesn't matter.


# requirements

business requirements only diverge, they never converge. That's why you should not try too hard to squeeze everything into your framework or architecture etc. It will not get better



