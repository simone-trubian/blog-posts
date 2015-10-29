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
QuickCheck exposed for us a corner case we did not think about: the empty list! We can quickly fix that by adding the missing case `sum [] = 0` and test again:

