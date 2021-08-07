import Debug.Trace

data Bolet = Bolet Char [String]        
    deriving (Show)

data Tree = Empty | Node String [Tree] | NodeEdible String | NodePoison String 
    deriving (Show)
-- x=  Node "atb1" ["valor1" -> E, "valor2" -> P]
-- Node "atb2" [...,Valor2 -> x]
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
veureAtbN (Bolet _ l) i = l !! i

-- Obtenir Edible / Poisonous
-- Pre : Bolet
-- Post : Retorna True si poisonous , altrament false

esVerinos :: Bolet -> Bool
esVerinos (Bolet c _)= c == 'p'


-- Esborrar atributs
-- Pre : Bolet amb atributs >= index
-- Post : Retorna el bolet sense l'atribut indicat per l'index

borrarAtb :: Bolet -> Int -> Bolet
borrarAtb (Bolet c l) i = Bolet c (borrarI i l)



-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Entrada / Sortida
splitString     ::  String -> [String]
splitString s =  case dropWhile (==',') s of
                      "" -> []
                      s' -> w : splitString s''
                            where (w, s'') = break (==',') s'

-- Parseja bolets
-- Pre : Llista d'strings
-- Post : Llista de bolets on cada bolet conté atribut ["e" o "p"] i tots els seus atributs

parseBolets :: [String] -> [Bolet]
parseBolets entrada = map mapFun entrada
    where
        mapFun :: String -> Bolet
        mapFun s = Bolet (head s) (splitString $ tail s)



-- Conta tots els edibles, poisonus
-- Pre: L'entrada te el format ["p, e," ...]
-- Post: Retorna una tupla on el primer valor indica els P i el segon els E

countTotalEP :: [Bolet] -> (Integer, Integer)
countTotalEP matrix = foldl funCountEP (0,0) matrix
    where
        funCountEP acu act
            | esVerinos act = ((fst $ acu)+1, snd acu)
            | otherwise = (fst acu, (snd acu)+1)


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

