defmodule Projectile do
  import Raytracer.Vector
  import Raytracer.Canvas

  def new(velocity), do: projectile({0, 0, 0, 0}, velocity)

  def projectile({x, y, z, w}, velocity) when y < 0, do: {{x, 0, z, w}, velocity}
  def projectile(position, velocity), do: {position, velocity}

  def projectile_position({position, velocity}, env) do
    new_velocity = add(velocity, env)
    new_position = add(position, new_velocity)

    {new_position, new_velocity}
  end

  def environment(gravity, wind), do: add(gravity, wind)

  def run(multipler \\ 10) do
    start = point(0, 1, 0)

    velocity =
      vector(1, 1.8, 0)
      |> normalize()
      |> mul(multipler)
      |> IO.inspect()

    p = projectile(start, velocity)

    gravity = vector(0, -0.1, 0)
    wind = vector(-0.01, 0, 0)
    e = environment(gravity, wind)

    c = canvas(1000, 1000)

    Stream.unfold(p, fn {pos, vel} ->
      if elem(pos, 1) > 0 do
        IO.puts("running")
        IO.inspect(pos)
        new_projectile = projectile_position({pos, vel}, e)
        {pos, new_projectile}
      else
        IO.puts("stop")
        nil
      end
    end)
    |> Enum.to_list()
    |> Enum.map(fn {x, y, _z, _w} -> {trunc(x), trunc(y)} end)
    |> IO.inspect()
    |> Raytracer.Canvas.fill_big_path(c)
    |> Raytracer.Canvas.write("projectile.ppm")
  end
end
