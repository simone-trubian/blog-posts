-- Try commenting out the two following pragmas to fail the typeclass instance.
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverlappingInstances #-}

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

import Test.QuickCheck.Arbitrary
  (
   Arbitrary (..)
  ,arbitrary
  )

import Test.QuickCheck.Gen
  (
   sized
  ,choose
  )

import Data.List (sort)

type PosList = [Integer] --Int overflows the test!

-- List can overflow Int
instance Arbitrary PosList where
  arbitrary = sized $ \n -> do
    k <- choose (0, n)
    list <- sequence [ arbitrary | _ <- [1..k] ]
    return $ filter (> 0) list

sum' :: Num a => [a] -> a

sum' [] = 0
sum' (x:xs) = x + sum' xs

prop_SumAsso :: [Int] -> Bool
prop_SumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

prop_SumComm :: [Int] -> Bool
prop_SumComm xs = sum' xs == sum' (reverse xs)

prop_SumPos :: PosList -> Bool
prop_SumPos xs = sum' xs >= 0

prop_Idem :: [Int] -> Bool
prop_Idem xs = sort xs == sort (sort xs)
