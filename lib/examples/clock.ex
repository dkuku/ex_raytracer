defmodule Clock do
  alias Raytracer.{Vector, Canvas, Matrix}
  @height 1000
  @width 1000
  @radious 300
  @hours 12
  @pi :math.pi

  def run() do

    starting_point = Vector.point(0, 1, 0) 
    scale = Matrix.scaling(@radious, @radious, 0)
    translation = Matrix.translation(500, 500, 0)
    c = Canvas.canvas(@height, @width)
    for hour <- 0..@hours do
      r = Matrix.rotation_z(hour * @pi * 2 / @hours)
      
      Matrix.mul(starting_point, r)
    end
    |> Enum.map(fn point -> Matrix.mul(point, scale) end)
    |> Enum.map(fn point -> Matrix.mul(point, translation) end)
    |> Enum.map(fn {x, y, _z, _w} -> {trunc(x), trunc(y)} end)
    |> Raytracer.Canvas.fill_big_path(c)
    |> Raytracer.Canvas.write("clock.ppm")
  end
end

