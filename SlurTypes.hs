module SlurTypes where

data SType = SInt Integer
           | SFloat Double
           | SString String
           | SList [SType]
             deriving (Eq)

__add__ (SInt a) (SInt b) = SInt $ a + b
__add__ (SFloat a) (SFloat b) = SFloat $ a + b
__add__ (SInt a) (SFloat b) = SFloat $ (fromInteger a) + b
__add__ (SFloat b) (SInt a) = __add__ (SInt a) (SFloat b) 
__add__ (SString a) (SString b) = SString (a ++ b)
__add__ a b = error (concat [ "Can't add: "
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

instance Show SType where
    show (SInt n) = (show n)
    show (SFloat n) = (show n)
    show (SString n) = n
    show (SList n) = show n