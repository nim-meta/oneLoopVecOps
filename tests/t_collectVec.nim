
import unittest

import oneLoopVecOps
test "pure ops":
  let
    a = [1, 2]
    b = [3, 4]
    c = collectVecAsSeq a + b * a

  check c == @[4, 10]


test "ops with function call within":
  func f(x: int): int = x + 1
  let
    a = [1, 2]
    b = [3, 4]
    c = collectVecAsSeq a + b * f(a)

  check c == @[7, 14]

test "ops with vec lit within":
  var cnt = 0
  proc valGen(): int =
    cnt.inc
    3

  check collectVecAsSeq([1, valGen()] + [valGen(), 2]) == @[4, 5]
  check cnt == 2  # test literal won't be evaluated multiple times

