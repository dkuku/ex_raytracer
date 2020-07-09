defmodule Raytracer.Canvas do
  @black {0, 0, 0}
  @white {1, 1, 1}

  def color(r, g, b), do: {r, g, b}
  def red({r, _, _}), do: r
  def green({_, g, _}), do: g
  def blue({_, _, b}), do: b
  def cadd({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}
  def csub({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}
  def cmul({x, y, z}, m), do: {x * m, y * m, z * m}
  def hadamard_product({r1, g1, b1}, {r2, g2, b2}), do: {r1 * r2, g1 * g2, b1 * b2}

  def canvas(width, height, color \\ @black) do
    for x <- 0..(width - 1), y <- 0..(height - 1) do
      {{x, y}, color}
    end
    |> Map.new()
    |> Map.merge(%{width: width, height: height})
  end

  def pixel(x, y), do: {x, y}
  def width(canvas), do: canvas.width
  def height(canvas), do: canvas.height
  def get_pixel(canvas, pixel), do: Map.get(canvas, pixel)
  def get_pixel(canvas, x, y), do: Map.get(canvas, pixel(x, y))

  def set_pixel(%{width: w, height: h} = canvas, x, y, color)
      when 0 <= x and x < w and 0 <= y and y < h do
    Map.replace!(canvas, {x, y}, color)
  end

  def set_pixel(canvas, _x, _y, _color), do: canvas
  def set_pixel(canvas, {x, y}, color), do: set_pixel(canvas, x, y, color)

  def cast_color(c) when c < 0, do: "0"
  def cast_color(c) when c > 1, do: "255"
  def cast_color(c), do: Integer.to_string(trunc(c * 255))

  def color_to_pixel({r, g, b}) do
    [cast_color(r), " ", cast_color(g), " ", cast_color(b), " "]
  end

  def canvas_to_ppm(%{width: width, height: height} = canvas) do
    header = ppm_header(width, height)
    body = ppm_body(canvas)

    [header | body]
    |> Enum.map_every(5, fn pixel -> [pixel, "\n"] end)
    |> IO.iodata_to_binary()
  end

  def ppm_body(%{width: width, height: height} = canvas) do
    for x <- 0..(width - 1), y <- 0..(height - 1) do
      get_pixel(canvas, x, y)
    end
    |> Enum.map(fn col -> color_to_pixel(col) end)
  end

  def fill_canvas(canvas, color) do
    run_for_every_pixel(canvas, fn coord, c -> set_pixel(c, coord, color) end)
  end

  def fill_path(path, canvas, color \\ @white) do
    run_for_pixel_group(path, canvas, fn coord, c -> set_pixel(c, coord, color) end)
  end

  def run_for_pixel_group(group, canvas, function) do
    group |> Enum.reduce(canvas, function)
  end

  def run_for_every_pixel(%{width: width, height: height} = canvas, function) do
    for x <- 0..(width - 1), y <- 0..(height - 1) do
      pixel(x, y)
    end
    |> run_for_pixel_group(canvas, function)
  end

  defp ppm_header(width, height) do
    "P3\n#{width} #{height}\n255"
  end

  def write(image, name) do
    {:ok, fd} = File.open(name, [:write])
    IO.puts(fd, canvas_to_ppm(image))
    File.close(fd)
  end
end
