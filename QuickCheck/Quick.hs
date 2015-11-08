import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  ,forAll
  ,listOf
  )

import Test.QuickCheck.Gen
  (
   choose
  ,Gen (..)
  )

import Test.QuickCheck.Property
  (
   Property (..)
  )

import System.Random
  (
   Random (..)
  )
import Data.List (sort)

sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

posIntList :: (System.Random.Random a, Num a) => Gen [a]
posIntList = listOf $ choose (1,1000000)

gen_sumPos :: Property
gen_sumPos = forAll posIntList prop_sumPos

prop_sumAsso :: [Int] -> Bool
prop_sumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

prop_sumComm :: [Int] -> Bool
prop_sumComm xs = sum' xs == sum' (reverse xs)

prop_sumPos :: [Int] -> Bool
prop_sumPos xs = sum' xs >= 0

prop_idem :: [Int] -> Bool
prop_idem xs = sort xs == sort (sort xs)
