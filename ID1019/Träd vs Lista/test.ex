defmodule Second do

  def second(n) do
    list = Enum.to_list(2..n)
    second(list, [])
  end

  def insertPrime(bool, x, primes) do
    case bool do
      true -> primes ++ [x]
      false -> primes
    end
  end

  def checkPrime(_, []) do true end
  def checkPrime([h|t], primes = [h2|t2]) do
    cond do
      rem(h, h2) == 0 ->
        false
      true -> checkPrime([h|t], t2)
    end
  end

  def second(list, primes) do
    case list do
      [] -> primes
      [h|t] ->
        bool = checkPrime(list, primes)
        primes = insertPrime(bool, h, primes)
        second(t, primes)
    end
  end

end

defmodule Third do

  def third(n) do
    list = Enum.to_list(2..n)
    third(list, [])
  end

  def insertPrime(bool, x, primes) do
    case bool do
      true -> [x] ++ primes
      false -> primes
    end
  end

  def checkPrime(_, []) do true end
  def checkPrime([h|t], primes = [h2|t2]) do
    cond do
      rem(h, h2) == 0 ->
        false
      true -> checkPrime([h|t], t2)
    end
  end

  def third(list, primes) do
    case list do
      [] -> Enum.reverse(primes)
      [h|t] ->
        bool = checkPrime(list, primes)
        primes = insertPrime(bool, h, primes)
        third(t, primes)
    end
  end
end

defmodule Bench do

  def bench(n) do
    IO.inspect(:timer.tc(fn -> First.first(n) end))
    IO.inspect(:timer.tc(fn -> Second.second(n) end))
    IO.inspect(:timer.tc(fn -> Third.third(n) end))

    :ok
  end

end