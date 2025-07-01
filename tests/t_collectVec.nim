
import unittest

import oneLoopVecOps
test "pure ops":
  let
    a = [1, 2]
    b = [3, 4]
    c = collectVecAsSeq a + b * a

  check c == @[4, 10]

