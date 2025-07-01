
import ./macroutils
proc subsLeaves*(exp, idxVar: NimNode, resStmt: var NimNode, identNodes: var seq[NimNode]): NimNode =
  result = exp.copyNimNode
  template addLeaf(n: NimNode) =
    result.add subsLeaves(n, idxVar, resStmt, identNodes)
  template addVecId(n) =
    result = n.newBracket(idxVar)
    identNodes.add n
  case exp.kind
  of nnkIdent, nnkSym:
    addVecId exp
  of nnkInfix:
    result.add exp[0]
    addLeaf exp[1]
    addLeaf exp[2]
  of nnkCall, nnkCommand:
    result.add exp[0]
    for i in 1..<exp.len:
      addLeaf exp[i]
  of nnkBracket, nnkTupleConstr:
    let litVar = genSym(nskLet, "vecLit")
    resStmt.add newLetStmt(litVar, exp)
    addVecId litVar
  else:
    error "unconsidered node kind: " & $exp.kind, exp
