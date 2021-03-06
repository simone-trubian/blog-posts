# Property testing in Haskell with QuickCheck

Automated testing is (hopefully) becoming a normal part of the development workflow, ideally tests should be thought and written even before the actual code as an aid for specifying the problem that has to be solved. But this is not all, as the code base grows, all the tests accumulated in the process will help detecting changes that break backwards compatibility. The agile community is especially keen on Test Driven Development (TDD) and Behavioural Driven Development BDD, which are guidelines and tools meant to manage the development workflow and structure code "in the large".

However little attention is given to the tool that actually performs the testing, usually choosing the venerable unit testing paradigm. Unit testing, even without the BDD structure are not bad, but force the developer to come up with the testing scenarios. This means that usually one runs out of ideas after specifying a few cases. A tool that helps addressing this problem is the Haskell library [QuickCheck](https://hackage.haskell.org/package/QuickCheck) that was originally conceived in 2000. Despite this posts focuses on the Haskell implementation, the library has now been translated in many other languages including [Erlang](http://www.quviq.com/products/erlang-quickcheck/), [Scala](https://www.scalacheck.org/), [Clojure](https://github.com/clojure/test.check), [Python](https://github.com/DRMacIver/hypothesis) and many more languages.

The core concept with QuickCheck is property-based testing, meaning that a developer is required to write a function that states a property of the function to be tested. The QuickCheck library will then automatically generate data to feed to the function and test that the property holds in all cases. The beauty of it all is that property-based testing can be used *alongside* unit-based testing and both of them can be plugged in a BDD framework of choice. In that respect property checking is not meant to replace, but augment any test suite, even legacy ones!

### Moving our first steps: out of the box testing.
Testing a property predicate can be as easy as passing it to the quickCheck function and let the magic happen.
<pre><code class="haskell">Main> quickCheck prop_idem
+++ OK, passed 100 tests.
</code></pre>

Notice that we don't even need to pass an argument to `prop_idem`, as the framework takes care of generating the test values automatically. As default QuickCheck generates up to 100 values to test the property, so far so good.

Now let's try writing a wrong function to fail tests, for instance something like
<pre><code class="haskell">sum' :: [Int] -> Int
sum' (x:xs) = x + sum' xs
</code></pre>
is an incomplete implementation of the `sum` function. As far as properties go we know that sums are associative and commutative, so we can translate that in Haskell with
<pre><code class="haskell">prop_sumAsso :: [Int] -> Bool
prop_sumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

prop_sumComm :: [Int] -> Bool
prop_sumComm xs = sum' xs == sum' (reverse xs)
</code></pre>

As the implementation of `sum'` is incomplete we expect QuickCheck to fail the stests, in fact running them produces similar results in both cases.
<pre><code class="haskell">
Main> quickCheck prop_sumAsso
** Failed! (after 1 test):
Exception:
  Quick.hs:5:1-25: Non-exhaustive patterns in function sum'
[]
</code></pre>
QuickCheck exposed for us a corner case we did not think about: the empty list! We can quickly fix that by adding the missing case `sum [] = 0` and test again, now enjoying watching all tests passing with flying colours.

Sometimes however we might write a correct function but a wrong property, for instance
<pre><code class="haskell">propSumPos :: [Int] -> Bool
propSumPos xs = sum' xs >= 0
</code></pre>
does not hold true in all cases, in fact when we try running it we get this
<pre><code class="haskell">Main> quickCheck propSumPos
** Failed! Falsifiable (after 5 tests and 4 shrinks):
[-1]
</code></pre>
which *per se* isn't very helpful in helping us debug the wrong property. The first thing we could do to debug the test is to run QuickCheck in verbose mode. This will print what values were generated and what made it fail in the first place.

<pre><code class="haskell">Main> verboseCheck propSumPos
Passed:
[]
Passed:
[]
Failed:
[1,-2]
** Failed! Passed:
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

Going back to our failing test, QuickCheck will try providing the smaller possible counter example, which is the reason why it presents as result not the original value [1, -2], but a shrunk version of it [-1]. Now that we understand the meaning of this is easy to realise that our property can only hold as long as all values are equal or bigger then 0.

### A step further: generating data with combinators.
Knowing this we need to find a way to generate only positive numbers for populating the list so that we can feed the property with the right data. As what we need to achieve is just a special case of an already existing data type we should be able to use one of the many combinators that ship in the Test.QuickCheck.Gen module. In our specific case we need to create a list of positive numbers, so we can quickly write the following function:
<pre><code class="haskell">posIntList :: (System.Random.Random a, Num a) => Gen [a]
posIntList = listOf $ choose (1,1000000)
</code></pre>
Note that the type signature, as usual in Haskell, is a tell tale, it tell us that we have a polymorphic function able to create a list of any type of number. Now that we have a generator let's create a property that can be called by the quickCheck function.
<pre><code class="haskell">
gen_sumPos :: Property
gen_sumPos = forAll posIntList prop_sumPos
</code></pre>
Now we can run this property with `quickCheck get_sumPos` and watch it pass. A caveat to this approach is that our forAll property does not automatically generate a shrink function, so failing tests might not be so easy to debug.

### The final frontier, generating user-defined types.
This far we've seen only cases using out of the box data types, but Haskell is famous for its powerful algebraic type system, so QuickCheck is also capable of dealing with any user defined data types.

Unfortunately there is no easy way of getting QuickCheck to do that, this means that we'll have to implement the Arbitrary typeclass methods, which is the standard QuickCheck way of specifying a generator for a custom data type. The Arbitrary class specifies two functions: arbitrary and shrink, both of which can be tricky to implement. The arbitrary function is in fact a monad where the standard combinators can be composed together. One of the advantages of using a monad is that all the values generated by the combinators can be unpacked from the Gen class and modified or used to construct the custom data type.

To give an example let's create a Phone type that contains a full phone number including country and area code.
<pre><code class="haskell">data Phone = Phone String String String
    deriving (Show, Ord, Eq)
</code></pre>
The reason why I'm using strings here is that phone numbers are more like names than numbers, that is one uses a phone number to call somebody not to make maths with it. However when it comes to actually generating them in Haskell I find more convenient to use actual integer numbers.
<pre><code class="haskell">instance Arbitrary Phone where
  arbitrary = do
    countryCode <- choose (1, 999) :: Gen Int
    areaCode <- choose (1, 9999) :: Gen Int
    phoneNumber <- choose (10000, 999999) :: Gen Int
    return (Phone (show countryCode) (show areaCode) (show phoneNumber))
</code></pre>
The arbitrary implementation is pretty straightforward: for each section of the phone number a number is randomly generated, and its value bound to a name. Finally a Phone data instance is constructed and returned, notice that all generative functions were restricted to to Int to avoid ambiguity with the show function (this is called monomorphic restriction and is sometimes necessary in Haskell to allow the compiler to type-check our functions).

To make sure that our arbitrary function is generating what we had in mind we can use restriction again:
<pre><code class="haskell">genPhone :: Gen Phone
genPhone = arbitrary
</code></pre>
This function, thanks to the type signature is automatically bound to our implementation of `arbitrary`, this allows to call the sample function that will generate a few samples of our data type.
<pre><code class="haskell">Phone "793" "5119" "448388"
Phone "351" "8035" "334695"
Phone "490" "1422" "113181"
Phone "352" "2140" "702930"
Phone "965" "7500" "89922"
Phone "914" "3584" "34219"
Phone "112" "785" "780162"
Phone "803" "8779" "52016"
Phone "141" "3299" "557328"
Phone "541" "4082" "674339"
Phone "93" "1747" "298804"
</code></pre>

This was a quick tour of the powers of property-based testing, I hope this post inspired you to delve deeper in it and start swatting out bugs in your program.
