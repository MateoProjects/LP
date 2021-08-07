

main :: IO()
main = do
	contents <- readFile "agaricus-lepiota.data"
    let c = lines contents
    putStrLn c

