defmodule Raytracer.MatrixTest do
  use ExUnit.Case, async: true

  import Raytracer.Matrix
  alias Raytracer.Vector

  test "create a 4x4 matrix" do
    m = matrix([[1, 2, 3, 4], [5.5, 6.5, 7.5, 8.5], [9, 10, 11, 12], [13.5, 14.5, 15.5, 16.5]])
    assert m[{0, 0}] == 1
    assert m[{0, 3}] == 4
    assert m[{1, 0}] == 5.5
    assert m[{1, 2}] == 7.5
    assert m[{2, 2}] == 11
    assert m[{3, 0}] == 13.5
    assert m[{3, 2}] == 15.5
  end

  test "create a 2x2 matrix" do
    n = matrix([[-3, 5], [1, -2]])
    assert n[{0, 0}] == -3
    assert n[{0, 1}] == 5
    assert n[{1, 0}] == 1
    assert n[{1, 1}] == -2
  end

  test "create a 3x3 matrix" do
    m = matrix([[-3, 5, 0], [1, -2, -7], [0, 1, 1]])
    assert m[{0, 0}] == -3
    assert m[{1, 1}] == -2
    assert m[{2, 2}] == 1
  end

  test "compare a 3x3 matrix" do
    m = matrix([[-3, 5, 0], [1, -2, -7], [0, 1, 1]])
    n = matrix([[-3, 5, 0], [1, -2, -7], [0, 1, 1]])
    o = matrix([[-1, 5, 0], [1, -2, -7], [0, 1, 1]])
    assert m == n
    assert m != o
  end

  test "multiplying two matrices" do
    a = matrix([[1, 2, 3, 4], [5, 6, 7, 8], [9, 8, 7, 6], [5, 4, 3, 2]])

    b =
      matrix([
        [-2, 1, 2, 3],
        [3, 2, 1, -1],
        [4, 3, 6, 5],
        [1, 2, 7, 8]
      ])

    assert mul(a, b) ==
             matrix([
               [20, 22, 50, 48],
               [44, 54, 114, 108],
               [40, 58, 110, 102],
               [16, 26, 46, 42]
             ])
  end

  test "matrix multiplied by a tuple" do
    a =
      matrix([
        [1, 2, 3, 4],
        [2, 4, 4, 2],
        [8, 6, 4, 1],
        [0, 0, 0, 1]
      ])

    b = Vector.tuple(1, 2, 3, 1)
    assert mul(a, b) == Vector.tuple(18, 24, 33, 1)
  end

  test "multiplying a matrix by the identity matrix" do
    a =
      matrix([
        [0, 1, 2, 4],
        [1, 2, 4, 8],
        [2, 4, 8, 16],
        [4, 8, 16, 32]
      ])

    assert mul(a, matrix(:identity)) == a
  end

  test "multiplying a tuple by the identity matrix" do
    a = Vector.tuple(1, 2, 3, 4)
    assert mul(matrix(:identity), a) == a
    assert mul(a, matrix(:identity)) == a
  end

  test "Transposing a matrix" do
    a =
      matrix([
        [0, 9, 3, 0],
        [9, 8, 0, 8],
        [1, 8, 5, 3],
        [0, 0, 5, 8]
      ])

    b =
      matrix([
        [0, 9, 1, 0],
        [9, 8, 8, 0],
        [3, 0, 5, 5],
        [0, 8, 3, 8]
      ])

    assert transpose(a) == b

    assert transpose(matrix(:identity)) == matrix(:identity)
  end

  test "Calculating the determinant of a 2x2 matrix" do
    a = matrix([[1, 5], [-3, 2]])
    assert determinant(a) == 17
  end

  test "A submatrix of a 3x3 matrix is a 2x2 matrix" do
    a =
      matrix([
        [1, 5, 0],
        [-3, 2, 7],
        [0, 6, -3]
      ])

    assert submatrix(a, 0, 2) ==
             matrix([
               [-3, 2],
               [0, 6]
             ])
  end

  test "A submatrix of a 4x4 matrix is a 3x3 matrix" do
    a =
      matrix([
        [-6, 1, 1, 6],
        [-8, 5, 8, 6],
        [-1, 0, 8, 2],
        [-7, 1, -1, 1]
      ])

    assert submatrix(a, 2, 1) ==
             matrix([
               [-6, 1, 6],
               [-8, 8, 6],
               [-7, -1, 1]
             ])
  end

  test "Calculating a minor of a 3x3 matrix" do
    a =
      matrix([
        [3, 5, 0],
        [2, -1, -7],
        [6, -1, 5]
      ])

    b = submatrix(a, 1, 0)
    assert determinant(b) == 25
    assert minor(a, 1, 0) == 25
  end

  test "Calculating a cofactor of a 3x3 matrix" do
    a =
      matrix([
        [3, 5, 0],
        [2, -1, -7],
        [6, -1, 5]
      ])

    assert minor(a, 0, 0) == -12
    assert cofactor(a, 0, 0) == -12
    assert minor(a, 1, 0) == 25
    assert cofactor(a, 1, 0) == -25
  end

  test "Calculating the determinant of a 3x3 matrix" do
    a =
      matrix([
        [1, 2, 6],
        [-5, 8, -4],
        [2, 6, 4]
      ])

    assert cofactor(a, 0, 0) == 56
    assert cofactor(a, 0, 1) == 12
    assert cofactor(a, 0, 2) == -46
    assert determinant(a) == -196
  end

  test "Calculating the determinant of a 4x4 matrix" do
    a =
      matrix([
        [-2, -8, 3, 5],
        [-3, 1, 7, 3],
        [1, 2, -9, 6],
        [-6, 7, 7, -9]
      ])

    assert cofactor(a, 0, 0) == 690
    assert cofactor(a, 0, 1) == 447
    assert cofactor(a, 0, 2) == 210
    assert cofactor(a, 0, 3) == 51
    assert determinant(a) == -4071
  end

  test "Testing an invertible matrix for invertibility" do
    a =
      matrix([
        [6, 4, 4, 4],
        [5, 5, 7, 6],
        [4, -9, 3, -7],
        [9, 1, 7, -6]
      ])

    assert determinant(a) == -2120
    assert invertible?(a)
  end

  test "Testing a noninvertible matrix for invertibility" do
    a =
      matrix([
        [-4, 2, -2, -3],
        [9, 6, 2, 6],
        [0, -5, 1, -5],
        [0, 0, 0, 0]
      ])

    assert determinant(a) == 0
    refute invertible?(a)
  end

  test " Calculating the inverse of a matrix" do
    a =
      matrix([
        [-5, 2, 6, -8],
        [1, -5, 1, 8],
        [7, 7, -6, -7],
        [1, -3, 7, 4]
      ])

    b = inverse(a)
    assert determinant(a) == 532
    assert cofactor(a, 2, 3) == -160
    assert val_at(b, [3, 2]) == -160 / 532
    assert cofactor(a, 3, 2) == 105
    assert val_at(b, [2, 3]) == 105 / 532

    assert b ==
             matrix([
               [
                 0.21804511278195488,
                 0.45112781954887216,
                 0.24060150375939848,
                 -0.045112781954887216
               ],
               [
                 -0.8082706766917294,
                 -1.4567669172932332,
                 -0.44360902255639095,
                 0.5206766917293233
               ],
               [
                 -0.07894736842105263,
                 -0.2236842105263158,
                 -0.05263157894736842,
                 0.19736842105263158
               ],
               [
                 -0.5225563909774437,
                 -0.8139097744360902,
                 -0.3007518796992481,
                 0.30639097744360905
               ]
             ])
  end

  test " Calculating the inverse of another matrix" do
    a =
      matrix([
        [8, -5, 9, 2],
        [7, 5, 6, 1],
        [-6, 0, 9, 6],
        [-3, 0, -9, -4]
      ])

    assert inverse(a) ==
             matrix([
               [
                 -0.15384615384615385,
                 -0.15384615384615385,
                 -0.28205128205128205,
                 -0.5384615384615384
               ],
               [
                 -0.07692307692307693,
                 0.12307692307692308,
                 0.02564102564102564,
                 0.03076923076923077
               ],
               [0.358974358974359, 0.358974358974359, 0.4358974358974359, 0.9230769230769231],
               [
                 -0.6923076923076923,
                 -0.6923076923076923,
                 -0.7692307692307693,
                 -1.9230769230769231
               ]
             ])
  end

  test " Calculating the inverse of a third matrix" do
    a =
      matrix([
        [9, 3, 0, 9],
        [-5, -2, -6, -3],
        [-4, 9, 6, 4],
        [-7, 6, 6, 2]
      ])

    assert inverse(a) ==
             matrix([
               [
                 -0.040740740740740744,
                 -0.07777777777777778,
                 0.14444444444444443,
                 -0.2222222222222222
               ],
               [
                 -0.07777777777777778,
                 0.03333333333333333,
                 0.36666666666666664,
                 -0.3333333333333333
               ],
               [
                 -0.029012345679012345,
                 -0.14629629629629629,
                 -0.10925925925925926,
                 0.12962962962962962
               ],
               [
                 0.17777777777777778,
                 0.06666666666666667,
                 -0.26666666666666666,
                 0.3333333333333333
               ]
             ])
  end
end
