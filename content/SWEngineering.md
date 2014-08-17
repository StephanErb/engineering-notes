# Software Engineering


## On Architecture and Design

* "A software architecture captures design decisions which are hard to revert or which have to be made early"
* Software lives longer than hardware. Data lives longer than software. Plan and design accordingly:

    - Do not rely on a fixed number of threads but scale with the available cores
    - Prefer explicit schemas to manage your persistent data (Note: there is an _implicit_ schema in schemaless storage and it will bite you, e.g., the assumption how certain keys are called)

* Software systems (usually) doesn't fall down because of a lack of flexibility. They fall down because it becomes nearly impossible to reason about the system as it becomes more complex. Therefore, put emphasis on reducing complexity, instead of increasing flexibility. (Source?)
* Be like Modern Talking; _achive more with less_ (i.e., million of sold records just based on four chords). So, if in doubt, leave it out (abstractions, features, ...), because _you ain't gonna need it (YAGNI)!_ You can always come back later. Don't waste your time now.
* Design is an _art, not a science_. People writing books on software design have a vested interest in making it seem scientific. Don't become dogmatic about particular design styles. [Source ?]




## Software Design

* Operating in a difficult domain (e.g., compilers, language workbenches, ...) does not mean software design is less important. You still need to talk about stuff like how to propagate errors, exception, livetime of objects, who is repsonsible for what... Once you broke down your problem into pieces, it won't be difficult any more and you can attack it.



### Design Principles

