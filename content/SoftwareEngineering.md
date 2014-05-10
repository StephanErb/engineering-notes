


* If in doubt, leave it out (abstractions, features, ...), because _you ain't gonna need it (YAGNI)!_ You can always come back later. Don't waste your time now.


On Architecture:
* Be like Modern Talking; achive more with less (i.e., million of sold records just based on four chords)


On Designing:
* Think hard before you start.


## Dealing with the outer world
* When saying yes, use the language of commitment, so there is no doubt what you have promised.
* As professionals, we are also expected to say no. Not to our family, but to our management and our customers. _Trying_ to achieve a goal in time is probably lying.
* After important discussions. Type memos and send them to the other Party. It can save your Ass
* If something is not going as expected, you are responsible to raise a red flag to all stake holders. Do it in time. Take responsability.


## Design-Process
* Start a project glossary of all the terms of the domain
* Early on, think about how to propagate meaningful exceptions. You need to provide context. It is required so that the exceptions can be understood and the root cause be corrected.
* Design is an *art*, not a science. People writing books on software design have a vested interest in making it seem scientific. Don't become dogmatic about particular design styles. [by spolosky on leaky abstractions ???]


* Don't get entagled in the current hype of practices (TDD, contnious delivery, ...) . The underlying principles are the one that truely matter.


# Desigining Abstractions

* Single Level of Abstraction
* Single Responsibility principle
    - as of Markus Klein: 'know just one thing'
    - as of Robert C. Martin: 'one reason to change'
* Separation of Concerns
* Interface Segragation Principle
    - NVI (Non-Virtual-Interface) is somewhat also interface segragation. We separate the implementation from the usage side of the interface.
* Liskov Substitution Principle
* Open Closed Principle
* Law of Demeter

If I am not totally mistaken, these principles are well described within SICP.



## Object-oriented Design
* Object-orientation is means to a particular end: hide (encapsulate) complexity behind simple, well-defined interfaces.
* Ideally, state is so well encapsulate that objects just communicate via messages ("do this, do that" instead of "give me foo and bar"). When you introduce setters and getter, you turn an object back into a data structure. While data structures are objects, not every object should act like a data structure.
* Objects are technical entities. Don't confuse your _domain model_ (i.e., your _data_) with your _object model_. There are probaly only a few entities in your domain. Everthing built around it is boilerplate that should be limited to a minimum.
* When designing your application, start with the _data_ and not with what _you think_ should be an object (e.g., don't just introduce a _Tree_ class because it seems plausible). Think about what you want to do with the data and then try to envision suitable interfaces to work with the data (e.g., supporting batch processing). If possible, encapsulate the data behind the envisioned interface so that it cannot leak out. Congratulations, you've just created yourself an object (probably you ended up with a _Forest_)

    - So yes, the _everything is an object_ mantra holds. You just have to stop at one level so that you keep a decent amount of implementation freedom (parallelization, memory efficient representation...).
    - Doing this wrong, you might end up with the problem of most OR-mappers: Individual objects that are no longer suitable for the operations you want to perform (e.g., creatig many objects and iterating over them to set an attribute, instead of just firing a single update query against the database to perform a mass-update).
    - No surprise, calling a method was _sending a message_ in Smalltalk.

* Design example:
    - When representing a graph, one is not forced to make nodes and edges objects on their own. Instead, a node can become a simple integer and edge information can be encoded in a data structure such as an [adjacency array](http://www.mpi-inf.mpg.de/~mehlhorn/ftp/Toolbox/GraphRep.pdf). Such a data structure is highly memory efficient.
    - To truly encapsulate the state of an object, we can add methods describing how to represent it in log files or write and read from disk. Even though the object now has multiple responsabilities and requires more knowledge, any changes do these details are local to the corresponding class. Of course, we might use more modular design _within_ the object and delegate the implementation details to helpers.



# Projects

* You need a consistent elevator pitch for your project. It has to capture what the software is meant to solve. Write it down, so that the vision and inherint properties of your project are never forgotten.


# Components

* KeyValue Stores (e.g., redis)
* Message Queues
  - Used to decouple message producers and consumsers (point-to-point, publish-and-subscribe)
  - Examples:
    + _Advanced Message Queuing Protocol (AMQP)_  as an open standard application layer protocol for message-oriented middleware, including message queuing, routing (point-to-point, publish-and-subscribe), reliability and security.
    + ZeroMQ as a library based solution without centralized servers. Useful for inter- and even in-process communication
* Task Queues
  - specialized message queue used to distribute work across threads or machines
  - master and workers are decoupled so that a flexible numbers of workers that can feed themselves



# Sofware Architecture
