Test case 1

Input:

```
1+2
```

Output:

```
NUM 1
PLUS
NUM 2
```

Test case 2

Input:

```
(1+
  -2
  )
```

Output:

```
LPR
NUM 1
PLUS
MINUS
NUM 2
RPR
```

Test case 3

Input:

```
    (
(1 +
 2 * 3
 / 4    )
 )
```

Output:

```
LPR
LPR
NUM 1
PLUS
NUM 2
MUL
NUM 3
DIV
NUM 4
RPR
RPR
```
