# Programming

_"programming - playing Lego in a world without gravity"_

* _Make it_, _make it run_ (so that the tests pass), _make it better_ (review and refactor until you can honestly say that it is good enough)

* Focus. Eliminate distractions and obstacles. If you cannot stay within _the flow_, you are doing something wrong. Know your editor, your programming language, etc.

* You need a consistent elevator pitch for your project. It has to capture what the software is meant to solve. Write it down, so that the vision and inherint properties of your project are never forgotten.


## Testing

* Tests are essential. Without them, you will fear change and so the code will rot. With good tests, there’s no fear, so you’ll clean the code.

* Unit Tests to test all paths and cases. Integration tests to test the plumbing of components. The later focus only on the happy path and obvious corner cases.

* The existence of tests helps with debugging as you know that certain components work, i.e. the bug cannot be within them.

* Unforutnatenly, tests are not only an asset but also a liability. Look for _inflection points_ as the sweet spot between testing effort and covered functionality.

    - Test at the coarsest level of granularity at which you can test your branches with confidence. For example, consider a class that can be serialized and deserialized. A round-trip test may be sufficient, instead of testing both directions individually.
    - Don't test clue code using unittests (and maybe even mocks). Only test stuff with behaviour and complexity worth testing.

- Even if you have good tests, don't be afraid to add assertions to your code. Tests are only anecdotal evindence. Assertions test functions also in their scaffolding, when we move from unit tests to component/integration tests, and even in production when all bets are off. The main idea is that it is always better to crash early. Examples:

    - Constructor argument checks using `java.util.Objects.requireNonNull` to prevent subsequent `NullPointerExceptions` long after object instantiation.
    - `assert` statements in algorithms to check pre-conditions, post-conditions, and loop invariants.


## Debugging

* Again, think before you start. Relax, breath and fetch your favorite beverage. Find the bug in your head. Only then start the debugger, if at all.

* Debugging is not a reason to stay overtime. Document your thought process so that you know where to pick up the next day.

* If stuck, describe your problem to an (imaginary) colleague or your favorite rubber duck.

* Dig until you have found the root cause. If you are inclined to just add a `null` check, then you haven't found it yet.


## Profiling

* On a 1GHz CPU, with the reasonable assumption of 1 instruction per clock-cycle, 100ms correspond to 100 million instructions. If done somewhat efficient, such an instruction count should allow us to process lots of data. If this isn't the case, then the application does need some tuning.

* Only start optimizing after you have pinpointed the bottleneck using profiling. This is just a way of saying: Make the common case fast, and the corner cases correct.

* When facing memory problems, investigate the _overhead of representation_ vs _the real data_ (see [Memory Efficient Java Applications](http://www.cs.virginia.edu/kim/publicity/pldi09tutorials/memory-efficient-java-tutorial.pdf))


## Teaching Programming

* Programming goes back to flow charts ("You do this. If this then you do that, if not you do that")
