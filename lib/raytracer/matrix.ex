defmodule Raytracer.Matrix do
  require Integer
  def matrix(rows, size \\ 4)

  def matrix(:identity, size) do
    for x <- 0..(size - 1), y <- 0..(size - 1) do
      val = if x == y, do: 1, else: 0
      {{x, y}, val}
    end
    |> Map.new()
  end

  def matrix(rows, _size) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {val, j} ->
        {{i, j}, val}
      end)
    end)
    |> Map.new()
  end

  def val_at(m, x, y), do: Map.get(m, {x, y})
  def val_at(m, [x, y]), do: Map.get(m, {x, y})
  def val_at(m, {x, y}), do: Map.get(m, {x, y})

  def mul(m1, m2) when is_map(m1) and is_map(m2) do
    for x <- 0..3, y <- 0..3 do
      val =
        Map.get(m1, {x, 0}) * Map.get(m2, {0, y}) +
          Map.get(m1, {x, 1}) * Map.get(m2, {1, y}) +
          Map.get(m1, {x, 2}) * Map.get(m2, {2, y}) +
          Map.get(m1, {x, 3}) * Map.get(m2, {3, y})

      {{x, y}, val}
    end
    |> Map.new()
  end

  def mul(t, m) when is_tuple(t), do: mul(m, t)

  def mul(m, t) when is_tuple(t) do
    [a, b, c, d] =
      for x <- 0..3 do
        Map.get(m, {x, 0}) * elem(t, 0) +
          Map.get(m, {x, 1}) * elem(t, 1) +
          Map.get(m, {x, 2}) * elem(t, 2) +
          Map.get(m, {x, 3}) * elem(t, 3)
      end

    {a, b, c, d}
  end

  def transpose(m) do
    for x <- 0..3, y <- 0..3 do
      {{x, y}, Map.get(m, {y, x})}
    end
    |> Map.new()
  end

  def determinant(m, size \\ nil)

  def determinant(m, nil) do
    {max_x, _max_y} = get_matrix_size(m)
    determinant(m, max_x)
  end

  def determinant(m, 1) do
    Map.get(m, {0, 0}) * Map.get(m, {1, 1}) -
      Map.get(m, {0, 1}) * Map.get(m, {1, 0})
  end

  def determinant(m, _) do
    {max, max} = get_matrix_size(m)
    current_row = 0

    for y <- 0..max do
      current_val = Map.get(m, {current_row, y})
      current_val * cofactor(m, current_row, y)
    end
    |> Enum.sum()
  end

  def submatrix(m, row, col) do
    {max_x, max_y} = get_matrix_size(m)

    for x <- 0..(max_x - 1), y <- 0..(max_y - 1) do
      current_x = if x >= row, do: x + 1, else: x
      current_y = if y >= col, do: y + 1, else: y
      val = Map.get(m, {current_x, current_y})

      {{x, y}, val}
    end
    |> Map.new()
  end

  def minor(m, x, y) do
    m
    |> submatrix(x, y)
    |> determinant()
  end

  def cofactor(m, x, y) do
    m
    |> minor(x, y)
    |> maybe_inverse_for_cofactor(x, y)
  end

  def inverse(m) do
    det = determinant(m)

    if det == 0 do
      {:error, "matrix not invertible"}
    else
      {max, max} = get_matrix_size(m)

      for x <- 0..max, y <- 0..max do
        c = cofactor(m, x, y)
        {{y, x}, c / det}
      end
      |> Map.new()
    end
  end

  def invertible?(m), do: determinant(m) != 0
  def get_matrix_size(m), do: m |> Map.keys() |> Enum.max()
  def maybe_inverse_for_cofactor(val, x, y) when Integer.is_odd(x + y), do: -1 * val
  def maybe_inverse_for_cofactor(val, _x, _y), do: val
end
