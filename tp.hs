--Libreria importada para el uso de fromJust y lookup en la funcion funFromTuples
import Data.Maybe

--Tipo Estado implementado con enteros con el fin de tener una cantidad infinita de posibles estados
data Estado = Estado { estado :: Int    
                     } deriving (Show, Eq)                  

--Tipo Automata implementado con los elementos mencionados en la consigna.-
--Consta de un conjunto de estados, un alfabeto, un estado inicial y un conjunto de Estados Finales
data Automata = Automata { conjEstados :: [Estado]  
                       	 , alfabeto :: [Char]  
                       	 , estadoInicial :: Estado  
                       	 , estadosFinales :: [Estado]  
                       	 } deriving (Show, Eq)

--Automata de ejemplo 1
automata1 :: Automata
automata1 = Automata [Estado 0, Estado 1] ['a', 'b', 'c'] (Estado 0) [Estado 1]

--Automata de ejemplo 2
automata2 :: Automata
automata2 = Automata [Estado 5, Estado 1] ['a', 'h', 'c'] (Estado 1) [Estado 5]

--Funcion que dado un estado y un caracter devuelve el nuevo estado del automata.- Funcion de transicion del Automata
funFromTuples :: (Eq a) => [(a,b)] -> a -> b
funFromTuples ts x = fromJust (lookup x ts)

--Funcion que devuelve los subconjuntos de un conjunto dado en forma de lista.
subs :: [a] -> [[a]]
subs [] = [[]]
subs (x:xs) = (map (\l -> (x:l)) (subs xs)) ++ subs xs

--Funcion que devuelve verdaderos si un caracter pertenece a una lista.
pertenece :: Char -> [Char] -> Bool
pertenece x [] = False
pertenece x (y:ys) = (x == y) || (pertenece x ys)

--Funcion que devuelve verdaderos si una lista de tuplas Estado x Sigma x Estado cumple con la definicion de funcion.-
--Esto es, para todo par de pares (x, y) , (z, w) : (si x == z, entonces w == y)
esFuncion :: (Eq a, Eq b) => [(a, b)] -> Bool
esFuncion [] = False
esFuncion [x] = True
esFuncion [x, y]  | ((fst x == fst y) && (not(snd x == snd y))) = False
				  | otherwise = True
esFuncion (x:xs) | length (filter (\t -> (fst t == fst x) && (not(snd t == snd x))) xs) == 0 = (True && esFuncion xs)
				 | otherwise = False

--Funcion que dados un conjunto de estados y un alfabeto, devuelve una lista de tuplas que representa una funcion de transicion.-
--Para utilizar esta funcion de transicion debe utilizarse la misma como parametro en funFromTuples.-
convertirAListaDeTuplas :: [Estado] -> [Char] -> [[((Estado, Char), Estado)]]
convertirAListaDeTuplas xs ys = filter (\s -> esFuncion s) (subs (conjuntoTernas xs ys xs))

--Funcion auxiliar que dadas dos listas de estados y una de caracteres, devuelve el subconjunto (Estado x Sigma x Estado) en forma de lista
conjuntoTernas :: [Estado] -> [Char] -> [Estado] -> [((Estado, Char), Estado)]
conjuntoTernas [] _ _ = []
conjuntoTernas  (x:xs) (y:ys) (z:zs) = (decrementarZ (x, y) (z:zs)) ++ (conjuntoTernas xs (y:ys) (x:xs))

--Funcion auxiliar que dada una tupla perteneciente a (Estado x Sigma), devuelve una lista de tuplas pertenecientes a (Estado x Sigma x Estado)
decrementarZ :: a -> [Estado] -> [(a, Estado)]
decrementarZ x [] = []
decrementarZ x (y:ys) = (x, y):(decrementarZ x ys)



------------------------------------------FUNCIONES DEPRECATED---------------------------------------
--Funcion que Ya no se usa pero que iba a ser la posible funcion de transicion 
funcion :: Estado -> Char -> Automata -> Estado
funcion x y a | (pertenece y (alfabeto a)) =  head(estadosFinales a)
			  | otherwise = x