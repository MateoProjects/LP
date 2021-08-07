insert :: [Int] -> Int -> [Int]
insert [] n = [n]
insert (x:xs) e
	| e > x = x:(insert xs e)
	| otherwise = e:x:xs

-- remove one element of any list

remove :: [Int] -> Int -> [Int]
remove [] _ = []
remove (x:xs) e
	| x == e = xs
	| otherwise = x:(remove xs e)

-- fusion of two ordered list

merge :: [Int] -> [Int] -> [Int]
merge [] l = l
merge l [] = l
merge (x:l1) (y:l2)
	| x < y = x:(merge l1 (y:l2))
	| otherwise = y:(merge (x:l1) l2)


-- insert sort

isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = insert (isort xs)  x


-- mergeSort

msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort l = merge (msort l1) (msort l2)
	where
		ll = splitAt(div(length l) 2) l
 		l1 = fst ll
 		l2 = snd ll
-- dividir en dos llistes

ssort ::  [Int] -> [Int]
ssort [] = []
ssort l = (minimum l):ssort(remove l (minimum l))


qsort :: [Int] -> [Int]
qsort [] = []
qsort (x:l) = (qsort l1) ++ x:(qsort l2)
	where 
		l1 = [e | e <- l , e < x]
		l2 = [e | e <- l , e >= x]
    
genQsort :: Ord a => [a] -> [a]
genQsort [] = []
genQsort [x] = [x]
genQsort (x:l) = (genQsort l1) ++ x:(genQsort l2)
	where
		l1 = [e | e <- l , e < x]
		l2 = [e | e <- l , e >= x]
