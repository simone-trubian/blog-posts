import Data.Char (isUpper)
import Data.List (foldl1')

filterStr :: [String] -> [String]
filterStr = filter (\s -> (length s > 3) && (length s < 15))

capCount :: String -> Int
capCount = foldl addUpper 0

addUpper :: Int -> Char -> Int
addUpper count char = if isUpper char then count + 1 else count

totCaps :: [String] -> Int
--totCaps = sum . map capCount . filterStr
totCaps = foldl1' (+) . map capCount . filterStr


main :: IO ()
main = do
    file <- readFile "list.txt"
    print $ totCaps $ lines file
