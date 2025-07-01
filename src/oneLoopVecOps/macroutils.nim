
import std/macros
export macros

proc newBracket*(a, i: NimNode): NimNode = nnkBracketExpr.newTree(a, i)  

