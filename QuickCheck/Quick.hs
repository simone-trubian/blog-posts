{-# LANGUAGE ScopedTypeVariables #-}

import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  )

import Test.QuickCheck.Modifiers (Positive (..))
import Data.List (sort)

--sum' :: [Int] -> Int

sum' [] = 0
sum' (x:xs) = x + sum' xs

propSumAsso :: [Int] -> Bool
propSumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

propSumComm :: [Int] -> Bool
propSumComm xs = sum' xs == sum' (reverse xs)

propSumPos :: (Num a, Show a, Ord a) => Positive [a] -> Bool
--propSumPos :: Positive [Int] -> Bool
--propSumPos = undefined
--propSumPos (Positive (xs :: [Num]) ) = sum' xs >= 0
propSumPos (Positive (xs :: [Int]) ) = sum' xs >= 0

propIdem :: [Int] -> Bool
propIdem xs = sort xs == sort (sort xs)
