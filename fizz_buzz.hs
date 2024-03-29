fizzBuzz :: [Either Int String]
fizzBuzz = [stringmult x | x <- [0..]]


stringmult :: Int -> Either Int String
stringmult x  
	| (x `mod` 3 == 0) && (x `mod` 5 == 0) = Right "FizzBuzz"
	| (x `mod` 3 == 0) = Right "Fizz" 
	| (x `mod` 5 == 0) = Right "Buzz"
	| otherwise = Left x