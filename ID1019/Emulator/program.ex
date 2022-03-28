defmodule Program do

  def assemble(prgm) do
    {:code, List.to_tuple(prgm)}
  end

  def read(code, pc) do
    pc = div(pc, 4)
    Enum.at(code, pc)
  end

  def load({:prgm, code, data}) do
    {code, data}
  end


end