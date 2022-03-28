defmodule Primes do
  #c("primesStream.ex")
  #c("primesStream.ex") && z = Primes.z(3)
  #{_n, f} = Primes.filter(Primes.z(3), 2)

  def z(n) do
    fn() -> {n, z(n+1)} end
  end
  #c("primesStream.ex")
  #{_n, f} = Primes.filter(Primes.z(3), 2)
  #{_n, f} = f.()
  def filter(fun, f) do
    {n, fun} = fun.()
    if rem(n, f) == 0,
       do: filter(fun, f),
       else: {n, fn -> filter(fun, f) end}
    end

  #c("primesStream.ex")
  #{_n, f} = Primes.sieve(Primes.z(3), 2)
  #{_n, f} = f.()

  def sieve(func, prime) do
    {nextP, nextFunc} = filter(func, prime)
    {nextP, fn() -> sieve(nextFunc, nextP) end}
  end

  def primesOld() do
    fn() -> {2, fn() -> sieve(z(3), 2) end} end
  end

  defstruct [:next]

  defimpl Enumerable do
    def count(_) do {:error, __MODULE__} end
    def member?(_,_) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end

    def reduce(_, {:halt, acc}, _) do
      {:halted, acc}
    end
    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end

    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p,acc), fun)
    end
  end

  def next(%Primes{next: func}) do
    {next, nextFunc} = func.()
    {next, %Primes{next: nextFunc}}
  end

  def primes() do
    %Primes{next: fn() -> {2, fn() -> sieve(z(3), 2) end} end}
  end
end
