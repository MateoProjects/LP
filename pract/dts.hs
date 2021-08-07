data Bolet = Bolet Char [String]        
    deriving (Show)

data Tree = Empty | Node String [Tree] | NodeEdible String | NodePoison String 


listAtributeName :: [String]
listAtributeName = [nomAtribut x | x <- [0..21]]

get1 :: (a, b, c) -> a
get1 (x,_,_) = x
get2 :: (a, b, c) -> b
get2 (_,x,_) = x
get3 :: (a, b, c) -> c
get3 (_,_,x) = x

-- Esborra fila de matriu
-- Pre : Enter de la fila/columna a esborrar i la fila/columna
-- Post : S'ha eliminat la fila/columna del paràmetre d'entrada
borrarI :: Int -> [a] -> [a]
borrarI n a = take n a ++ drop (n+1) a

-- Retorna el nom de l'atribut
-- Pre : Enter amb valors entre 0 < 22
-- Post : Retorna el nom associat al enter

nomAtribut :: Integer -> String
nomAtribut 0 = "cap-shape"
nomAtribut 1 = "cap-surface"
nomAtribut 2 = "cap-color"
nomAtribut 3 = "bruises?"
nomAtribut 4 = "odor"
nomAtribut 5 = "gill-attachment"
nomAtribut 6 = "gill-spacing"
nomAtribut 7 = "gill-size"
nomAtribut 8 = "gill-color"
nomAtribut 9 = "stalk-shape"
nomAtribut 10 = "stalk-root"
nomAtribut 11 = "stalk-surface-above-ring"
nomAtribut 12 = "stalk-surface-below-ring"
nomAtribut 13 = "stalk-color-above-ring"
nomAtribut 14 = "stalk-color-below-ring"
nomAtribut 15 = "veil-type"
nomAtribut 16 = "veil-color"
nomAtribut 17 = "ring-number"
nomAtribut 18 = "ring-type"
nomAtribut 19 = "spore-print-color"
nomAtribut 20 = "population"
nomAtribut 21 = "habitat"

-- Obtenir atributs
-- Pre : Bolet
-- Post : Retorna una llista amb tots els atributs del bolet

veureAtbs :: Bolet -> [String]
veureAtbs (Bolet _ l) = l

-- Obtenir atribut especific
-- Pre : Bolet amb atributs >= Index
-- Post : Retorna el valor de la columna index

veureAtbN :: Bolet -> Int -> String
veureAtbN (Bolet _ l) i
    |null l = error "l. buida"
    |length l < i = error "!!"
    |length l <= 0 && null l = error "!!"
    |length l >= 1 && (length l) > i =  l !! i

-- Obtenir Edible / Poisonous
-- Pre : Bolet
-- Post : Retorna True si poisonous , altrament false

esVerinos :: Bolet -> Bool
esVerinos (Bolet c _ ) = c == 'p'


-- Esborrar atributs
-- Pre : Bolet amb atributs >= index
-- Post : Retorna el bolet sense l'atribut indicat per l'index

borrarAtb :: Bolet -> Int -> Bolet
borrarAtb (Bolet c l) i = Bolet c (borrarI i l)


splitString     ::  String -> [String]
splitString s =  case dropWhile (==',') s of
                      "" -> []
                      s' -> w : splitString s''
                            where (w, s'') = break (==',') s'

-- Parseja bolets
-- Pre : Llista d'strings
-- Post : Llista de bolets on cada bolet conté atribut ["e" o "p"] i tots els seus atributs

parseBolets :: [String] -> [Bolet]
parseBolets [] = []
parseBolets entrada = map mapFun entrada
    where
        mapFun :: String -> Bolet
        mapFun s = Bolet (head s) (splitString $ tail s)


--Funcio per recorre columnes
--Pre: Matriu
--Post retorna la columna
getColum :: [Bolet] -> Integer -> [String]
getColum l atribut = foldl (\acu actual-> veureAtbN actual (fromIntegral atribut): acu) [] l
    

-- Funcio per obtenir la columna d'edibles poisonous 
-- Pre : Matriu de bolets
-- Post : Retorna una llista de Strings de la columna edibles poisonous

getColumEP :: [Bolet] -> [String]
getColumEP l = foldl funFold [] l
    where
        funFold acu actual 
            | esVerinos actual = acu ++ ["p"]
            | otherwise = acu ++ ["e"]


