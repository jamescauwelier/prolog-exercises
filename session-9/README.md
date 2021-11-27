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

### Breadth-first vs depth-first

In my first attempts, I created a dedicated breadth-first implementation. Then I
wanted to also explore a depth-first approach after which I have created a
polymorphic implementation that can run both.

#### Breadth-first example

Running

```
?- flipper(queue, [3,1,2], S).
```

Returns

```
queue([path([[2,1,3],[3,1,2]]),path([[1,3,2],[3,1,2]])])
queue([path([[1,3,2],[3,1,2]]),path([[1,2,3],[2,1,3],[3,1,2]])])
queue([path([[1,2,3],[2,1,3],[3,1,2]]),path([[2,3,1],[1,3,2],[3,1,2]])])
S = path([[1, 2, 3], [2, 1, 3], [3, 1, 2]]).
```

#### Depth-first

Running

```
?- flipper(stack, [3,1,2], S).
```

Returns

```
stack([path([[2,1,3],[3,1,2]]),path([[1,3,2],[3,1,2]])])
stack([path([[1,2,3],[2,1,3],[3,1,2]]),path([[1,3,2],[3,1,2]])])
S = path([[1, 2, 3], [2, 1, 3], [3, 1, 2]]).
```

### Using a heuristic

TODO: I want to explore how I can also implement a greedy implementation of this
