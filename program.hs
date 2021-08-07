absValue :: Int -> Int
absValue n
    | n >= 0 = n
    | otherwise = -n

power :: Int -> Int -> Int
power a 0 = 1
power a 1 = a
power a b = a * power a (b-1)

divisors :: Int -> [Int]
divisors n = [x | x <- [1..n], n `mod` x == 0]


isPrime :: Int -> Bool
isPrime n = divisors n == [1,n]

slowFib :: Int -> Int
slowFib 0 = 0
slowFib 1 = 1
slowFib n = slowFib (n-1) + slowFib (n-2)

fib :: Int->(Int , Int)
fib 0 = (0,1)
fib n
	| even n = (c , d)
	| otherwise = (d , c+d)
	where 
		(a, b) = fib(div n 2)
		c = a * (b * 2 - a)
		d = a * a + b * b

quickFib :: Int -> Int
quickFib 0 = 0
quickFib 1 = 1
quickFib n = fst(fib n)

getThird :: (Int , Int , Int) -> Int
getThird (_,_,c) = c