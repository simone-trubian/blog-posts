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

sum' [] = 0
sum' (x:xs) = x + sum' xs

data PosList = PosList [Int]
  deriving (Show, Ord)

instance Arbitrary (PosList) where
  arbitrary = sized $ \n -> do
    k <- choose (0, n)
    list <- sequence [ arbitrary | _ <- [1..k] ]
    return $ PosList list

prop_SumAsso :: [Int] -> Bool
prop_SumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

prop_SumComm :: [Int] -> Bool
prop_SumComm xs = sum' xs == sum' (reverse xs)

prop_SumPos :: (Num a, Show a, Ord a) => Positive [a] -> Bool
prop_SumPos = undefined

prop_Idem :: [Int] -> Bool
prop_Idem xs = sort xs == sort (sort xs)
