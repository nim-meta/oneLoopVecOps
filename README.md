# oneLoopVecOps

Expand ops of vectors via one loop over multiply.

For example,

```Nim
c = collectVecAsSeq a+b*c
```

will be expanded as sth roughly like:

```Nim
for i in 0||(a.len-1):  # `||` will use openMP if available
  c[i] = a[i] + b[i] + c[i]
```

which would be about *(n-1)* faster than using *n* loops.


