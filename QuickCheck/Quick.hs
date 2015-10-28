import Test.QuickCheck (quickCheck)
import Data.List (sort)

sum' :: [Int] -> Int

sum' [] = 0
sum' (x:xs) = x + sum' xs

propSumAsso :: [Int] -> Bool
propSumAsso xs = sum' xs + sum' xs == sum' (xs ++ xs)

propSumComm :: [Int] -> Bool
propSumComm xs = sum' xs == sum' (reverse xs)

propIdem :: [Int] -> Bool
propIdem xs = sort xs == sort (sort xs)
