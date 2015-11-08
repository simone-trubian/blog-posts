import Test.QuickCheck
  (
   quickCheck
  ,verboseCheck
  ,shrink
  ,suchThat
  ,arbitrary
  ,choose
  ,sample
  ,Gen (..)
  ,Arbitrary (..)
  )

data Phone = Phone String String String
    deriving (Show, Ord, Eq)

instance Arbitrary Phone where
  arbitrary = do
    countryCode <- choose (1, 999) :: Gen Int
    areaCode <- choose (1, 9999) :: Gen Int
    phoneNumber <- choose (10000, 999999) :: Gen Int
    return (Phone (show countryCode) (show areaCode) (show phoneNumber))

genPhone :: Gen Phone
genPhone = arbitrary

prop_numLen (Phone a b c) = undefined
