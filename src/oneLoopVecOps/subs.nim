
import ./macroutils
proc subsLeaves*(exp, idxVar: NimNode, identNodes: var seq[NimNode]): NimNode =
  result = exp.copyNimNode
  template addLeaf(n: NimNode) =
    result.add subsLeaves(n, idxVar, identNodes)
  case exp.kind
  of nnkIdent, nnkSym:
    result = exp.newBracket(idxVar)
    identNodes.add exp
  of nnkInfix:
    result.add exp[0]
    addLeaf exp[1]
    addLeaf exp[2]
  of nnkCall, nnkCommand:
    result.add exp[0]
    for i in 1..<exp.len:
      addLeaf exp[i]
  else:
    error "unconsidered node kind: " & $exp.kind, exp
