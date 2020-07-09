defmodule Raytracer.CanvasTest do
  use ExUnit.Case, async: true

  import Raytracer.Canvas

  test "color" do
    c = color(-0.5, 0.4, 1.7)
    assert red(c) == -0.5
    assert green(c) == 0.4
    assert blue(c) == 1.7
  end

  test "hadamard_product" do
    c1 = color(1, 0.2, 0.4)
    c2 = color(0.9, 1, 0.1)
    assert hadamard_product(c1, c2) == color(0.9, 0.2, 0.04000000000000001)
  end

  test "create canvas" do
    c = canvas(10, 20)
    assert width(c) == 10
    assert height(c) == 20
    assert get_pixel(c, {0, 0}) == color(0, 0, 0)
  end

  test "set a pixel to color" do
    c = canvas(5, 5)
    red = color(1, 0, 0)
    c = set_pixel(c, 2, 3, red)
    assert get_pixel(c, 2, 3) == red
  end

  test "set a pixel out of canvas does not do anything" do
    c = canvas(2, 2)
    red = color(1, 0, 0)
    c = set_pixel(c, 2, 3, red)
    c = set_pixel(c, 1, 1, red)
    assert get_pixel(c, 2, 3) == nil
    assert get_pixel(c, 1, 1) == red
  end

  test "canvas to ppm header" do
    c = canvas(5, 3)

    canvas_to_ppm(c) =~ """
    P3
    5 3
    255
    """
  end

  test "canvas to ppm body" do
    c1 = color(1.5, 0, 0)
    c2 = color(0, 0.5, 0)
    c3 = color(-0.5, 0, 1)

    ppm =
      canvas(5, 3)
      |> set_pixel(0, 0, c1)
      |> set_pixel(2, 1, c2)
      |> set_pixel(4, 2, c3)
      |> canvas_to_ppm()

    assert ppm =~ """
           P3
           5 3
           255
           255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
           0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 
           0 0 0 0 0 0 0 0 0 0 0 0 0 0 255 
           """
  end

  test "canvas with a color body" do
    c = color(1, 0.8, 0.6)

    ppm =
      canvas(10, 2)
      |> fill_canvas(c)
      |> canvas_to_ppm()

    assert ppm =~ """
           255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 
           255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 
           255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 
           255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 
           """
  end
end
