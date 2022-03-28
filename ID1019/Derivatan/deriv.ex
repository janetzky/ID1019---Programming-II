defmodule Deriv do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
                 | {:add, expr(), expr()}
                 | {:mul, expr(), expr()}
                 | {:expr, expr(), literal()}
                 | {:ln, expr()}
                 | {:frac, expr(), expr()}
                 | {:sqrt, expr()}
                 | {:sin, expr()}
                 | {:cos, expr()}


  ### TEST FUNKTION1###
  def test1()do
    e = {:add,
          {:mul, {:num, 3}, {:var, :x}},
          {:num, 4 }}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end


  ### TEST FUNKTION2###
  def test2()do
    e = {:add,
      {:exp, {:var, :x}, {:num, 3}},
      {:num, 4 }}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  ### TEST FUNKTION för x^n###
  def test3()do
    e =
      {:exp, {:var, :x}, {:var, :y}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  ### TEST FUNKTION för ln(x)###
  def test4()do
    e ={:mul,
      {:ln, {:var, :x}}, {:num, 3}}
    d = deriv(e, :x)
    c = calc(simplify(d), :x, 6)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  ### TEST FUNKTION för 1/x###
  def test5()do

    e = {:frac,{:num, 1}, {:var, :x}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  ### TEST FUNKTION för roten ur x###
  def test6()do

    e = {:sqrt, {:var, :x}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  ### TEST FUNKTION för sin(x)###
  def test7()do

    e = {:sin, {:mul, {:var, :x}, {:num, 5}}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end


### DERIVERINGS REGLER###
  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul,{:num, n}, {:exp, e, {:num, n-1 }}},
        deriv(e, v)}
  end
  ##### Derivering av x^n
  def deriv({:exp, e, {:var, n}}, v) do
    {:mul,
      {:mul,{:var, n}, {:exp, e, {:sub, {:var, n}, {:num, 1}}}},
      deriv(e, v)}
  end
  ##### Derivering av ln(x)
  def deriv({:ln, e}, v) do
    {:frac, deriv(e, v), e}
  end

  ##### Derivering av 1/x
  def deriv({:frac, e1, e2}, v) do
    {:frac,
      {:add,
        {:mul, deriv(e1, v), e2},
        {:mul,
          {:mul, e1, deriv(e2, v)},
          {:num, -1}
        }
      },
      {:exp, e2, {:num, 2}}
    }
  end

  ##### Derivering av Roten ur x
  def deriv({:sqrt, e}, v)do
    {:frac,
    {:num, 1},
      {:mul, {:num, 2}, {:sqrt, e}}
    }
  end

  ##### Derivering av sin x
  def deriv({:sin, e}, v)do
    {:mul, deriv(e, v), {:cos, e}}
  end

  def deriv({:cos, e}, v) do
    {:mul, deriv(e, v), {:sin, e}}
  end

  ### Calculations ###
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:sub, e1, e2}, v, n) do
    {:sub, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:frac, e1, e2}, v, n) do
    {:frac, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:sqrt, e1,}, v, n) do
    {:sqrt, calc(e1, v, n)}
  end

  def calc({:cos, e1,}, v, n) do
    {:cos, calc(e1, v, n)}
  end

  def calc({:sin, e}, v, n) do
    {:sin, calc(e, v, n)}
  end


### FÖRENKLINGAR AV UTTRYCK###
  def simplify({:add, e1, e2}) do
  simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:frac, e1, e2}) do
    simplify_frac(simplify(e1), simplify(e2))
  end

  def simplify({:sqrt, e1}) do
    simplify_sqrt(simplify(e1))
  end

  def simplify({:cos, e1}) do
    simplify_cos(simplify(e1))
  end

  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end


  def simplify_mul({:num, 0}, e2) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:frac, {:num, n1}, e},{:num, n2}) do {:frac, {:num, n1 * n2}, e} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end


  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_frac(e1, {:num, 1}) do e1 end
  def simplify_frac({:num, 0}, _) do {:num, 0} end
  def simplify_frac({:num, n1}, {:num, n2}) do {:num, (n1/n2)} end
  def simplify_frac(e1, e2) do {:frac, e1, e2} end

  def simplify_sqrt({:num, 0}) do {:num, 0} end
  def simplify_sqrt({:num, 1}) do {:num, 1} end
  def simplify_sqrt({:num, n1}) do{:num, :math.sqrt(n1)}  end
  def simplify_sqrt(e) do {:sqrt, e} end

  def simplify_cos({:num, n1}) do  {:num, :math.cos(n1)} end
  def simplify_cos(e) do {:cos, e} end

  def simplify_sin({:num, n1}) do {:num, :math.sin(n1)} end
  def simplify_sin(e) do {:sin, e} end


  ### PRINTFUNKTIONER###
  def pprint({:num, n})       do "#{n}" end
  def pprint({:var, v})       do "#{v}" end
  def pprint({:add, e1, e2})  do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:sub, e1, e2})  do "(#{pprint(e1)} - #{pprint(e2)})" end
  def pprint({:mul, e1, e2})  do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2})  do "(#{pprint(e1)}) ^ (#{pprint(e2)})" end
  def pprint({:ln, e})        do "ln(#{pprint(e)})" end
  def pprint({:frac, e1, e2}) do "(#{pprint(e1)}/(#{pprint(e2)}))" end
  def pprint({:sqrt, e})      do "sqrt(#{pprint(e)})" end
  def pprint({:sin, e})      do "sin(#{pprint(e)})" end
  def pprint({:cos, e})      do "cos(#{pprint(e)})" end

end
