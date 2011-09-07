
class Element(el) {}

class Trans(e1, e2) {}

class Graph(trans) {
    def append(t) {
        idx = (+ 1 (maximum $ map fst trans))
	    tmp = (Graph ((idx, t):xs))
        return tmp;
	}
}


class Point(x, y, z){
	def add(Point(x1, y1, z1)) {
		return Point(x+x1, y+y1, z+z1);		
	}	
}

def main(x, y){
	tmp = x + y;	
}



/*  
data Element = Element { element_val1 :: PType }                              

data Trans = Trans { val1 :: PType
	           , val2 :: PType
                   }
           
data Graph = Graph { val1 :: [(Ptype, Ptype)] }

__graph__append __graph t = tmp
    where
      let idx = (1 + (maximum (map fst trans)))
      let tmp = (Graph ((idx, t):xs))
      