# Programming

_"programming - its like Lego without gravity"_


## Common Principles
* Think hard before you start. 
* Focus. Eliminate distractions and obstacles. If you cannot stay within _the flow_, you are doing something wrong.
* _Make it_, _make it run_ (so that the tests pass), _make it better_ (review and refactor until you can honestly say that it is good enough)
* If in doubt, leave it out (abstractions, features, ...), because _you ain't gonna need it (YAGNI)!_ You can always come back later. Don't waste your time now.

## Object-oriented Programming
* Object-oriented programming is means to a particular end: hide (encapsulate) complexity behind simple, well-defined interfaces.
* Ideally, state is so well encapsulate that objects just communicate via messages ("do this, do that" instead of "give me foo and bar"). When you introduce setters and getter, you turn an object back into a data structure. While data structures are objects, not every object should act like a data structure.
* Computers process _data_. Therefore, when designing your application, start with the _data_ and not with what _you think_ should be an object (e.g., don't just introduce a _Tree_ class because it seems plausible). Think about what you want to do with the data and then try to envision suitable interfaces to work with the data (i.e., supporting batch processing). If possible, encapsulate the data behind the envisioned interface so that it cannot leak out. Congratulations, you've just created yourself an object (probably you ended up with a _Forest_)
	- So yes, the _everything is an object_ mantra holds. You just have to stop at one level so that you keep a decent amount of implementation freedom (parallelization, memory efficient representation...).
	- Doing this wrong, you end up with the problem of most OR-mappers: Individual objects that are no longer suitable for the mass operations you want to perform (i.e., creating all tree objects and iteration over them to set an attribute, instead of just firing a single update query against the database). 

## Design-Process
* Start a project glossary of all the terms of the domain
* Early on, think about how to propagate meaningful exceptions. You need to provide context. It is required so that the exceptions can be understood and the root cause be corrected.

## Testing
* Look for _inflection points_ as the sweet spot between testing effort and covered functionality.

## Debugging
* Again, think before you start. Relax, breath and fetch your favorite beverage. Find the bug in your head. Only then start the debugger, if at all!
* Debugging is not a reason to stay overtime. Document your thought process so that you know where to pick up the next day.
* If stuck, describe your problem to an (imaginary) colleague. 
* Dig until you have found the root cause. If you are inclined to just add a `null` check, you haven't found it yet.

## Profiling
* Well, do it. Then read on.
* Often profiling boils down to one thing: You are doing to much!
* When facing memory problems, investigate the _overhead of representation_ vs _the real data_ (see [Memory Efficient Java Applications](http://www.cs.virginia.edu/kim/publicity/pldi09tutorials/memory-efficient-java-tutorial.pdf))
