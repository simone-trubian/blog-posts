# Property testing in Haskell with QuickCheck

Automated testing is (hopefully) becoming a normal part of the development workflow, ideally tests should be thought and written even before the actual code as an aid in reasoning about the problem that has to be solved. When the code is written the tests accumulated will help in spotting any broken code when maintaining the codebase. The agile community is especially keen on Test Driven Development (TDD) and Behavioural Driven Development BDD, which are guidelines and tools meant to manage the development workflow and write code "in the large".

However little attention is given to the tool that actually performs the testing, usually falling back to the venerable unit testing paradigm. Unit testing, even in the form of BDD are not bad, but force the developer to come up with the scenarios and usually one runs out of steam after a few cases. A tool that helps addressing this problem is the Haskell library [QuickCheck](https://hackage.haskell.org/package/QuickCheck) that was originally conceived in 2000. Despite this posts focuses on the Haskell implementation the library has now been translated in many other languages including [Erlang](http://www.quviq.com/products/erlang-quickcheck/), [Scala](https://www.scalacheck.org/), [Clojure](https://github.com/clojure/test.check), [Python](https://github.com/DRMacIver/hypothesis) and many more languages.

The core concept with QuickCheck is property-based testing. That is achieved by writing a function that states a property of the function to be tested. The QuickCheck library will then automatically generate data to feed to the function and test that the property holds in all cases.

Testing a property predicate is as easy as passing it to the quickCheck function and let the magic happen.
<pre><code class="haskell">Main> quickCheck propIdem
+++ OK, passed 100 tests.
</code></pre>

Notice that we don't even need to pass an argument to `propIdem`, as the framework takes care of generating the test values autmatically. As default QuickCheck generates 100 values to test the property, if it is verified all the times the test pass, so far so good.

Now let's try writing a wrong function to fail tests, for instance something like
<pre><code class="haskell">sum' :: [Int] -> Int
sum' (x:xs) = x + sum' xs
</code></pre>
is an incomplete implementation of the `sum` function. As far as properties go we know that sums are associative and commutative, so we can translate that in Haskell with
<pre><code class="haskell">propSumAsso :: [Int] -> Bool
propSumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

propSumComm :: [Int] -> Bool
propSumComm xs = sum' xs == sum' (reverse xs)
</code></pre>

As the implementation of `sum'` is incomplete we expect QuickCheck to fail the stests, in fact running them produces similar results in both cases.
<pre><code class="haskell">
*Main> quickCheck propSumAsso
*** Failed! (after 1 test):
Exception:
  Quick.hs:5:1-25: Non-exhaustive patterns in function sum'
[]
</code></pre>
QuickCheck exposed for us a corner case we did not think about: the empty list! We can quickly fix that by adding the missing case `sum [] = 0` and test again, now all tests pass with flying colours.

Sometimes however we might write a correct function but a wrong property, for instance
<pre><code class="haskell">propSumPos :: [Int] -> Bool
propSumPos xs = sum' xs >= 0
</code></pre>
does not hold true in all cases, in fact when we try running it we get this
<pre><code class="haskell">Main> quickCheck propSumPos
** Failed! Falsifiable (after 5 tests and 4 shrinks):
[-1]
</code></pre>
which per se isn't very telling us in helping debug the wrong property. The first thing to do to debug the test is to run QuickCheck in verbose mode, so that we can see what values were generated and what made it fail in the first place.

<pre><code class="haskell">*Main> verboseCheck propSumPos
Passed:
[]
Passed:
[]
Failed:
[1,-2]
*** Failed! Passed:
[]
Failed:
[-2]
Passed:
[]
Passed:
[2]
Passed:
[0]
Failed:
[-1]
Passed:
[]
Passed:
[1]
Passed:
[0]
Falsifiable (after 3 tests and 2 shrinks):
[-1]
</code></pre>
 It is worth at this point spending a few lines on explaining how QuickCheck generates its test cases and runs the tests. First it will try running corner cases for the input data structure (an empty list for lists in this case), and then generate progressively bigger data points. When a counter example is found, QuickCheck will use the `shrink` function to do the opposite of before, that is reduce a large data point in progressively smaller ones. In this case the `[1, -2]` data point fails the property predicate, so QuickCheck shrinks it, if we try ourselves the result is
<pre><code class="haskell">Main> shrink [1, -2]
[[],[-2],[1],[0,-2],[1,2],[1,0],[1,-1]]
</code></pre>
different from the example before but helps explaining that shrink is generating "smaller" examples of the starting data point.

Going back to our failing test, QuickCheck will try providing the smaller possible counter example, which is the reason why it presents as result not the original value [1, -2], but a shrunk version of it [-1]. Knowing this is easy to realise that our property can only hold as long as all values are equal or bigger then 0.

Knowing this we need to find a way to generate only positive numbers for populating the list so that we can feed the property with the right data. Unfortunately there is no easy way of getting QuickCheck to do that, the Test.QuickCheck.Modifiers has a `Positive` type, but that is only capable (as I have learned the hard way) to generate values of the Num typeclass, not [Num], that is only single values not lists. This means that we'll have to implement the Arbitrary typeclass methods, the standard QuickCheck way of specifying a generator for a custom data type.
