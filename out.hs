{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where
import qualified Prelude as P
import Debug.Trace
import SlurTypes



func x = __result__  where { ; __result__ = (SInt 0) }

main  = do { 
 ;  (print  (mapsugar $ SList ([(SString "key1") ,  (__add__  (SInt 1)  (SInt 1) ) , (SString "key3") , (SString "asdff") ])) ) 
}