-- #################### calcul entropies & ganancias:
--Pre
 -- H(d) =  -[(#edible / #lenght d) * logBase 2 (#edible / #lenght d)] - [(#poison / #lenght d) * logBase2 (#poison / #lenght d)]
-- Edible , Poisonus
calculEG:: (Integer, Integer) -> Int -> Double
calculEG ep total = -(prop_edibles) - prop_poison
    where
        prop_edibles = pe * logBase 2 pe
        prop_poison =  pd * logBase 2 pd
        pe = fromIntegral(fst ep) / fromIntegral(total) :: Double
        pd = fromIntegral(snd ep) / fromIntegral(total) :: Double

-- Pre : Entra llista d'strings
-- Post : Retorna una llista amb els elements diferents que hi apareixen

diferentTypes :: [String] -> [String]
diferentTypes [] = []
diferentTypes (x:xs) = x : diferentTypes (filter(/= x) xs)

-- Retorna el total de aparicions
buscaAparacions:: [(String, String)] -> String -> (Double,Double,Double)
buscaAparacions llista lletra = foldl funfold (0.0,0.0,0.0) llista
    where 
        funfold:: (Double, Double, Double) -> (String,String) -> (Double , Double, Double)
        funfold ant act
            | snd act == lletra && fst act == "e" = ((get1 ant) + 1 , get2 ant , (get3 ant) + 1)
            | snd act == lletra && fst act == "p" = (get1 ant , (get2 ant) + 1 , (get3 ant) + 1)
            | otherwise = ant

-- guany = entropia dataset 
-- columnn -> column n
                                            --	valor entropia
indexTuple:: [(String, String)] -> [String] -> [(String, Double)]
indexTuple _ [] = []
indexTuple t (x:xs) = (x,entropia) : indexTuple t xs
    where 
        -- edible poisonus total
        bA = buscaAparacions t x 
        aparicionsE = get1 bA
        aparicionsP = get2 bA
        total = get3 bA
        entropia 
            | aparicionsE == 0 && aparicionsP == 0 = 0 
            | aparicionsE == 0 = -(aparicionsP/total * logBase 2 (aparicionsP / total))
            | aparicionsP == 0 = -(aparicionsE/total * logBase 2 (aparicionsE / total))
            | otherwise = -(aparicionsE/total * logBase 2 (aparicionsE / total)) - (aparicionsP/total * logBase 2 (aparicionsP / total))

-- 1.EP , 2.Columna , retorna (atribut, entropia Atribut)
columEntropy :: [String] -> [String] -> [(String,Double)]
columEntropy [] [] = []
columEntropy a b = result
    where
        types = diferentTypes b
        tup = zip a b
        result = indexTuple tup types

-- calcul del guany entra un string , string 
-- 1.(Columna ep , atribut) , 2.(entropia general) , 3.(total) , 4.(entropia de una columna) 
guany :: [(String, String)] -> Double -> Double -> [(String, Double)] -> Double
guany atr eg total colEntro = eg - foldl fun 0.0 colEntro
    where
        fun acum act = acum +  ((snd act) * proporcio)
            where
                proporcio = (get3 $ buscaAparacions atr (fst act)) / total

-- maxGain. Donada una matriu calcula per totes la guanyança i es queda amb la max
-- 1. matriu 2. longitud atributs 3.EG
maxGain:: [Bolet] -> Integer
maxGain matrix = result
    where
        entropiaGeneral = calculEG (countTotalEP matrix) (length matrix)
        numAtributs = toInteger $ length $ veureAtbs $ head matrix
        columnes = [getColum matrix y | y <- [0..(numAtributs-1)]] --llista d'atributs 

        guanyances = map funmap columnes
        columnaEP = getColumEP matrix

        funmap x = guany (zip columnaEP x) entropiaGeneral (fromIntegral $length matrix) (columEntropy columnaEP x)

        result = maxColumn guanyances

maxGain2:: [Bolet] -> [Double]
maxGain2 matrix = guanyances
    where
        entropiaGeneral = calculEG (countTotalEP matrix) (length matrix)
        numAtributs = toInteger $ length $ veureAtbs $ head matrix
        columnes = [getColum matrix y | y <- [0..(numAtributs-1)]] --llista d'atributs 

        guanyances = map funmap columnes
        columnaEP = getColumEP matrix

        funmap x = guany (zip columnaEP x) entropiaGeneral (fromIntegral $length matrix) (columEntropy columnaEP x)
        result = maxColumn guanyances


-- Pre : Entra matriu de bolets
-- Post : Retorna l'index de la columna amb la màxima guanyança

maxGain3:: [Bolet] -> Integer
maxGain3 matrix = result
    where 
        numAtributs = toInteger $ length $ veureAtbs $ head matrix
        colums = [getColum matrix y | y <- [0..(numAtributs-1)]]
        columnaEP = getColumEP matrix
        guanyances = map funmap colums
        funmap x = gainPW (zip columnaEP x)
        result = maxColumn guanyances
        -- falta merda


gainPW :: (String , String) -> Double
-- mirar tots els tipus que hi han i per cada un sumu quans te P i quans E i agafo el max. Finalment divideixo per T
gainPW a = 0.0


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
generateTreeDecision :: [Bolet] -> [String] -> Tree
generateTreeDecision [] _ =  Empty
generateTreeDecision _ [] = error "el arbol no tiene solución"
generateTreeDecision matrix  atributs = Node nomAtribut (crearDecisions dividirMatrix nousCamps)
    where
        millorAtribut = maxGain matrix
        dividirMatrix = splitMatrix millorAtribut matrix
        nomAtribut = atributs !! fromIntegral millorAtribut
        nousCamps = borrarI (fromIntegral millorAtribut) atributs

-- Pre: Entra 1.Llista de tuples amb atributs i bolets 2. Llista d'atributs actualitzats
-- Post : Retornar un arbre de decisions

crearDecisions :: [(String, [Bolet])] -> [String] -> [Tree]
crearDecisions [] _ = []
crearDecisions _ [] = error "El arbol no tiene solucion :("
crearDecisions ((atribut, llista):xs) camps
    | sonTotsVerinosos llista = NodePoison atribut : crearDecisions xs camps
    | not (sonTotsVerinosos llista) = NodeEdible atribut : crearDecisions xs camps
    | otherwise = Node atribut [generateTreeDecision llista camps] : crearDecisions xs camps
        
-- Pre : Matriu de Bolets
-- Post : Retorna si tota la matriu es verinosa     
sonTotsVerinosos :: [Bolet] -> Bool
sonTotsVerinosos l = all ((==True) . esVerinos) l

-- Pre : matriu strings
-- Post : Retorna el número de columnes totals
columnCount :: [[String]] -> Integer
columnCount (x:_) = fromIntegral $ length x

-- 1 matrix 2 nom atributs 3 columna eliminar  4. Nom Atribut retorna matrix nova i llista atributs nova
splitMatrix :: Integer -> [Bolet]-> [(String, [Bolet])]
splitMatrix _ [] = []
splitMatrix n (s:xs) = (veureAtbN s (fromIntegral n), [boletTreienAtb s]) # splitMatrix n xs
    where
        boletTreienAtb b = borrarAtb b (fromIntegral n)

(#) ::  (String, [Bolet]) ->  [(String, [Bolet])] -> [(String, [Bolet])]
(#) new [] =  [new]
(#) new (x:xs)
    | fst new == fst x =  (fst x, snd x ++ snd new) : xs
    | otherwise = x : (new # xs)

------------------------------------ MAIN -------------------------------------

main :: IO()
main = do
    contents <- readFile "agaricus-lepiota.data"
    --contents <- readFile "agaricus-lepiota.data"
    let reader = lines contents
    let matrix = parseBolets reader
    --print matrix

    let listAtributeName = [nomAtribut x | x <- [0..21]]
        
    putStrLn "Generant arbre.."

    print $ maxGain matrix
    print $ maxGain2 matrix
    --let tree = generateTreeDecision matrix ["atb1", "atb2"]
    --let tree = generateTreeDecision matrix listAtributeName
    --print(tree)