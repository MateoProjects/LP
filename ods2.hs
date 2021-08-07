flatten :: [[Int]] -> [Int]
flatten a = foldl (++) [] a


myLength :: String -> Int
myLength [] = 0
myLength a = foldl (\x _ -> x+1 ) 0 a


myReverse :: [Int] -> [Int]
myReverse [] = []
myReverse a = foldl (\x xs -> xs:x) [] a


countIn ::[[Int]] -> Int -> [Int]
countIn l x = foldr (\ax axs -> (foldl (\y z -> if (z==x) then (y+1) else y) 0 ax) : axs) [] l

esespai = (== ' ')
notespai = (/= ' ') 

firstWord :: String -> String
firstWord a = takeWhile notespai (dropWhile esespai a)