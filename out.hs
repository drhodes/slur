{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where
import Debug.Trace
import SlurTypes



fact n = __result__  where { ; __result__ =  (case  n  of  ;  (SInt 0)  ->  (SInt 1)  ;  _  ->   (__mul__  n   (fact   (__sub__  n  (SInt 1) ) ) ) ) }

what n = __result__  where { ; __result__ =  (zip  n  n ) }

main  = do { 
 ;  (print   (what  [(SInt 1) , (SInt 2) , (SInt 3) ] ) ) 
 ;  (print   (zip  [(SInt 1) , (SInt 2) , (SInt 3) ]  [(SInt 1) , (SInt 2) , (SInt 3) ] ) ) 
 ;  (print   (fact  (SInt 4) ) ) 
 ;  (print  (SString "hello") ) 
 ;  (compose  putStr  show   ((SString "asdf") ) ) 
 ;  (compose  putStr  show   (__add__  (SFloat 0.345)  (SFloat 3.234) ) ) 
 ; return (SInt 1) 
}

