import Data.Char (isUpper)
import Data.List (foldl1')
import Control.Parallel.Strategies (rpar, rseq, Eval, runEval)

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
    let rows = lines file
        (as, bs) = splitAt (length rows `div` 2) rows

        tot = runEval $ do
            a <- rpar $ totCaps as
            b <- rpar $ totCaps bs
            rseq a
            rseq b
            return (a + b)

    print tot
