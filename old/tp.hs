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

--Funcion que dadas una lista de estados finales y una lista de tuplas que representa la funcion de transicion de un automata, devuelve verdadero si ambas cumplen con lo requerido por el problema.-
probarPosYNeg :: [Estado] -> Estado -> [Char] -> [Char] -> [((Estado, Char), Estado)] -> Bool
probarPosYNeg _ _ [] [] _ = True
probarPosYNeg estadosFinales estadoActual [] [n] fun | not (pertenece (funFromTuples fun (estadoActual, n)) estadosFinales) = True
													 | otherwise = False
probarPosYNeg estadosFinales estadoActual [] (n:neg) fun = probarPosYNeg estadosFinales (funFromTuples fun (estadoActual, n)) [] neg fun
probarPosYNeg estadosFinales estadoActual [p] neg fun  | pertenece (funFromTuples fun (estadoActual, p)) estadosFinales = True && (probarPosYNeg estadosFinales (Estado 0) [] neg fun)
														   | otherwise = False
probarPosYNeg estadosFinales estadoActual (p:pos) neg fun = probarPosYNeg estadosFinales (funFromTuples fun (estadoActual, p)) pos neg fun


--Funcion auxiliar que dadas dos tuplas de listas; devuelve aquella cuyo primer elemento es distinto de la lista vacia.-
notEmpty :: (Eq a) => ([a], [b]) -> ([a], [b]) -> ([a], [b])
notEmpty t v | (fst t) == [] = v
			 | otherwise = t

--Funcion que calcula y devuelve la lista de estados finales del automata requerido, junto con la funcion de transicion necesaria
obtenerEstadosYFuncion :: [[Estado]] -> [Char] -> [Char] -> [Char] -> [[((Estado, Char), Estado)]]-> ([Estado], [((Estado, Char), Estado)])
obtenerEstadosYFuncion [] alf pos neg _ = ([], [])
obtenerEstadosYFuncion _ alf pos neg [] = ([], [])
obtenerEstadosYFuncion (p:posEstadosFinales) alf pos neg (f:fun) | (probarPosYNeg p (Estado 0) pos neg f) = (p, f)
													 	 		 | otherwise = notEmpty (obtenerEstadosYFuncion (p:posEstadosFinales) alf pos neg fun) (obtenerEstadosYFuncion posEstadosFinales alf pos neg (f:fun))

--Funcion que devuelve una tupla compuesta por los siguiente elementos de un automata que cumple con la consigna del problema:
-- 	a) La lista de estados finales.
--  b) La Funcion de transicion dada en forma de tupla.
--  c) La cantidad minima de estados necesaria para crear el automata
estadosYFuncionCalculadas :: Int -> Int -> [Char] -> [Char] -> [Char] -> (([Estado], [((Estado, Char), Estado)]), Int)
estadosYFuncionCalculadas i k alf pos neg | i > k = (([], []), k+1)
										  | (obtenerEstadosYFuncion (subs listaDeIEstados) alf pos neg (convertirAListaDeTuplas listaDeIEstados alf)) == ([], []) = estadosYFuncionCalculadas (i+1) k alf pos neg
									  	  | otherwise = ((obtenerEstadosYFuncion (subs listaDeIEstados) alf pos neg (convertirAListaDeTuplas listaDeIEstados alf)), i)
									  	  		where listaDeIEstados = reverse (genListaEstados i)

--Dado un entero I de estados, devuelve una lista de tamanio I de estados
genListaEstados :: Int -> [Estado]
genListaEstados 1 = [Estado 0]
genListaEstados i = (Estado (i-1)):(genListaEstados (i-1))

--Funcion solucion al problema planteado:
--	Dados un alfabeto, una cantidad maxima de estados k,  una sublista pos y otra neg, devuelve un automata de cantidad minima posible de estados inferior a k, que reconoce pos y no reconoce neg
solucion :: [Char] -> Int -> [Char] -> [Char] -> Automata
solucion alf k pos neg = Automata (reverse (genListaEstados (snd estadosYFuncion))) alf (snd (fst estadosYFuncion)) (Estado 0) (fst (fst estadosYFuncion))
							where estadosYFuncion = estadosYFuncionCalculadas 1 k alf pos neg