-- Funcio per buscar diferents elements en una columna
-- Pre : Entra llista d'strings
-- Post : Retorna una llista amb els elements diferents que hi apareixen

diferentTypes :: [String] -> [String]
diferentTypes [] = []
diferentTypes (x:xs) = x : diferentTypes (filter(/= x) xs)

-- Funcio busca aparicions
-- Pre: Llista de tuples on 1er valor tuple es EP i el 2 valor la columna.
-- Post_ Retorna el total de aparicions d'E i P per un atribut lletra
buscaAparacions:: [(String, String)] -> String -> (Integer,Integer)
buscaAparacions llista lletra = foldl funfold (0,0) llista
    where 
        funfold:: (Integer,Integer) -> (String,String) -> (Integer,Integer)
        funfold ant act
            | snd act == lletra && fst act == "e" = ( fst ant + 1 , snd ant )
            | snd act == lletra && fst act == "p" = ( fst ant , snd ant + 1)
            | otherwise = ant

-- Calcul de la columna amb la màxima guanyança 
-- Pre : Entra matriu de bolets
-- Post : Retorna l'index de la columna amb la màxima guanyança
maxGain:: [Bolet] -> Integer
maxGain matrix = result
    where 
        numAtributs = toInteger $ length $ veureAtbs $ head matrix
        colums = [getColum matrix y | y <- [0..(numAtributs-1)]]
        columnaEP = getColumEP matrix
        guanyances = map (\x -> (gainPW (zip columnaEP x))/ (fromIntegral $ length matrix)) colums

        result = maxColumn guanyances 
      
--Entrem fila EP y columna 
--primera conv => ([String], [String]) -> Valor -> Suma E, Suma == bucaAparicions 
-- mirar tots els tipus que hi han i per cada un sumu quans te P i quans E i agafo el max. Finalment divideixo per T
gainPW :: [(String, String)] -> Double
gainPW a = sumaMillors
    where
        columnaAtribut = foldl (\acumulat actual -> acumulat ++ [snd actual]) [] a
        valorsDiferents = diferentTypes columnaAtribut
        valorsEP = map (buscaAparacions a) valorsDiferents
        sumaMillors = fromIntegral $ foldl (\acumulat actual -> acumulat + (max (fst actual) (snd actual))) 0 valorsEP
        
-- Obtenció de la columna màxima
-- Pre : llista de guanyances
-- Post : Retorna la posició on es troba la guanyança maxima 
 
maxColumn :: [Double] -> Integer
maxColumn [] = 0
maxColumn l = get2 resultado
   where
        resultado = foldl funFold (head l,0,0) l
        funFold :: (Double,Integer,Integer) -> Double -> (Double,Integer,Integer)   
        funFold acum act
            | act > get1 acum = (act, get3 acum, get3 acum +1)
    
            | otherwise = (get1 acum, get2 acum, get3 acum+1)

-- generacio de l'arbre
-- Pre : 1. Dataset 2. Llista d'atributs
-- Post : Retorna l'arbre generat 
--data Tree = Empty | Node String [Tree] | NodeEdible String | NodePoison String 

generateTreeDecision :: [Bolet] -> [String] -> Tree
generateTreeDecision [] [] = Empty
generateTreeDecision [] _ = Empty
generateTreeDecision llista noms = nodePare
  where
    millorAtribut = maxGain llista
    nomMillorAtribut = noms !! (fromInteger millorAtribut)
    novaLlistaAtributs = borrarI (fromInteger millorAtribut) noms
    dividirMatrix = splitMatrix millorAtribut llista
    nodePare = Node nomMillorAtribut (makeNodes dividirMatrix novaLlistaAtributs)

-- Funcio per afegir Nodes 
-- Pre : 1. Nom atribut i llista de bolets que queden per afegir. 2. Atributs restants. 
-- Post : Retorna una llista d'arbres 
makeNodes :: [(String, [Bolet])] -> [String] -> [Tree]
makeNodes [] _ = []
makeNodes ((atb, l) : xs) camps
  | sonTotsVerinosos l = NodePoison atb : makeNodes xs camps
  | sonTotsComestibles l = NodeEdible atb : makeNodes xs camps
  | otherwise = Node atb [generateTreeDecision l camps]:makeNodes xs camps 
   

-- Funcio revisa si tots els bolets de la llista son verinosos
-- Pre : Matriu de Bolets
-- Post : Retorna si tota la matriu es verinosa     
sonTotsVerinosos :: [Bolet] -> Bool
sonTotsVerinosos [a] = esVerinos a
sonTotsVerinosos (x:xs) 
    | not $esVerinos x = False
    | otherwise = sonTotsVerinosos xs


