
import std/macros
import ./oneLoopVecOps/[impl]

macro collectVec*(initTWithLen: typed, vecExpr; len = DefLen): untyped = collectVecImpl(initTWithLen, vecExpr, len)

macro collectVecAsSeq*(vecExpr; len = DefLen): seq = collectVecImpl(bindSym"newSeqUninit", vecExpr, len)

when isMainModule:
  let
    a = [1, 2]
    b = [3, 4]
    c = collectVecAsSeq a + b * a

  echo c

