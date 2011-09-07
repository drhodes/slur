#! /usr/bin/env python

from parser import parsetree
import sys

def out(s): sys.stdout.write(s)

def levelout(s, n): 
    out(n*"  ")
    out(s)

def newline(): out("\n")

def pretty(pt, depth=0):
    if type(pt) == list:        
        for node in pt:
            pretty(node, depth+1)        
        return            
    if type(pt) == unicode:
        levelout(pt, depth+1)        
        newline()
    else:
        levelout(pt.__name__, depth)
        out(": ")
        out(pt.__name__.line)
        newline()
        pretty(pt.what, depth+1)

tree = parsetree()[0] 
#pretty(tree)

def tbl(x):
    tmp = {\
        "assign": assign,
        "block": block,
        "dot": dot,
        "dubstring": dubstring,
        "expr": expr,
        "expr": expr,
        "expr1": expr1,
        "ident": ident,
        "klass": klass,
        "listsugar": listsugar,
        "literal": literal,
        "lowername": lowername,
        "mapsugar": mapsugar,
        "method": method,
        "method_io": method_io,
        "method_pure": method_pure,
        "module": module,
        "name": name,
        "operator": operator,
        "param": param,
        "param1": param1,
        "param2": param2,
        "parameterlist": parameterlist,
        "slurfile": slurfile,
        "rawstring": rawstring,
        "returnstmt": returnstmt,
        "stmt": stmt,
        "symbol": symbol,
        "uppername": uppername,
        "unwrap": unwrap,
        }
    return tmp[x]

def symgen():
    ID = 0
    while 1:
        ID += 1
        yield "_id__%d__" % ID
SYM = symgen()

def maketree(pt):
    if type(pt) == list:        
        ren = []
        for node in pt:
            ren.append(maketree(node))
        return ren

    if type(pt) == unicode:
        return pt

    else:
        name = pt.__name__
        line = pt.__name__.line        
        return tbl(name)(name, line, maketree(pt.what))

class Node(object):
    def __init__(self, args):
        self.line = args[1]
        self.args = args[2:]

    def cls_name(self):
        return self.__class__.__name__
                
    def __repr__(self):
        args = ", ".join(map(str, self.args))
        return "(%s %s)" % (self.cls_name(), str(args))

class rawstring(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class dubstring(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class literal(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        lit = self.args[0]
        if lit == ".":
            return "compose"        
        if lit[0] == '"':
            if lit[-1] == '"':
                return "(SString %s)" % lit
        if "." in lit:
            return "(SFloat %s)" % lit
        else:
            lit = "(SInt %s)" % lit
        return lit

class symbol(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return self.args[0]

class lowername(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return str(self.args[0])

class uppername(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
        self.name = self.args[0]
    def __repr__(self):
        return self.name

class operator(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):        
        result = ''.join(self.args[0])
        lookup = {"*": "__mul__",
                  "+": "__add__",
                  "==": "__eq__",
                  "-": "__sub__",
                  "|": ";",
                  }
        if result in lookup:
            return lookup[result]
        else:
            return result

class name(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class dot(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class ident(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return str(self.args[0][0])

class param1(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return str(self.args[0][0])

class param2(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class param(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return str(self.args[0][0])

class parameterlist(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    
    def __repr__(self):
        return " ".join(map(str, self.args[0]))

'''
class expr(Node):
    def __init__(self, *args):
        Node.__init__(self, args)    
    def __repr__(self):
        print "------------------------------------------------------------------"
        print self.args
        return str(self.args[0][0])
'''

class klass(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class block(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

    def show_pure(self, kind):
        temp = " where {"
        for stmt in self.args[0]:
            temp += " ; %s" % stmt.show(kind)
        temp += "}"
        return temp      

    def show_io(self, kind):
        temp = ""
        for stmt in self.args[0]:
            if stmt == self.args[0][-1]:
                temp += "\n ; " + stmt.show_last_io()
            else:
                if stmt.isUnwrap():
                    temp += "\n ; %s" % stmt.show(kind)
                else:
                    temp += "\n ; let %s" % stmt.show(kind)

        temp += "\n}\n"
        return temp      
        
    def show(self, kind):
        if kind == "IO":
            return self.show_io(kind)
        if kind == "pure":
            return self.show_pure(kind)
        raise ValueError("Should have received either string 'IO' or 'pure'")

class method(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return str(self.args[0][0])

class method_io(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

    def __repr__(self):
        temp = "\n%s %s = do { %s"        
        a = self.args
        blk = a[0][2]
        result = temp % (a[0][0], a[0][1], blk.show("IO"))
        return result

class method_pure(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

    def __repr__(self):
        temp = "\n%s %s = __result__ %s\n"        
        a = self.args
        blk = a[0][2]
        result = temp % (a[0][0], a[0][1], blk.show("pure"))
        return result

           
class assign(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def show_last_io(self):
        return "return " + str(self.args[0][1])
        
    def __repr__(self):
        temp = "%s = %s"
        return temp % (self.args[0][0], self.args[0][1])

#def unwrap():           return ident, "<-", expr
class unwrap(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

    def show_last_io(self):
        return "return " + str(self.args[0][1])
        
    def __repr__(self):
        temp = "%s <- %s"
        return temp % (self.args[0][0], self.args[0][1])

class returnstmt(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

    def show_last_io(self):
        return str(self.args[0][0])

    def __repr__(self):
        return "__result__ = " + str(self.args[0][0])

class stmt(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    
    def isReturn(self):
        return self.args[0][0].cls_name() == "returnstmt"

    def isUnwrap(self):
        return self.args[0][0].cls_name() == "unwrap"
   
    def show(self, method_kind):
        return str(self.args[0][0])

    def show_last_io(self):
        return self.args[0][0].show_last_io()

    def __repr__(self):                
        return str(self.args[0][0])

class expr1(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):
        return " (" + ' '.join(map(str, self.args[0])) + ")"

class expr(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
    def __repr__(self):        
        #print "------------------------------------------------------------------"
        #print "%s" % str(self.args[0][0])        
        return ("%s " % str(self.args[0][0]))

class listsugar(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class mapsugar(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

class module(Node):
    def __init__(self, *args):
        Node.__init__(self, args)
        self.name = str(self.args[0][0])
    def __repr__(self):
        temp = "{-# LANGUAGE NoMonomorphismRestriction #-}\n"
        temp += "module %s where\n" % self.name
        temp += "import Debug.Trace\n"
        temp += "import SlurTypes\n"
        temp += "\n\n"
        for item in self.args[0][1:]:
            temp += str(item)        
        return  temp

class slurfile(Node):
    def __init__(self, *args):
        Node.__init__(self, args)

print (maketree(tree))





