{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
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
  ,Gen (..)
  )

sum' :: Num a => [a] -> a

sum' [] = 0
sum' (x:xs) = x + sum' xs

type PosList = [Integer] --Int overflows the test!

-- List can overflow Int
instance Arbitrary PosList where
  arbitrary = sized $ \n -> do
    k <- choose (0, n)
    list <- sequence [ arbitrary | _ <- [1..k] ]
    return $ filter (> 0) list


prop_SumPos :: PosList -> Bool
prop_SumPos xs = sum' xs >= 0
