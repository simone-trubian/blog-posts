filterStr :: [String] -> [String]
filterStr = filter (\s -> (length s > 3) && (length s < 15))
