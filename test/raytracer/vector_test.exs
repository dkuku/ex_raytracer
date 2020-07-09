defmodule Raytracer.VectorTest do
  use ExUnit.Case, async: true

  import Raytracer.Vector

  test "create a tuple primitive" do
    assert tuple(4.3, -4.2, 3.1, 1) == {4.3, -4.2, 3.1, 1}
  end

  test "create a point" do
    assert point(4, -3, 3) == tuple(4, -3, 3, 1)
  end

  test "create a vector" do
    assert vector(4, -3, 3) == tuple(4, -3, 3, 0)
  end

  describe "tuples" do
    test "adding" do
      t1 = tuple(3, 2, 1, 0)
      t2 = tuple(5, 6, 7, 8)
      assert add(t1, t2) == tuple(8, 8, 8, 8)
    end

    test "substracting" do
      t1 = tuple(3, 2, 1, 0)
      t2 = tuple(5, 6, 7, 8)
      assert sub(t1, t2) == tuple(-2, -4, -6, -8)
    end
  end

  describe "vectors" do
    test "adding two vectors" do
      v1 = vector(3, 2, 1)
      v2 = vector(5, 6, 7)
      assert add(v1, v2) == vector(8, 8, 8)
    end

    test "substracting two vectors" do
      v1 = vector(3, 2, 1)
      v2 = vector(5, 6, 7)
      assert sub(v1, v2) == vector(-2, -4, -6)
    end

    test "substracting from zero vector" do
      v1 = vector(0, 0, 0)
      v2 = vector(5, 6, 7)
      assert sub(v1, v2) == vector(-5, -6, -7)
    end

    test "negate vector" do
      assert negate(vector(5, 6, 7)) == vector(-5, -6, -7)
    end

    test "mul vector" do
      v = vector(5, 6, 7)
      assert mul(v, 3) == vector(15, 18, 21)
      assert mul(v, 1) == vector(5, 6, 7)
      assert mul(v, 0.5) == vector(2.5, 3, 3.5)
    end
  end

  test "substracting points" do
    p1 = point(3, 2, 1)
    p2 = point(5, 6, 7)
    assert sub(p1, p2) == vector(-2, -4, -6)
  end

  test "substracting vector from point" do
    p = point(3, 2, 1)
    v = vector(5, 6, 7)
    assert sub(p, v) == point(-2, -4, -6)
  end

  test "magnitude" do
    v = vector(1, 0, 0)
    assert magnitude(v) == 1

    v = vector(0, 1, 0)
    assert magnitude(v) == 1

    v = vector(0, 0, 1)
    assert magnitude(v) == 1

    v = vector(1, 2, 3)
    assert magnitude(v) == :math.sqrt(14)

    v = vector(-1, -2, -3)
    assert magnitude(v) == :math.sqrt(14)
  end

  test "normalize" do
    v = vector(4, 0, 0)
    assert normalize(v) == vector(1, 0, 0)

    v = vector(0, 2, 0)
    assert normalize(v) == vector(0, 1, 0)

    v = vector(0, 0, 5)
    assert normalize(v) == vector(0, 0, 1)

    v = vector(1, 2, 3)
    assert normalize(v) == vector(0.2672612419124244, 0.5345224838248488, 0.8017837257372732)

    v = vector(-1, -2, -3)
    assert normalize(v) == vector(-0.2672612419124244, -0.5345224838248488, -0.8017837257372732)
  end

  test "dot" do
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    assert dot(a, b) == 20
  end

  test "cross product" do
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    assert cross(a, b) == vector(-1, 2, -1)
    assert cross(b, a) == vector(1, -2, 1)
  end
end
