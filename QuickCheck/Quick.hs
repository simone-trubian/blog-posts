import Test.QuickCheck (quickCheck)
import Data.List (sort)

propIdem :: [Int] -> Bool
propIdem xs = sort xs == sort (sort xs)

main = quickCheck propIdem
