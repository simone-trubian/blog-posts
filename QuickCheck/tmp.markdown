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

