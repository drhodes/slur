{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where
import Debug.Trace
import SlurTypes



other  = __result__  where { ; __result__ = (SInt 4) }

main  = do { 
 ;  (print  (SString "hello") ) 
 ;  (compose  putStr  show   ((SString "zxcv") ) ) 
 ;  (compose  putStr  show   (__add__  (SFloat 0.345)  (SFloat 3.234) ) ) 
 ;  (return  (SString "hello") ) 
}

