defmodule Lumberjack do

  def split(seq) do
    split(seq, Enum.sum(seq),[],[])
  end

  def split([], length, left, right) do
    [{left,right,length}]
  end

  def split([s|rest], l, left, right) do
    split(rest, l, [s]++ left , right ) ++ split(rest, l, left, [s]++ right)
  end
                ################# COST #############
                    ###########################
  def cost([]) do 0 end
  def cost([h]) do {0,h} end
  def cost(seq) do cost(seq, 0, [], []) end

  def cost([], l, left, right) do
    {costLeft, treeLeft} = cost(left)
    {costRight, treeRight} = cost(right)
    {costLeft+costRight+l, {treeLeft, treeRight}}
  end
  def cost([s], l, [], right) do
    {costRight, treeRight} = cost(right)
    {costRight+l+s, {s, treeRight}}
  end
  def cost([s], l, left, []) do
    {costLeft, treeLeft} = cost(left)
    {costLeft+l+s, {s, treeLeft}}
  end


  def cost([s|rest], l, left, right) do
    {costLeft, treeLeft} = cost(rest, l+s, [s|left], right)
    {costRight, treeRight} = cost(rest, l+s, left, [s|right])

    if costLeft < costRight do
      {costLeft, treeLeft}
    else
      {costRight, treeRight}
    end
  end
  #######################################Cost2#######################################
          #################################################################

  def cost2([]) do {0, :na} end
  def cost2(seq) do
    {cost, tree, _} = cost2(Enum.sort(seq), Memo.new())
    {cost, tree}
  end

  ###

  def cost2([s], mem) do {0, s, mem} end
  def cost2([s|rest]=seq, mem) do
    {c, t, mem} = cost2(rest, s, [s], [], mem)
    {c, t, Memo.add(mem, seq, {c, t})}
  end
  def cost2([], l, left, right, mem) do
    {costLeft, tl, mem} = check(Enum.reverse(left), mem)
    {cr, tr, mem} = check(Enum.reverse(right), mem)
    {cr+costLeft+l, {tl, tr}, mem}
  end
  def cost2([s], l, left, [], mem) do
    {c, t, mem} = check(Enum.reverse(left), mem)
    {c+s+l, {t, s}, mem}
  end
  def cost2([s], l, [], right, mem) do
    {c, t, mem} = check(Enum.reverse(right), mem)
    {c+s+l, {t, s}, mem}
  end

  def cost2([s|rest], l, left, right, mem) do
    {costLeft, tl, mem} = cost2(rest, l+s, [s|left], right, mem)
    {cr, tr, mem} = cost2(rest, l+s, left, [s|right], mem)
    if costLeft < cr do
      {costLeft, tl, mem}
    else
      {cr, tr, mem}
    end
  end

  ################################################## Det här är tester

  def check(seq, mem) do
    case Memo.lookup(mem, seq) do
      nil ->
        cost2(seq, mem)
      {c, t} ->
        {c, t, mem}
    end
  end
  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end
end

defmodule Memo do

  def new() do %{} end

  def add(mem, key, val) do Map.put(mem, :binary.list_to_bin(key), val) end

  def lookup(mem, key) do Map.get(mem, :binary.list_to_bin(key)) end

end

## 1, [2,3,4]
##[1,2], [3,4]
##[1,2,3], [4]
#etc