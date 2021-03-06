defmodule Mandelbrot do
  defmodule Cmplx do
    def new(real,im) do {:complex, real, im} end

    def add({:complex, r1, i1},{:complex, r2, i2}) do
      {:complex, r1 + r2, i1 + i2}
    end
    #(x+yi)^2 = x^2-y^2+2*x*y
    def sqr({:complex, real, im}) do
      {:complex, real*real - im*im, 2*real*im}
    end
    #Absoulutbeloppet, pytte sats typ
    def abs({:complex, r, i}) do :math.sqrt((r*r + i*i)) end
  end

  # För att testa brot
  # Mandelbrot.Brot.mandelbrot(Mandelbrot.Cmplx.new(0.8,0),30)
  # Mandelbrot.Brot.mandelbrot(Mandelbrot.Cmplx.new(0.5,0),30)
  # Mandelbrot.Brot.mandelbrot(Mandelbrot.Cmplx.new(0.3,0),30)
  #
  defmodule Brot do
    #
    # c är det komplexa talet medan m är det maximala antalet iterations, även kallat djupet.
    #
    #
    def mandelbrot(c,m) do
      z0 = Cmplx.new(0,0)
      test(0,z0,c,m)
    end

    def test(max, _z , _c , max) do 0 end
    def test(i, z, c, max) do
      if (Cmplx.abs(z)) <= 2.0 do
        test(i+1, Cmplx.add(Cmplx.sqr(z),c), c, max)
      else
        i
      end
    end
  end

  defmodule PPM do
    # write(name, image) The image is a list of rows, each row a list of
    # tuples {R,G,B}. The RGB values are 0-255.
    def write(name, image) do
      height = length(image)
      width = length(List.first(image))
      {:ok, fd} = File.open(name, [:write])
      IO.puts(fd, "P6")
      IO.puts(fd, "#generated by ppm.ex")
      IO.puts(fd, "#{width} #{height}")
      IO.puts(fd, "255")
      rows(image, fd)
      File.close(fd)
    end

    def rows(rows, fd) do
      Enum.each(rows, fn(r) ->
        colors = row(r)
        IO.write(fd, colors)
      end)
    end

    def row(row) do
      List.foldr(row, [], fn({:rgb, r, g, b}, a) ->
        [r, g, b | a]
      end)
    end
  end




  defmodule Color do
    @type color :: {:rgb, 0..255, 0..255, 0..255}
    @spec convert(number, number) :: color

    #def convert(depth, max) when depth > max do {:error, "Depth > max"} end
    def convert(depth, max) do
      a = (depth / max) * 4
      x = trunc(a)
      y = round((255) * (a - x))
      case x do
        0 -> {:rgb, 0, 0, y}
        1 -> {:rgb, 0, y, 255}
        2 -> {:rgb, 0, 255, 255 - y}
        3 -> {:rgb, y, 255, 0}
        4 -> {:rgb, 255, 255 - y, 0}
      end
    end
  end

  defmodule Mandel do

    #Mandelbrot.Mandel.demo()
    def demo() do
      small(-2.6, 1.2, 1.2)
    end

    def small(x0, y0, xn) do
      width = 3840
      height = 2160
      depth = 500
      k = (xn - x0) / width
      image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
      PPM.write("small.ppm", image)
    end

    def mandelbrot(width, height, x, y, k, depth) do
      trans = fn(w, h) ->
        Cmplx.new(x + k * (w - 1), y - k * (h - 1))
      end

      rows(width, height, trans, depth, [])
    end

    def rows(_, 0, _, _, rows) do rows end
    def rows(width, height, trans, depth, rows) do
      rows(width, height - 1, trans, depth, [row(width, height, trans, depth, []) | rows])
    end

    def row(0, _, _, _, row) do row end
    def row(width, height, trans, depth, row) do
      color = Color.convert(Brot.mandelbrot(trans.(width, height), depth), depth)
      row(width - 1, height, trans, depth, [color | row])
    end

  end
end