-- Funcio revisa si tots els bolets de la llista son comestibles
-- Pre : llista de bolets
-- Post: Retorna True si tots els elements de la llista son Edibles. Altrament false 
sonTotsComestibles :: [Bolet] -> Bool
sonTotsComestibles [a] = not $ esVerinos a  
sonTotsComestibles (x:xs)
    | esVerinos x = False
    | otherwise = sonTotsComestibles xs


-- Contador de columnes
-- Pre : matriu strings
-- Post : Retorna el número de columnes totals

columnCount :: [[String]] -> Integer
columnCount (x:_) = fromIntegral $ length x

-- Esborrat d'elements
-- Retorna una llista de tuples amb els atributs i la llista eliminat el 1 paràmetre 
splitMatrix :: Integer -> [Bolet]-> [(String, [Bolet])]
splitMatrix _ [] = []
splitMatrix n (s:xs)
    | (length $ veureAtbs s) < 1  = []
    | otherwise = (veureAtbN s (fromIntegral n), [boletTreienAtb s]) `sumaBolets` splitMatrix n xs
    where
        boletTreienAtb b = borrarAtb b (fromIntegral n)

-- Funcio per suma Bolets
-- Pre : 1. (Atribut , Matriu) 2. Llista de (Atribut , Matriu) 
-- Post: Retorna la suma del 1 atribut en el 2. 
sumaBolets ::  (String, [Bolet]) ->  [(String, [Bolet])] -> [(String, [Bolet])]
sumaBolets nou [] =  [nou]
sumaBolets nou (x:xs)
    | fst nou == fst x =  (fst x, snd x ++ snd nou) : xs
    | otherwise = x : (nou `sumaBolets` xs)

-- Funcio per printejar l'arbre
-- Pre: Llista de Arbre
-- Post : Retorna un String
printTree:: [Tree] -> Int ->String
printTree [] _ = ""
printTree (x:xs) val = generateStringTree x val ++ printTree xs val



-- Printeja arbre 
-- Pre: Arbre i val

generateStringTree :: Tree -> Int ->String
generateStringTree Empty _ = ""
generateStringTree (NodeEdible a) val = [' ' | y <- [1..val]] ++ "|" ++ "Edible :" ++ a ++ "\n"
generateStringTree (NodePoison a) val = [' ' | y <- [1..val]] ++ "|" ++ "Poisonus :" ++ a ++ "\n"
generateStringTree (Node a (x:xs)) val 
    | val == 0 = a  ++ "\n" ++ generateStringTree x (val +1) ++ printTree xs (val + 1) 
    | otherwise = [' ' | y <- [1..val]] ++ a ++ generateStringTree x val  ++ printTree xs (val + 1) 

-- Funcio de cerca arbre 
-- Pre : Tree 
-- Post : Busca en l'arbre 
buscaArbre:: Tree -> IO() 
buscaArbre Empty = putStrLn "Arbre buit"
buscaArbre (NodeEdible a) = putStrLn "És comestible"  
buscaArbre (NodePoison a) = putStrLn "Es  verinos"
buscaArbre (Node a (x:xs)) = do 
    putStrLn ("Quin tipus de " ++ a ++ "es?")
    val <- getLine 
    let result = cercaEnArbre val (x:xs)
    buscaArbre result 
    
-- Busca en l'arbre 
cercaEnArbre:: String -> [Tree] -> Tree
cercaEnArbre [] _ = Empty
cercaEnArbre _ [] = Empty
cercaEnArbre _ [(NodeEdible a)] = (NodeEdible a)
cercaEnArbre _ [(NodePoison a)] = (NodePoison a)
cercaEnArbre atr ((Node x (y:ys)): xs) 
    | atr == x = (Node x (y:ys))
    | atr /= x = Node x xs 



------------------------------------ MAIN -------------------------------------

main :: IO()
main = do
    contents <- readFile "agaricus-lepiota.data"
    --contents <- readFile "test3.txt"
    let reader = lines contents
    let matrix = parseBolets reader
    let listAtributeName = [nomAtribut x | x <- [0..21]]  
    --putStrLn "Generant arbre.."
    let tree = generateTreeDecision matrix listAtributeName
    let str = generateStringTree tree 0 
    putStrLn(str)   
    buscaArbre tree 