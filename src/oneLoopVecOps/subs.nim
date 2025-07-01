
import ./macroutils
proc subsInfixLeaves*(infixExpr, idxVar: NimNode): NimNode =
  ## LIMIT: only for sure works for infix expressions, no sure if works for other types
  infixExpr.expectKind nnkInfix
  result = infixExpr.copyNimNode
  result.add infixExpr[0]
  let
    lhs = infixExpr[1]
    rhs = infixExpr[2]
  template addLeaf(n) =
    result.add if n.len == 0: n.newBracket(idxVar) else: subsInfixLeaves(n, idxVar)
  addLeaf lhs
  addLeaf rhs
