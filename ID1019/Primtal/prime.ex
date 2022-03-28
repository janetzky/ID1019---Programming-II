defmodule Prime do

  ### Första uppgiften ###

  def start(n) do
    [h|t] = Enum.to_list(2..n)
    [h|only_primes(h, t)]
  end

  def only_primes(x, []) do [] end
  def only_primes(x, [h|t]) do
    [h|only_primes(h, Enum.filter(t, fn y -> rem(y, x) != 0 end))]
  end
end

defmodule Prime2 do

  def start(n) do
    only_primes(Enum.to_list(2..n), [])
  end

  def only_primes([], p)do p end
  def only_primes([h|t], prime) do
  if Enum.filter(prime, fn y -> rem(h, y) == 0 end) == [],
   do: only_primes(t, prime++ [h]),
   else: only_primes(t, prime)
  end

end

defmodule Prime3 do

  def start(n) do
    Enum.reverse(only_primes(Enum.to_list(2..n), []))
  end

  def only_primes([], prime)do prime end
  def only_primes([h|t], prime) do
    if Enum.filter(prime, fn y -> rem(h, y) == 0 end) == [],
       do: only_primes(t, [h | prime]),
       else: only_primes(t, prime)
  end
end
  defmodule TimeTest do

    def time(n) do
    {uSecs1, _} = :timer.tc(fn n -> Prime.start(n) end, [n])
    {uSecs2, _} = :timer.tc(fn n -> Prime2.start(n) end, [n])
    {uSecs3, _} = :timer.tc(fn n -> Prime3.start(n) end, [n])
    {uSecs1, uSecs2, uSecs3}
    end

end

