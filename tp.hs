--Libreria importada para el uso de fromJust y lookup en la funcion funFromTuples
import Data.Maybe

--Tipo Estado implementado con enteros con el fin de tener una cantidad infinita de posibles estados
data Estado = Estado { estado :: Int    
                     } deriving (Show, Eq)                  

--Tipo Automata implementado con los elementos mencionados en la consigna.-
--Consta de un conjunto de estados, un alfabeto, un estado inicial y un conjunto de Estados Finales
data Automata = Automata { conjEstados :: [Estado]  
                       	 , alfabeto :: [Char]
                       	 , funcTransicion :: [((Estado, Char), Estado)]  
                       	 , estadoInicial :: Estado  
                       	 , estadosFinales :: [Estado]  
                       	 } deriving (Show, Eq)

--Automata de ejemplo 1
automata1 :: Automata
automata1 = Automata [Estado 0, Estado 1] ['a', 'b', 'c'] [((Estado 0, 'a'), Estado 1), ((Estado 0, 'b'), Estado 0), ((Estado 0, 'c'), Estado 1), ((Estado 1, 'a'), Estado 1), ((Estado 1, 'b'), Estado 1), ((Estado 1, 'c'), Estado 0)] (Estado 0) [Estado 1]

--Automata de ejemplo 2
automata2 :: Automata
automata2 = Automata [Estado 5, Estado 1] ['a', 'h', 'c'] [((Estado 5, 'a'), Estado 5), ((Estado 5, 'h'), Estado 5), ((Estado 5, 'c'), Estado 5), ((Estado 1, 'a'), Estado 1), ((Estado 1, 'h'), Estado 5), ((Estado 1, 'c'), Estado 1)] (Estado 1) [Estado 5]

--Funcion que dado un estado y un caracter devuelve el nuevo estado del automata.- Funcion de transicion del Automata
funFromTuples :: (Eq a) => [(a,b)] -> a -> b
funFromTuples ts x = fromJust (lookup x ts)

--Funcion que devuelve los subconjuntos de un conjunto dado en forma de lista.
subs :: [a] -> [[a]]
subs [] = [[]]
subs (x:xs) = (map (\l -> (x:l)) (subs xs)) ++ subs xs

--Funcion que devuelve verdaderos si un caracter pertenece a una lista.
pertenece :: (Eq a) => a -> [a] -> Bool
pertenece x [] = False
pertenece x (y:ys) = (x == y) || (pertenece x ys)

cantidadDeApariciones :: (Eq a) => a -> [(a, b)] -> Int
cantidadDeApariciones x [] = 0
cantidadDeApariciones x (y:ys)  | (x == (fst y)) = 1 + (cantidadDeApariciones x ys)
								| otherwise = (cantidadDeApariciones x ys)


--Funcion que devuelve verdaderos si una lista de tuplas Estado x Sigma x Estado cumple con la definicion de funcion.-
--Esto es, para todo par de pares (x, y) , (z, w) : (si x == z, entonces w == y)
esFuncion :: (Eq a, Eq b) => [(a, b)] -> Bool
esFuncion [] = False
esFuncion [x] = True
esFuncion [x, y]  | ((fst x == fst y) && (not(snd x == snd y))) = False
				  | otherwise = True
esFuncion (x:xs) | length (filter (\t -> (fst t == fst x) && (not(snd t == snd x))) xs) == 0 = (True && esFuncion xs)
				 | otherwise = False

--Funcion que dada una funcion en forma de lista de tuplas, devuelve verdadero si la funcion es total.- (
--esto es, cada elemento del dominio aparece una y solo una vez en la def de la funcion
esTotal :: (Eq a) => Int -> [(a, b)] -> Bool
esTotal sizeDominio [] = True
esTotal sizeDominio (x:xs)	| (length (x:xs) == sizeDominio) && (cantidadDeApariciones (fst x) xs == 0) = True && (esTotal (sizeDominio-1) xs)
							| otherwise = False

--Funcion que dados un conjunto de estados y un alfabeto, devuelve una lista de tuplas que representa una funcion de transicion.-
--Para utilizar esta funcion de transicion debe utilizarse la misma como parametro en funFromTuples.-
convertirAListaDeTuplas :: [Estado] -> [Char] -> [[((Estado, Char), Estado)]]
convertirAListaDeTuplas xs ys = filter (\s -> esFuncion s && esTotal ((length xs) * (length ys)) s) (subs (obtenerUniverso xs ys))

--Funcion auxiliar que dadas una lista de estados y otra de caracteres, devuelve el subconjunto (Estado x Sigma x Estado) en forma de lista
obtenerUniverso :: [Estado] -> [Char] ->[((Estado, Char), Estado)]
obtenerUniverso xs ys = [((a, b), c) | a <- xs, b <- ys, c <- xs]


------------------------------------------FUNCIONES DEPRECATED---------------------------------------
--Funcion que Ya no se usa pero que iba a ser la posible funcion de transicion 
funcion :: Estado -> Char -> Automata -> Estado
funcion x y a | (pertenece y (alfabeto a)) =  head(estadosFinales a)
			  | otherwise = x


--Funcion auxiliar que dadas dos listas de estados y una de caracteres, devuelve el subconjunto (Estado x Sigma x Estado) en forma de lista
conjuntoTernas :: [Estado] -> [Char] -> [Estado] -> [((Estado, Char), Estado)]
conjuntoTernas _ [] _ = []
conjuntoTernas [] _ _ = []
conjuntoTernas  (x:xs) (y:ys) (z:zs) = (decrementarZ (x, y) (z:zs)) ++ (conjuntoTernas xs (y:ys) (x:xs)) ++ (conjuntoTernas (x:xs) ys (x:xs))


--Funcion auxiliar que dada una tupla perteneciente a (Estado x Sigma), devuelve una lista de tuplas pertenecientes a (Estado x Sigma x Estado)
decrementarZ :: a -> [Estado] -> [(a, Estado)]
decrementarZ x [] = []
decrementarZ x (y:ys) = (x, y):(decrementarZ x ys)			  