{-# Language NoMonomorphismRestriction #-}


module SlurTypes (SType(..),
                  SlurTypes.length,
                  SlurTypes.zip,
                  SlurTypes.head,
                  SlurTypes.tail,
                  --SlurTypes.concat,
                  (SlurTypes.++),
                  typeof,
                  SlurTypes.error,
                  (Prelude.$),
                  __add__,
                  __eq__,
                  __mul__,
                  __sub__,
                  compose,
                  SlurTypes.negate,
                  prepend,
                  print,
                  putStr,
                  return,
                  mapsugar,
                  show,
                 ) where

import Data.List as DL
import Data.Map as DM
import Control.Monad
import Prelude 

data SType = SInt Integer
           | SFloat Double
           | SString String
           | SList [SType]
           | SBool Bool
           | SMap (DM.Map SType SType)
             deriving (Eq, Ord)

{-
instance Prelude.Monad (SType a) where
    (>>=) (SInt n) f = SInt $ f n
    (>>=) (SFloat n) f = SFloat $ f n
    (>>=) (SString n) f = SString $ f n
    (>>=) (SList n) f = SList $ f n
    (>>=) (SBool n) f = SBool $ f n
-}    


error s = Prelude.error s

typeof (SInt _) = "SlurInt"
typeof (SFloat _) = "SlurFloat"
typeof (SString _) = "SlurString"
typeof (SList _) = "SlurList"
typeof (SBool _) = "SlurBool"

__add__ (SInt a) (SInt b) = SInt $ a + b
__add__ (SFloat a) (SFloat b) = SFloat $ a + b
__add__ (SInt a) (SFloat b) = SFloat $ (fromInteger a) + b
__add__ (SFloat b) (SInt a) = __add__ (SInt a) (SFloat b) 
__add__ (SString a) (SString b) = SString (a Prelude.++ b)
__add__ a b = Prelude.error (Prelude.concat [ "Can't add: "
                                            , (show a), " and: "
                                            , (show b) ])

__sub__ (SInt a) (SInt b) = SInt $ a - b
__sub__ (SFloat a) (SFloat b) = SFloat $ a - b
__sub__ (SInt a) (SFloat b) = SFloat $ (fromInteger a) - b
__sub__ (SFloat b) (SInt a) = __sub__ (SInt a) (SFloat b) 

__mul__ (SInt a) (SInt b) = SInt $ a * b
__mul__ (SFloat a) (SFloat b) = SFloat $ a * b
__mul__ (SInt a) (SFloat b) = SFloat $ (fromInteger a) * b
__mul__ (SFloat b) (SInt a) = __mul__ (SInt a) (SFloat b) 

__eq__ (SInt a) (SInt b) = a == b
__eq__ (SFloat a) (SFloat b) = a == b
__eq__ (SInt a) (SFloat b) = (fromInteger a) == b
__eq__ (SFloat b) (SInt a) = b == (fromInteger a)
__eq__ (SMap m1) (SMap m2) = m1 == m2

compose a b = a . b
prepend a (SList xs) = SList $ a : xs

length :: SType -> SType
length (SList x) = SInt $ ((fromIntegral (Prelude.length x))::Integer)

head (SList (x:xs)) = x
tail (SList (x:xs)) = SList xs

negate (SFloat n) = SFloat $ Prelude.negate n
negate (SInt n) = SInt $ Prelude.negate n

mapsugar' :: [SType] -> Map SType SType
mapsugar' [] = (DM.fromList []) :: Map SType SType
mapsugar' (key:val:[]) = DM.fromList [(key, val)]
mapsugar' (key:val:xs) = DM.insert key val (mapsugar' xs)

mapsugar (SList xs) = SMap (mapsugar' xs)


zip (SList x) (SList y) = SList [ (SList[a, b]) | 
                                  (a,b) <- (Prelude.zip x y)]

(++) (SList xs) (SList yz) = (SList (xs Prelude.++ yz))


instance Show SType where
    show (SInt n) = (show n)
    show (SFloat n) = (show n)
    show (SString n) = "\"" Prelude.++ n Prelude.++ "\""
    show (SList n) = (show n)
    show (SMap m) = (show m)