import Test.QuickCheck (quickCheck)

propRevapp :: [Int] -> [Int] -> Bool
propRevapp xs ys = reverse (xs ++ ys) == reverse ys  ++ reverse xs

main = quickCheck propRevapp