There is a vast set fo design principles promoted by practicitioners (e.g., see see [Clean Code Developer](http://www.clean-code-developer.de/)). The difficult part is applying these principles properly. We hope to gather some personal insights here... (TODO).

TODO: If I am not totally mistaken, many principles are well described within SICP.

* Single Level of Abstraction
* Single Responsibility principle
    - as of Markus Klein: 'know just one thing'
    - as of Robert C. Martin: 'one reason to change'



### Object-oriented Design

* Object-orientation is means to a particular end: hide (encapsulate) complexity behind simple, well-defined interfaces.
* Ideally, state is so well encapsulate that objects just communicate via messages ("do this, do that" instead of "give me foo and bar"). When you introduce setters and getter, you turn an object back into a data structure. While data structures are objects, not every object should act like a data structure.
* Objects are technical entities. Don't confuse your _domain model_ (i.e., your _data_, your _entities_) with your _object model_. There are probaly only a few entities in your domain. Everthing built around it is boilerplate that should be limited to a minimum.
* When designing your application, start with the _data_ and not with what _you think_ should be an object (e.g., don't just introduce a _Tree_ class because it seems plausible).  Once you identified the entities in your domain, you can define interfaces and _only afterwards_ think about objects and which objects knows what.
* When specifying interfaces of your entities, think about what you want to do with the data and how plan to process it (e.g., supporting batch processing). If possible, encapsulate the data behind the envisioned interface so that it cannot leak out. Congratulations, you've just created yourself an object.

    - The _everything is an object_ mantra holds. You just have to stop at one level so that you keep a decent amount of implementation freedom (parallelization, memory efficient representation...).
    - Doing this wrong, you might end up with the problem of most OR-mappers: Individual objects that are no longer suitable for the operations you want to perform (e.g., creatig many objects and iterating over them to set an attribute, instead of just firing a single update query against the database to perform a mass-update).
    - No surprise, calling a method was _sending a message_ in Smalltalk.

* Design example:
    - When representing a graph, one is not forced to make nodes and edges objects on their own. Instead, a node can become a simple integer and edge information can be encoded in a data structure such as an [adjacency array](http://www.mpi-inf.mpg.de/~mehlhorn/ftp/Toolbox/GraphRep.pdf). Such a data structure is highly memory efficient.
    - To truly encapsulate the state of an object, we can add methods describing how to represent it in log files or write and read from disk. Even though the object now has multiple responsabilities and requires more knowledge, any changes do these details are local to the corresponding class. Of course, we might use more modular design _within_ the object and delegate the implementation details to helpers.




## Programming

_"programming - playing Lego in a world without gravity"_

* Focus. Eliminate distractions and obstacles. If you cannot stay within _the flow_, you are doing something wrong. (know your editor, ...)
* _Make it_, _make it run_ (so that the tests pass), _make it better_ (review and refactor until you can honestly say that it is good enough)
* Remember GoF book and the design patterns rage? Be sure you are not part of the next one! So, don't get entagled in the current hype of _practices_ (TDD, continous delivery, ...). The underlying _principles_ are the one that truely matter.


### Testing
* Unit Tests to test all paths and cases. Integration tests to test the plumbing of components. Component Tests as acceptance tests which just test the happy path and obvious corner cases.
* Tests are not only an asset but also a liability. Sometimes it might be enough to stop writing tests at a level where you can test everything below this level, i.e., test at the coarsest level of granularity at which you can test all branches with confidence. For example, consider a class that can be serialized and deserialized. A round-trip test may be sufficient, instead of testing both directions individually.
* But does every test help? And does every code need to be automatically tested? Probably not.
* The existence of tests helps with debugging, as you know that certain components work, i.e. the bug cannot be within them.
* When writing tests for legacy code, look for _inflection points_ as the sweet spot between testing effort and covered functionality.
* Quality is a function of thought and reflection - precise thought and reflection. That's the magic. Techniques which reinforce that discipline (such as testing) invariably increase quality. -- [Michael Featheres](http://michaelfeathers.typepad.com/michael_feathers_blog/2008/06/the-flawed-theo.html)


### Debugging
* Again, think before you start. Relax, breath and fetch your favorite beverage. Find the bug in your head. Only then start the debugger, if at all.
* First ask: 'What do I see? Where can I observe a problem? Once you have clarified this, ask 'Why?' until you found the problem.
* Debugging is not a reason to stay overtime. Document your thought process so that you know where to pick up the next day.
* If stuck, describe your problem to an (imaginary) colleague or your favorite rubber duck.
* Dig until you have found the root cause. If you are inclined to just add a `null` check, then you haven't found it yet.


### Profiling
On a 1GHz CPU, with the reasonable assumption of 1 instruction per clock-cycle, 100ms correspond to 100 million instructions. If done somewhat efficient, such an instruction count should allow us to process lots of data. If this isn't the case, then the application does need some tuning.

* Well, do it. Then read on.
* Often profiling boils down to one thing: You are doing to much!
* When facing memory problems, investigate the _overhead of representation_ vs _the real data_ (see [Memory Efficient Java Applications](http://www.cs.virginia.edu/kim/publicity/pldi09tutorials/memory-efficient-java-tutorial.pdf))


### Teaching
* Programming goes back to flow charts ("You do this. If this then you do that, if not you do that")




## Dealing with the outer world
* You need a consistent elevator pitch for your project. It has to capture what the software is meant to solve. Write it down, so that the vision and inherint properties of your project are never forgotten.
* When saying yes, use the language of commitment, so there is no doubt what you have promised.
* As professionals, we are also expected to say no. Not to our family, but to our management and our customers. _Trying_ to achieve a goal in time is probably lying.
* After important discussions. Type memos and send them to the other party. It will save your ass
* If something is not going as expected, you are responsible to raise a red flag to all stake holders. Do it in time. Take responsability.




## Laws to know about

* _Lehman's Laws of Software Evolution_
    - Continuing Change: Systems must continually be adapted to the changing environment, otherwise they become progressively more useless (e.g., new hardware, compiler, tax rule)
    - Increasing Complexity: Accidental and essential complexity grows as a system is evolved. An investment is needed to keep system structured and simple.
    - So there is somewhat a trap: We have to evolve, but evolving will degenerate quality due to pressure and ignorance.

* _Conway's Law_
    - Organizations designing systems are constrained to produce designs which are copies of the communication structures of these organizations
    - The interface structure of a software system will reflect the social structure of the organization that produced it

* _Spolsky's Law of Leaky Abstractions_
    - [All non-trivial abstractions, to some degree, are leaky](http://www.joelonsoftware.com/articles/LeakyAbstractions.html) (e.g., performance in SQL, reliability in the TCP/IP stack, garbage collection, distributed shared memory (NUMA))
    - Abstractions save us time working, but they don't save us time learning, because when (not if) leaks occure you need to know how to deal with them.

* _Little's Law_
    - The average number of things in a system is the product of the average rate of which things leave (or enter) the system and the average time each spends in the system.
    - Can be used as a formula to compute properties of any queuing system (aka umstellen, einsetzen, freuen)

* _Gordon Bell_
    - The cheapest, fastest and most reliable components of a computer system are those that aren't there
