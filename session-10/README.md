# Session 10

## Mergesort

## Search

### Missionaries and cannibals.

Suppose 3 missionaries and 3 cannibals are walking together through the forest. They arrive at a river they have to cross, but there is only one boat, and that boat can carry at most 2 people. Of course, for the boat to cross the river, there should be at least one person (missionary or cannibal) in the boat (to row the boat). The problem is that if there are more cannibals than missionaries at any place, they will eat the missionaries.
Write a program that finds a strategy for the six people to cross the river without a missionary being eaten.

As usual it is important to think about a good representation for the problem. You can choose the representation for the input and output of the problem yourself, but make sure that, given the output of your program, it is clear how to solve the problem.

#### Solution

##### State representation 1

```prolog
riverCrossing(Left, Boat, Right).
```

**Start**

```prolog
riverCrossing([m, m, m, c, c, c], [nil, nil], []).
```

**Goal state**

```prolog
riverCrossing([], [nil, nil], [m, m, m, c, c, c]).
```

##### Attempt 2

###### State encoding

```prolog
river(bank(m(3), c(3)), boat(seat(nil), seat(nil), left), bank(m(0), c(0))).
```

Comments:
- more semantically expressive
- counts because it doesn't matter which missionary or cannibal gets moved, only their relative amounts
- boat might need to be a small array, depending on the implementation
- position of the boat might not be necessary
  - we could limit the exercise to not allow unboarding on the same bank
  - we could further limit boarding only left and unboarding only right

###### Actions

The boat can be boarded with 1 -> 2 missionaries or cannibals, with a max of 2 in total.

```prolog
board(m(0), c(2)).
board(m(0), c(0)).
board(m(1), c(1)).
board(m(1), c(0)).
board(m(0), c(1)).
board(m(2), c(0)).
```

The boat can be unboarded fully or partially.

```prolog
unboard(m(0), c(2)).
unboard(m(0), c(0)).
unboard(m(1), c(1)).
unboard(m(1), c(0)).
unboard(m(0), c(1)).
unboard(m(2), c(0)).
```

The boat can cross the river, changing it's location, which will determine the effect of an unboarding.

```prolog
cross()
```

###### Validating actions

Since the actions are simple structures and nothing more, we need to know whether an action can be applied to a state.

```prolog
can_be_applied_to(action(...), state).
```

This needs implementations like

```prolog
can_be_applied_to(cross(), state).
```

###### Executing actions

Similarly, executing the actions can be matched against structures.

```prolog
execute(action(...), state, newState).
```

### Water jugs

You need to get 8 liter of water from a river. You only have a 15 liter jug and a 16 liter jug. How can you obtain 8 liter using only these two jugs (possible operations are: emptying a jug entirely, filling a jug entirely and emptying one jug in the other)?
Write a program to solve this problem. Try to write your program such that it finds the shortest solution.
