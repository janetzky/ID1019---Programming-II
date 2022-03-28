defmodule Memory do

  #def new() do
  #  new([])
  #end

 # def new(segments) do
 #   f = fn({start, data}, layout) ->
 #     last = start +  length(data) -1
 #     Enum.zip(start..last, data) ++ layout
 #   end
 #   layout = List.foldr(segments, [], f)
 #   {:mem, Map.new(layout)}
 # end


  def read(data, label) do
    data[label]
  end

 # def write(mem, i, v) do
    #{:mem, Map.put(mem, i, v)}
  #end

end