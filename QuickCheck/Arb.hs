import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  ,elements
  ,suchThat
  ,arbitrary
  ,sized
  ,choose
  ,shuffle
  ,sublistOf
  ,Gen (..)
  ,Arbitrary (..)
  )

data Phone = Phone String String String
    deriving (Show, Ord, Eq)

instance Arbitrary Phone where
  arbitrary = do
    c <- elements ["0044", "0011", "0039"]
    p <- elements ["0207", "0208"]
    x <- choose (10000, 999999) :: Gen Int
    let n = show x
    return (Phone c p n)


genPhone :: Gen Phone
genPhone = arbitrary

prop_numLen (Phone a b c) = length a == length b && length b <= length c
