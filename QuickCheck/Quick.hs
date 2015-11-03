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

propSumAsso :: [Int] -> Bool
propSumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

propSumComm :: [Int] -> Bool
propSumComm xs = sum' xs == sum' (reverse xs)

propSumPos :: (Num a, Show a, Ord a) => Positive [a] -> Bool
propSumPos = undefined

propIdem :: [Int] -> Bool
propIdem xs = sort xs == sort (sort xs)
