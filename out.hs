{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where
import Debug.Trace
import SlurTypes



cube x = __result__  where { ; temp =  (__add__  x  (SInt 1) )  ; temp4 = (SInt 34)  ; __result__ =  (__mul__  x   (square   (__add__  temp  temp4 ) ) ) }

square x = __result__  where { ; __result__ =  (__mul__  x  x ) }

addN n = __result__  where { ; __result__ =  (__add__  n ) }

addTo f val = __result__  where { ; __result__ =  (f  val ) }

outer a = __result__  where { ; 
inner1 b = __result__  where { ; 
inner2 c = __result__  where { ; __result__ =  (__add__  c  (SInt 1) ) }
 ; __result__ =  (inner2  b ) }
 ; __result__ =  (inner1  a ) }

fact n = __result__  where { ; __result__ =  (if   (__eq__  n  (SInt 0) )  then  (SInt 1)  else   (__mul__  n  $  fact   (__sub__  n  (SInt 1) ) ) ) }

is_one n = __result__  where { ; __result__ =  (__eq__  n  (SInt 1) ) }

main  = do { 
 ; let x = (SInt 42) 
 ; let temp =  (if   (__eq__  x  (SInt 42) )  then   (let  ;  a  =  (SInt 2)  ;  b  =  (SInt 3)  ;  c  =  (SInt 5)  in   (__add__   (__add__  a  b )  c ) )  else   (case  x  of  ;  (SInt 1)  ->  (SString "January")  ;  (SInt 2)  ->  (SString "Febuary")  ;  _  ->  (SString "Hello") ) ) 
 ; let list1 =  (repeat  (SInt 4) ) 
 ; let tmp =  (case  (SInt 3)  of  ;  (SInt 1)  ->   (\  x  ->   (__add__  x  (SInt 1) ) )  ;  (SInt 3)  ->   (case  (SInt 3)  of  ;  (SInt 1)  ->   (\  x  ->  temp )  ;  (SInt 3)  ->   (\  x  ->  temp ) )  ;  (SInt 2)  ->   (\  x  ->  (SString "A") ) ) 
 ; let t =  (tmp  (SInt 1) ) 
 ; let wrap =  (return  (SString "value") ) 
 ; unwrap <- wrap 
 ; let temp =  (return  unwrap ) 
 ; return  (let  ;  a  =  (SString "a")  ;  b  =  (SInt 5)  in   (__add__  a  b ) ) 
}

