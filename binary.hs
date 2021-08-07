data Tree a = Node a (Tree a) (Tree a) | Empty 
	deriving (Show)


size :: Tree a -> Int
size Empty = 0
size (Node _ fe fd) = 1 + size fd + size fe


height :: Tree a -> Int 
height Empty = 0
height (Node _ fe fd) = 1 + max (height fe) (height fd)


equal:: Eq a => Tree a -> Tree a -> Bool
equal Empty Empty = True
equal Empty _ = False
equal _ Empty = False
equal (Node aa fea fda) (Node bb feb fdb) = (aa == bb) && (equal fea feb) && (equal fda fdb)


isomorphic :: Eq a => Tree a -> Tree a -> Bool 
isomorphic Empty Empty = True
isomorphic Empty _ = False
isomorphic _ Empty = False
isomorphic (Node aa fea fda) (Node bb feb fdb) = (aa == bb) && ((equal fea feb && equal fda fdb) || (equal fea fdb && equal fda feb))


preOrder :: Tree a -> [a]
preOrder Empty = []
preOrder (Node a fe fd) = [a] ++ preOrder fe ++ preOrder fd

postOrder :: Tree a -> [a]
postOrder Empty = []
postOrder (Node a fe fd) = postOrder fe ++ postOrder fd ++ [a]

inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node a fe fd) = inOrder fe ++ [a] ++ inOrder fd

breadthFirst :: Tree a -> [a]
breadthFirst Empty = []
breadthFirst a = bfs [a]


bfs :: [Tree a] -> [a]
bfs [] = []
bfs (Empty:xs) = bfs xs
bfs ((Node aa fe fd):xs) = aa : (bfs $ xs ++ [fe,fd])

-- pre-ordre  -- pos-ordre
build :: Eq a => [a] -> [a] -> Tree a
build [][] = Empty
build (x:xs) inordre =   Node x (build leftPreordre leftInordre) (build rightPreordre rightInordre)
        where
                leftInordre   = takeWhile (/= x) inordre
                leftPreordre  = take (length leftInordre) xs
                rightPreordre = drop (length leftInordre) xs
                rightInordre  = tail (dropWhile (/= x) inordre)


overlap :: (a -> a -> a) -> Tree a -> Tree a -> Tree a
overlap _ Empty Empty = Empty
overlap _ Empty a = a
overlap _ a Empty = a
overlap fun (Node aa fea fda) (Node bb feb fdb) = Node(fun aa bb) (overlap fun fea feb) (overlap fun fda fdb)