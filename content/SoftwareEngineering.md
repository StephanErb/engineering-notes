# Software Engineering

There is no right solution to design software as it is all about tradeoffs. In any case we hope to capture some guiding principles here.


## Axioms of Engineering

as put by @dmontauk:

* Most engineering time is spend debugging
* Mot time spend debugging is looking for information
* Most time looking for information is spend due to unfamilarity with the code/system

If put into a broader context we can deduce:

 * Engineers spend lot of time debugging because they don't understand their systems
 * Understanding is killed by complexity
 * More code (often) means more complexity
 * We therefore have to achive more with less (code)
 * The end-to-end argument as explained below can help to achieve this

See https://www.youtube.com/watch?v=pee-e01DiyI for more details.


## Simplicity

* Don't quest for simplicity. This has no clear definition. Quest for elegant minimalism instead.

* At the end of the day, our job is to keep agility and stability in balance in the system. Minimalism helps to achieve this.

* Software systems (usually) doesn't fall down because of a lack of flexibility. They fall down because it becomes nearly impossible to reason about the system as it becomes more complex. Therefore, put emphasis on reducing complexity, instead of increasing flexibility. (Source?). This implies:

    - Simplicity is a quality that once lost, can be extraordinarily difficult to recapture
    - Simplicity is a prerequisite for reliability as building reliable/robust/resiliant systems requires you to understand and anticipate how they will fail

*  _Achive more with less_ and be like Modern Talking: million of sold records just based on four chords. Don't have 3 different reverse proxies, 5 key values stores, and 2 different databases deployed if one of each would be sufficient.

* If in doubt, leave things out (abstractions, features, ...), because _you ain't gonna need it (YAGNI)_. You can always come back later, so don't waste your time now. In other words: no is temporary, but yes is forvever.

* Complexity does not directly come from code itself, but from the implicit _assumptions_ that it makes (e.g. necessary system libs, how something is used, what distribution of the input looks like, etc). If a new feature does not add new assumptions then it won't cause you that much trouble down the road.


## Architecture and Design

* "A software architecture captures design decisions which are hard to revert or which have to be made early" - Ralf Reussner

* Software lives longer than hardware. Data lives longer than software. Plan and design accordingly:

    - Do not rely on a fixed number of threads but scale with the available cores.
    - Prefer explicit schemas to manage your persistent data (Note: there is an _implicit_ schema in schemaless storage and it will bite you, e.g., the assumption how certain keys are called).

* Design is an _art, not a science_. People writing books on software design have a vested interest in making it seem scientific. Don't become dogmatic about particular design styles. [Source ?]


