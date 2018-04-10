# Unstructured Inbox

This is a staging area for stuff that might be added in the future.

Sometimes stuff seems super important, but reads pretty boring 2 months later. If this is the case, we should drop it.


## Algorithms & Data Structures

* Implement batching on the top most stack level. Disable it on lower levels as it will only increase latency.

* Proper description needed for:

  + Tricks with virtual memory
    * allocate too much (Wassenberg' Trick) and then rely on page faults
    * realloc trick (reorder packges instead of copying stuff)

  + generic binary search idea rather than the simple 'search on a sorted list'


## Design Ideas

  - If an object may not perform blocking operations, it has to become (explicitly or implicitly) a state machine. If you have the choice, make this state machine explicit.

  - Map reduce helps with 'late binding'. Dump everything into a log file. Decide what to do with it afterwards. Extract what you want using a brute force computation

  - Code as Data: Move special-casing from code (in form of if-else conditions) to data (e.g., table lookups, polymorphic calls (which are also just table lookups using the object type as key))

  - Software engineering is about separating the 'what' from the 'how'.

  - Software muss am Ende einer Story so aussehen wie als wäre es von Anfang an so gedacht. Nicht nur so aussehen weil das Feature zu einem bestimmten Zeitpunkt implementiert habe (e.g. weil dann klasse X schon da war und ich mein feature einfach dran flanschen konnte).

  - Finding a single root cause is not enough. If a problem 'escaped' or 'jumped' different layers, then you need a fix on all of them!

  - If you need state, keep it separate. See out of the tar pit paper.

  - there is essential (existential) state and non-essential state. Good example on when you have non-essential state: graph + job queue. You only need the graph and a function on the graph. the job queue itself is not necessary and only some unnecessary additional state. So, even though you got well-tested modules you don't have an ideal design.

  - external naming: don't enforce a user to remember a UUID for something he creates using ur API. He would need state to store it. Let him tell you the he name somehow, instead..

  - data has mass. "trägheit" making it difficult to juggle it around. the more you have the more difficult it gets.

  - tighter iteration cycles ar eproductivity multipliers. Fast iterations ylield non-linear value incerase. When you have high marginal cost, people will not experiment


## Testing

  - Goal: give a non changing interface, I want to change the implementation of a class or any of the internal methos withoug having to change the test (no whitebox mocking).

  - Be afraid of mocks. Mock objects tell you what you want to hear. But what about the mocked interface? Is it still the same? Even if it is, can I still refactor my implementation without having to touch the test? TLDR: Write tests to the interface. not to the implementation.

  - For mcoked stuff, have one well tested mock. Share it with users of your library/code. "Fakes": full felshed in-memory implementation of the thing you want to test.

  - Don't write tests where there is no clear interface to test.


## Robustness

  - when you launch a thread, be sure how errors are handled for that thread: logging and application tear down are probably a must. a dead thread is no use for anyone.

  - OH on unbounded queues, implicit/explicit limits—"same way someone could claim they know when to stop drinking b/c they eventually pass out"


## Abstractions

* The quality of abstraction is in the weakest link.

* Duplication is better than the wrong abstraction. It is easer to deal with duplicated code than with a bad, unclear, leaky abstraction. Therefore, only introduce abstractions once their boundaries are clear.


## Scalability

there are different aspects of "scale"

* machine / hosts / data sizes
* organizational scalability (multi-user friendly, users can troubleshoot on their own, intern cannot wrack the side, etc)
* scalability of the code base (add new features without any major refactoring, have multiple people working on it without stepping on their toes)
* investment scale


## Principles

* Single Responsibility Principle
    - as of Robert C. Martin: 'one reason to change'
    - as of Markus Klein: 'knowledge of just one thing'

* DRY:  If it's domain logic, like calculating the total for a shopping cart then you gotta follow DRY. The risk of application inconsistencies are too high. But if it's anything else then I go with KISS. I really think DRY is far more important for business logic than it is for infrastructure logic. If you calculate what taxes someone owes in two different ways that's terrible. If you serialize two different things in your application in two different ways, probably doesn't matter.

