import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  )
import Data.List (sort)

sum' :: [Int] -> Int

sum' [] = 0
sum' (x:xs) = x + sum' xs

propSumAsso :: [Int] -> Bool
propSumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

propSumComm :: [Int] -> Bool
propSumComm xs = sum' xs == sum' (reverse xs)

propSumPos :: [Int] -> Bool
propSumPos xs = sum' xs >= 0

propIdem :: [Int] -> Bool
propIdem xs = sort xs == sort (sort xs)
