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
                  __add__,
                  __eq__,
                  __mul__,
                  __sub__,
                  compose,
                  print,
                  putStr,
                  return,
                  show,

                 ) where
import Data.List as DL
import Prelude 

data SType = SInt Integer
           | SFloat Double
           | SString String
           | SList [SType]
           | SBool Bool
             deriving (Eq, Ord)


error (SString s) = Prelude.error s

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

compose a b = a . b

length :: SType -> SType
length (SList x) = SInt $ ((fromIntegral (Prelude.length x))::Integer)

head (SList (x:xs)) = x
tail (SList (x:xs)) = SList xs

zip (SList x) (SList y) = SList [ (SList[a, b]) | 
                                  (a,b) <- (Prelude.zip x y)]

(++) (SList xs) (SList yz) = (SList (xs Prelude.++ yz))


instance Show SType where
    show (SInt n) = (show n)
    show (SFloat n) = (show n)
    show (SString n) = n
    show (SList n) = (show n)