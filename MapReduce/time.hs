import Data.List (foldl1')
import System.Environment (getArgs)
import Control.Parallel.Strategies (rpar, rseq, Eval, runEval)
import Control.DeepSeq (force)

sumInt :: [Int] -> Int
sumInt = foldl1' (+)

run :: Int -> Int
run n = runEval $ do
    let ns = [1..n]
        (a', b') = splitAt (length ns `div` 2) ns
    a <- rpar $ (force sumInt a')
    b <- rpar $ (force sumInt b')
    rseq a
    rseq b
    return (a + b)

main = do
    [as] <- getArgs
    let n = read as :: Int
        tot = run n
    print tot
