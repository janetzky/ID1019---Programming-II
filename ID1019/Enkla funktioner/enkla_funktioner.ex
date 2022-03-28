defmodule Enkla_funktioner do

  def double(n) do
    (n * 2)
  end

  def fahr(f) do
    ((f-32)/1.8)
  end

  def rectangle(n, m) do
    n * m
  end

  def square (n) do
    rectangle(n, n)
  end

  def circle (r) do
    (:math.pi * (:math.pow(r,2)))
  end


  #### MATTE ####


  # Produkten med if o else
  def product(m, n) do
    if m == 0 do
      0
    else
      (n + product(m-1,n))
    end
  end
  # Samma funktion som ovan fast används av cases ist
  def product_case(m, n) do
    case m do
      0 ->
        0
      _ ->
        (n + product_case(m-1,n))
    end
  end

  # Samma funktion som ovan fast används av conditions ist
  def product_cond(m, n) do
    cond do
      m == 0 ->
        0
      true ->
        (n + product_cond(m-1,n))
    end
  end

  def exp(x, n) do
    case n do
      1 -> x
      _ -> product(x, exp(x, n - 1))
    end
  end

  def quick_exp(x, n) do
    cond do
      n == 1 -> x
      rem(n, 2) == 0 ->
         y = (exp(x, div(n, 2)))
         y * y
      true ->
         x * (exp(x, n - 1))
    end
  end


  #### LISTOR ####

  #Räknar ut the nth elementet
  def nth(n, [head | tail]) do
    cond do
      n == 1 ->
        head
      true ->
        nth(n-1, tail)
    end
  end
  # Beräknar längden på arrayen
  def len([]) do 0 end
  def len([head | tail]) do  len(tail) + 1 end

  # Beräknar summan av arrayen
  def sum([]) do 0 end
  def sum([head | tail]) do sum(tail) + head end

  def duplicate(l) do

  end


end
