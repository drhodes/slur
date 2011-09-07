#! /usr/bin/env python
import sys
import re, fileinput
import pyPEG
from pyPEG import parse
#from pyPEG import keyword, _and, _not, ignore

# pyPEG:
#                    0: following element is optional
#                   -1: following element can be omitted or repeated endless
#                   -2: following element is required and can be repeated endless

def oneormore(x): return (-2, x)
def zeroormore(x): return (-1, x)
def commalist(x): return (x, -1, (",", x), 0, ",")

def comment():          return [re.compile(r";.*"), re.compile("/\*.*?\*/", re.S)]
def rawstring():        return [re.compile(r"`.*?`")]
def dubstring():        return [re.compile(r"\".*?`\"")]
def literal():          return re.compile(r'\d*\.\d*|\d+|".*?"')
def symbol():           return re.compile(r"\w+")
def lowername():        return re.compile(r'[a-z|_|-]\w+')
def uppername():        return re.compile(r'[A-Z]\w+')
#def operator():         return oneormore(list("|!@#$%^&*<>=+-"))
def operator():         return oneormore(re.compile(r'\+|\-|\@|\#|\$|\%|\^|\&|\*|\<|\>|\=|\||\{|\}|\\'))
def name():             return [uppername, lowername]
def dot():              return re.compile(r"\.")
def ident():            return 0, "@", symbol, -1, (".", symbol)
def param1():           return symbol
def param2():           return uppername, -2, symbol
def param():            return [param2, param1]
def parameterlist():    return 0, commalist(param)
def expr():             return "(", -1, ident, ")"
def block():            return zeroormore(stmt)
def klass():            return "(", "class", uppername, "(", parameterlist,  ")", -1, method, ")"
def method_pure():      return ( "(", "define", [lowername, operator],
                                 "(", parameterlist, ")", block, ")" )
def method_io():        return ( "(", "define", [lowername, operator], "IO",
                                 "(", parameterlist, ")", block, ")" )

def method():           return [method_pure, method_io]
def run():              return "run", expr
def assign():           return ident, "=", expr
def unwrap():           return ident, "<-", expr
def returnstmt():       return "return", expr
def stmt():             return [assign, returnstmt, rawstring, method, unwrap, run]
def expr1():            return "(", oneormore(expr), ")"
def expr():             return [literal, ident, expr1, listsugar, mapsugar, method, operator]
def listsugar():        return "[", 0, commalist(expr), "]"
def mapsugar():         return "{", zeroormore( ("(", expr, expr, ")") ), "}"
def module():           return "(", "module", uppername, -1, [klass, method, assign, rawstring], ")"
def slurfile():         return oneormore(module)

# simpleLanguage <- function;
def simpleLanguage():   return slurfile

pyPEG.print_trace = False

files = fileinput.input()

def parsetree():
    return parse( simpleLanguage(), 
                  files,
                  True,
                  comment,
                  lineCount = True,
                  )




