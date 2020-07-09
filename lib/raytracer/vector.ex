defmodule Raytracer.Vector do
  def tuple(x, y, z, w), do: {x, y, z, w}
  def point(x, y, z), do: tuple(x, y, z, 1)
  def vector(x, y, z), do: tuple(x, y, z, 0)
  def add({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: {x1 + x2, y1 + y2, z1 + z2, w1 + w2}
  def sub({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: {x1 - x2, y1 - y2, z1 - z2, w1 - w2}
  def mul({x, y, z, w}, m), do: {x * m, y * m, z * m, w * m}
  def negate({x, y, z, w}), do: {-x, -y, -z, -w}
  def magnitude({a, b, c, d}), do: :math.sqrt(a * a + b * b + c * c + d * d)

  def normalize({a, b, c, d}) do
    mag = magnitude({a, b, c, d})

    if mag == 1 do
      {a, b, c, d}
    else
      {a / mag, b / mag, c / mag, d / mag}
    end
  end

  def dot({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2
  end

  def cross({x1, y1, z1, _}, {x2, y2, z2, _}) do
    vector(y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2)
  end
end
