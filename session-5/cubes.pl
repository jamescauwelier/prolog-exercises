% Action 1: selecting a block order (4 choose 4)
%
% Action 2: selecting the bottom face
%
% If a block is an array [1, 2, 3, 4, 5, 6]
% selecting one as the bottom gives an array of 4 visible
%
% when selecting 3 -> 3 and 6 are invisible
% [1, 4, 5, 2] are visible in that order walking around to the right
%
% Action 3: which face is front facing? what is the alignment index?
%
% What is the value of face1, face2 and face3 and are the faces unique?

cube1 = [triangle, star, triangle, rect, triangle, circle]
cube2 = [triangle, rect, circle, star, rect, star]
cube3 = [star, circle, star, rect, circle, triangle]
cube4 = [rect, star, triangle, rect, circle, circle]

% visibility1 = [4, 3, 2, 6]
% visibility2 = [1, 3, 5, 6]
% visibility3 = [4, 5, 2, 1]
% visibility4 = [6, 5, 3, 1]
% visibility5 = [6, 2, 3, 4]
% visibility6 = [1, 2, 5, 4]


standard_visibility(bottom(1), visibility([4, 3, 2, 6])).
standard_visibility(bottom(2), visibility([1, 3, 5, 6])).
standard_visibility(bottom(3), visibility([4, 5, 2, 1])).
standard_visibility(bottom(4), visibility([6, 5, 3, 1])).
standard_visibility(bottom(5), visibility([6, 2, 3, 4])).
standard_visibility(bottom(6), visibility([1, 2, 5, 4])).

% for each cube, we want to convert the symbols to face lists of symbols
% so pick a bottom




% converts a list of visible cube faces to stack face representations
% faces([[1, 2, 3], [2, 3, 1]], [[1, 2], [2, 3], [3, 1]])

cube_to_faces([cubeFaces([1,2,3], cubeFaces([2,3,1]))], [stackFace([1, 2])])

cube(
  [
    bottom(1, visibility([4, 3, 2, 6])),
    bottom(2, visibility([1, 3, 5, 6])),
    bottom(3, visibility([4, 5, 2, 1])),
    bottom(4, visibility([6, 5, 3, 1])),
    bottom(5, visibility([6, 2, 3, 4])),
    bottom(6, visibility([1, 2, 5, 4]))
  ]
  )

  cube(bottom(1), shift(0))

  [
  cube(1, bottom(1), shifted(0)),
  cube(2, bottom(3), shifted(1)),
  cube(3, bottom(6), shifted(0)),
  cube(4, bottom(2), shifted(5)),
  cube(5, bottom(2), shifted(4)),
  cube(6, bottom(1), shifted(0))
  ]

faces(bottom(1))
