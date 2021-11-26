# Pancake flip

Assume a series of numbers that are representative for the size of a pancake:

```
task = [3,5,4,1,2]
```

Assumptions:
- for a list with length n
- every task contains every element from 1 to n

```
goal = [1,2,3,4,5]
```

Limitations:
- you may only pick the first k elements with k <= n
- the order of those first k is inversed
- repeat until a solution is found

## Task generation

First, we want to generate permutations of a list of 1 to n. These are our tasks
that our algorithm needs to sort by flipping.

I use this to generate tasks, but I don't automatically connect this to the solver.

Running

```
?- generateStacksOfSize(3, S).
```

generates

```
S = [[3, 2, 1], [2, 3, 1], [3, 1, 2], [1, 3, 2], [2, 1, 3], [1, 2, 3]] ;
false.
```

## Solution Approaches

### Breadth-first

Running

```
?- flipper([3,1,2], S).
```

Returns (prints the fringe on every line and then a solution in the end):

```
[[[1,3,2],[3,1,2]],[[2,1,3],[3,1,2]]]
[[[2,1,3],[3,1,2]],[[3,1,2],[1,3,2],[3,1,2]],[[2,3,1],[1,3,2],[3,1,2]]]
[[[3,1,2],[1,3,2],[3,1,2]],[[2,3,1],[1,3,2],[3,1,2]],[[1,2,3],[2,1,3],[3,1,2]],[[3,1,2],[2,1,3],[3,1,2]]]
[[[2,3,1],[1,3,2],[3,1,2]],[[1,2,3],[2,1,3],[3,1,2]],[[3,1,2],[2,1,3],[3,1,2]],[[1,3,2],[3,1,2],[1,3,2],[3,1,2]],[[2,1,3],[3,1,2],[1,3,2],[3,1,2]]]
[[[1,2,3],[2,1,3],[3,1,2]],[[3,1,2],[2,1,3],[3,1,2]],[[1,3,2],[3,1,2],[1,3,2],[3,1,2]],[[2,1,3],[3,1,2],[1,3,2],[3,1,2]],[[3,2,1],[2,3,1],[1,3,2],[3,1,2]],[[1,3,2],[2,3,1],[1,3,2],[3,1,2]]]
S = [[1, 2, 3], [2, 1, 3], [3, 1, 2]].
```

### Using a heuristic