### System Design

 * Always think [End-To-End](http://web.mit.edu/Saltzer/www/publications/endtoend/endtoend.pdf): Don't eagerly start to implement stuff at lower-levels when you have not understood the bigger picture. In many cases, you'll need to do it upper in the stack anyway. Implementations on lower levels are only useful as a performance improvement. Examples:

    - ISO/OSI stack has checksums and retransmissions on multiple levels. Even though they exist, a user is still responsible to implement the same thing again.
    - Transactions, versioning, immutability suffer a similar fate.

* When designing an application or system, consider the following items in the given order as initially proposed by Markus Klein. This increases the changes of good design significantly:

    - __essential state__

         + i.e. as defined in the "Out of the Tar Pit" paper
         + to reduce complexity we want to keep the data as pure and as normalized as possible. This also helps in the future as essential data tends to live longer than software and hardware

    - __dataflow and central algorithms__

         + i.e. what happens with the data
         + this sets the context data sources and data transformations as well as inherent concurrency

    - __control flow__

         + i.e. who or what is performing the steering
         + often less critical than commonly anticipated once the above is settled

    - __module boundaries__

         + doing this at the end ensures we don't settle for a less optimal solution regarding our essential state
         + unfortunately most of the time this happens implicity due to _Conway's Law_ (see below) or other accidental structures like the current (multi-)repository layout.


### Design Principles

Remember GoF book and the design patterns rage? Be sure you are not part of the next one! So, don't get entagled in the current hype of _practices_ (TDD, continous delivery, ...). The underlying _principles_ are the one that truely matter.

There is a vast set fo design principles promoted by practicitioners (e.g., see [Clean Code Developer](http://www.clean-code-developer.de/)). The difficult part is applying these principles properly.


### Object-oriented Design

* Object-orientation is means to a particular end: hide (encapsulate) complexity behind simple, well-defined interfaces.

* Ideally, state is so well encapsulate that objects just communicate via messages ("do this, do that" instead of "give me foo and bar"). No surprise, calling a method was _sending a message_ in Smalltalk.

* When you introduce setters and getter, you turn an object back into a data structure. While data structures are objects in many languages (e.g. Java), not every object should act like a data structure.

* Use a class when you have an invariant to protect (e.g. you cannot change day and months separately as 31.02 will give an invalid date). Use freeform functions over structs if there are no invariants to protect (e.g., change name + firstname independently).

* Classes and objects are a technical concept. Don't confuse those with your _domain model_ (i.e., your entities, your essential state). There are probaly only a few entities in your domain. Everthing built around it is boilerplate that should be limited to a minimum.

* When specifying interfaces of your entities, think about what you want to do with the data and how you plan to process it (e.g., enforcing invariants, supporting batch processing). If possible, encapsulate the data so that it cannot leak out. If done properly, you will get a decent amount of implementation freedom (parallelization possibilities, memory efficient representation...).

* Design example:

    - When representing a graph, one is not forced to make nodes and edges objects on their own. Instead, a node can become a simple integer and edge information can be encoded in a data structure such as an [adjacency array](http://www.mpi-inf.mpg.de/~mehlhorn/ftp/Toolbox/GraphRep.pdf). Such a data structure is highly memory efficient.

    - To truly encapsulate the state of an object, we could add methods describing how to represent it in log files or write and read from disk. Even though the object now has multiple responsabilities and requires more knowledge, any changes do these details are local to the corresponding class. Of course, we might use more modular design _within_ the object and delegate the implementation details to helpers.


## Security

Securing a system is tough. It requires a process and continous work rather than one-off efforts. The following guiding principles help in any case to ensure your "security debt" does not get too overwhelming:

* Practice defense in depth. Security needs happen on all layers. For example, even if you are behind a corporate firewall, you still need to secure your applications.

* Follow the principle of least privilege. Every person or technical system should should only have the permissions, credentials, etc that they need to function.


## Important Laws & Conditions

* __Lehman's Laws of Software Evolution__
    - a) Systems must continually be adapted to the changing environment, otherwise they become progressively more useless (e.g., new hardware, compiler, tax rule). A Healthy System churns. An Unhealthy system is additive-only.
    - b) Accidental and essential complexity grows as a system is evolved. A deliberate investment is needed to keep system structured and simple.
    - So there is somewhat a trap: We have to evolve, but evolving will degenerate quality due to pressure and ignorance.

* __Conway's Law__
    - Organizations designing systems are constrained to produce designs which are copies of the communication structures of these organizations.
    - The interface structure of a software system will reflect the social structure of the organization that produced it

* __Spolsky's Law of Leaky Abstractions__
    - [All non-trivial abstractions, to some degree, are leaky](http://www.joelonsoftware.com/articles/LeakyAbstractions.html) (e.g., performance in SQL, reliability in the TCP/IP stack, garbage collection, distributed shared memory (NUMA))
    - Abstractions save us time working, but they don't save us time learning, because when (not if) leaks occure you need to know how to deal with them.

* __Little's Law__
    - The average number of things in a system is the product of the average rate of which things leave (or enter) the system and the average time each spends in the system: `avg_elements_in_system = avg_arrival_rate * avg_duration_in_system`
    - Can be used as a formula to compute properties of any queuing system (e.g waiting duration in front of a club).

* __Stockholm Syndrome__
    - A condition that causes hostages to develop a psychological alliance with their captors as a survival strategy during captivity
    - In other words: A programmer that has been working with his legacy system for so long that he has lost his edge. He is content with system and its quirks even though he shouldn't. This appears to be a form of sunk cost fallacy.

* __Peter Principle__
    - The idea that in an organization where promotion is based on success and merit members will eventually be promoted beyond their level of ability. The principle is commonly phrased: "Employees tend to rise to their level of incompetence."
    - The same applies to software: If you have a successful piece of software and somebody has a feature wish that is even just slightly related, he will want to see it implemented in your software. In short, he wants his feature to be successful as well. This cycle continues until your software is slow, bloated, and buggy.


## Quotes

* Martin Fowler in UML Distilled
    - "One of my biggest irritations is how organizations consistently fail to learn from their own experience and end up making expensive mistakes time and time again."
