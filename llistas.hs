myLength :: [Int] -> Int
myLength [] = 0
myLength (_ : xs) = 1 + myLength xs


myMaximum :: [Int] -> Int
myMaximum n = maximum n

totalSum :: [Int] -> Float
totalSum [] = 0.0
totalSum (x : xs) = fromIntegral(x) + totalSum(xs)

average :: [Int] -> Float
average a = totalSum(a) / fromIntegral(myLength a)

buildPalindrome :: [Int] -> [Int] 
buildPalindrome x = reverse x ++ x

remove :: [Int] -> [Int] -> [Int]
remove l r = [ x | x <- l, notElem x r]

flatten :: [[Int]] -> [Int]
flatten x = concat x

odds :: [Int] -> [Int]
odds x = filter odd x

evens :: [Int] -> [Int]
evens x = filter even x

oddsNevens :: [Int] -> ([Int],[Int])
oddsNevens l = (odds l , evens l)

-- Revisa els seus divisors. S'itera sobre una llista que va de 1..n on n es el paràmetra de la funció. La x sols és afegida si aquesta divideix n

divisors :: Int -> [Int]
divisors n = [x | x <- [1..n] , n `mod` x == 0 ]

-- Indica si un número es primer. El que fa és comparar si la llista retornada per la funció divisors és igual a la llista [1 , valor a revisar]

prime :: Int -> Bool
prime n = divisors n == [1,n]

-- Aquesta funció agafa una llista i la guarda sobre Y , aquesta va de 1 .. x on x és el paràmetra inicial de la funció
-- es revisa que x mod y == 0 per confirmar si divisor i si es primer. 
primeDivisors :: Int -> [Int] 
primeDivisors x = [y | y <- [1..x] , x `mod` y == 0 , prime(y)]