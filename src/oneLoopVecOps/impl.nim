

import std/typetraits
import ./[macroutils, subs]
const DefLen* = -1  ## .. warning:: if `len` is DefLen, pick a arbitrary node to get length for loop

proc isDefLenNode(n: NimNode): bool =
  ## check if a node is a default length node
  n.kind == nnkIntLit and n.intVal == DefLen

proc collectVecImpl*(initTWithLen, vecExpr: NimNode, len = newLit DefLen): NimNode =
  ## .. warning:: if `len` is not given, pick a arbitrary node to get length for loop
  var exp = vecExpr
  if exp.kind == nnkStmtList:
    expectLen exp, 1
    exp = exp[0]
  assert exp.kind == nnkInfix

  let idxVar = genSym(nskForVar, "index")

  result = newStmtList()

  let resVar = genSym(nskVar, "collectRes")
  
  var loop = nnkForStmt.newTree(idxVar)
  

  var body = newStmtList()
  var identNodes: seq[NimNode]
  let nExpr = subsLeaves(exp, idxVar, result, identNodes)

  let nodeForLen = identNodes[0]

  let T = newCall(bindSym"elementType", nodeForLen)
  let len = if len.isDefLenNode: newCall("len", nodeForLen) else: len
  result.add newVarStmt(resVar, newCall(initTWithLen.newBracket(T), len))
  let rng = when defined(oneLoopVecNonParallelOps):
    infix(newLit 0, "..<", len)
  else:
    infix(newLit 0, "||", infix(len, "-", newLit 1))
  loop.add rng

  body.add newAssignment(resVar.newBracket(idxVar), nExpr)
  loop.add body

  result.add loop

  result.add resVar
