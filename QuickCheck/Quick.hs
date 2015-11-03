{-# LANGUAGE ScopedTypeVariables #-}

import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  )

import Test.QuickCheck.Modifiers
  (
   Positive (..)
  )

import Data.List (sort)

sum' [] = 0
sum' (x:xs) = x + sum' xs

prop_SumAsso :: [Int] -> Bool
prop_SumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

prop_SumComm :: [Int] -> Bool
prop_SumComm xs = sum' xs == sum' (reverse xs)

prop_SumPos :: (Num a, Show a, Ord a) => Positive [a] -> Bool
prop_SumPos = undefined

prop_Idem :: [Int] -> Bool
prop_Idem xs = sort xs == sort (sort xs)
