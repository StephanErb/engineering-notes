# Programming

_"programming - playing Lego in a world without gravity"_


## Roots of Programming
* Goes back to flow charts ("You do this. If this then you do that, if not you do that")


## Common Principles
* Focus. Eliminate distractions and obstacles. If you cannot stay within _the flow_, you are doing something wrong. (know your editor, ...)
* _Make it_, _make it run_ (so that the tests pass), _make it better_ (review and refactor until you can honestly say that it is good enough)
*



## Testing
* Unit Tests to test all paths and cases. Integration tests to test the plumbing of components. Component Tests as acceptance tests which just test the happy path and obvious corner cases.
* Tests are not only an asset but also a liability. Sometimes it might be enough to stop writing tests at a level where you can test everything below this level, i.e., test at the coarsest level of granularity at which you can test all branches with confidence. For example, consider a class that can be serialized and deserialized. A round-trip test may be sufficient, instead of testing both directions individually.
* But does every test help? And does every code need to be automatically tested? Probably not.
* The existence of tests helps with debugging, as you know that certain components work, i.e. the bug cannot be within them.
* When writing tests for legacy code, look for _inflection points_ as the sweet spot between testing effort and covered functionality.
* Quality is a function of thought and reflection - precise thought and reflection. That's the magic. Techniques which reinforce that discipline (such as testing) invariably increase quality. -- [Michael Featheres](http://michaelfeathers.typepad.com/michael_feathers_blog/2008/06/the-flawed-theo.html)


## Debugging
* Again, think before you start. Relax, breath and fetch your favorite beverage. Find the bug in your head. Only then start the debugger, if at all.
* Debugging is not a reason to stay overtime. Document your thought process so that you know where to pick up the next day.
* If stuck, describe your problem to an (imaginary) colleague or your favorite rubber duck.
* Dig until you have found the root cause. If you are inclined to just add a `null` check, then you haven't found it yet.


## Profiling
On a 1GHz CPU, with the reasonable assumption of 1 instruction per clock-cycle, 100ms correspond to 100 million instructions. If done somewhat efficient, such an instruction count should allow us to process lots of data. If this isn't the case, then the application does need some tuning.

* Well, do it. Then read on.
* Often profiling boils down to one thing: You are doing to much!
* When facing memory problems, investigate the _overhead of representation_ vs _the real data_ (see [Memory Efficient Java Applications](http://www.cs.virginia.edu/kim/publicity/pldi09tutorials/memory-efficient-java-tutorial.pdf))


