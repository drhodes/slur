{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where
import qualified Prelude as P
import Debug.Trace
import SlurTypes



foldr f z xs = __result__  where { ; __result__ =  (case  xs  of  ;  (SList [])  ->  z  ;  _  ->   (f   (head  xs )   (foldr  f  z   (tail  xs ) ) ) ) }

concat xs = __result__  where { ; __result__ =  (foldr   (++ )  (SList [])  xs ) }

main  = do { 
 ;  (print   ( (zip  (SList [(SInt 1) , (SInt 2) , (SInt 3) ])  (SList [(SInt 1) , (SInt 2) , (SInt 3) ]) ) ) ) 
 ;  (print   ( (foldr   (__add__ )  (SInt 100)  (SList [(SInt 1) , (SInt 2) , (SInt 3) , (SInt 4) ]) ) ) ) 
 ;  (print   (typeof  (SInt 1) ) ) 
 ;  (print   (length  (SList [(SInt 1) , (SInt 2) , (SInt 3) ]) ) ) 
 ;  (print   (concat  (SList [(SList [(SInt 1) , (SInt 2) ]) , (SList [(SInt 3) , (SInt 4) ]) , (SList [(SInt 1) , (SList [(SInt 2) , (SInt 3) ]) , (SInt 4) ]) ]) ) ) 
 ;  (print  (SString "done") ) 
}

