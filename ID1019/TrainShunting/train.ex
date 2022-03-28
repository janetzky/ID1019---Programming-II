defmodule Train do

  defmodule Listf do

  def test do
    take(example(), 4)
    #drop(example(),4)
    #append(example(), 3)
    #member(example(), 180)
    #position(example(),208)
  end

  def take([h|_],0) do [] end
  def take([h|t], n) do
    if n == 1 do
      [h]
    else
      [h | take(t, n - 1)]
    end
  end

  def drop([h|t], 0) do [h|t] end
  def drop([h|t],n) do
    if n == 1 do
      t
    else
      drop(t, n - 1)
    end
  end

  def append(xs,ys) do
    xs ++ ys
  end

  def member(xs,y) do
    Enum.member?(xs, y)
  end

  def position([h|t], x) do
    if x == h do
      1
    else
      1 + position(t, x)
    end
  end


  def example() do
    [199,200,4,208,210,200,207,240,269,260,263]
  end
end
####################################################### MOVES ###########################################################
            #######################################################################################
  defmodule Moves do

    def test do
      #single({:two,1},{[:a,:b],[],[]})
      single({:one,-1},{[:a,:b],[:c,:d],[:e]})
      #move([{:one,1},{:two,1},{:one,-1}],
        #{[:a,:b],[],[]})
    end

    def single({:one, n}, {main,one,two}) do
      cond do
        n == 0 -> {main,one,two}
        n > 0 -> {Listf.take(main,length(main)-n),Listf.append(Listf.drop(main,length(main)-n),one),two}
        n < 0 -> {Listf.append(main,Listf.take(one,n* -1)),Listf.drop(one,n* -1),two}
      end
    end

    def single({:two, n}, {main,one,two})do
      cond do
         n == 0 -> {main,one,two}
         n > 0  ->{Listf.take(main,length(main)-n),one,Listf.append(Listf.drop(main,length(main)-n),two)}
         n < 0  -> {Listf.append(main,Listf.take(two,n*-1)),one,Listf.drop(two,n* -1)}
      end

    end

    def move([], state) do [state] end
    def move([h|t], state) do
      [state| move(t, single(h, state))]
    end
  end
  ####################################################### SHUNT ###########################################################
                  #######################################################################################
  defmodule Shunt do

    def split(xs,y) do
      hs = Listf.take(xs, Listf.position(xs, y)-1)
      ts = Listf.drop(xs,Listf.position(xs,y))
      {hs,ts}
    end
    def find([], [])do [] end
    def find(xs, [y|t]) do
          {hs, ts} = split(xs, y)
          step = Moves.single({:one, length(ts)+1}, {xs, [], []})
          step = Moves.single({:two, length(hs)}, step)
          step = Moves.single({:one, -(length(ts)+1)}, step)
          {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, step)

          [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))}| find(t2, t)]
    end
    def few([], []) do [] end
    def few([u|k], [u|t]) do few(k, t) end
    def few(xs, [y|t]) do
          {hs, ts} = split(xs, y)
          step = Moves.single({:one, length(ts)+1}, {xs, [], []})
          step = Moves.single({:two, length(hs)}, step)
          step = Moves.single({:one, -(length(ts)+1)}, step)
          {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, step)

          [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))}| few(t2, t)]
    end


    def compress([])do [] end
    def compress(moves)do

      compressedMoves = rules(moves)

      case compressedMoves == moves do
        true -> moves
        false -> compress(compressedMoves)
      end
    end


    def rules([]) do [] end
    def rules([{_, 0} | []]) do [] end
    def rules([xs | []]) do [xs] end
    def rules([{_, 0} | tail]) do rules(tail) end

    def rules([{one, n},{_, 0} | tail])do
      rules([{one, n} | tail])
    end
    def rules([{one, n},{one, m}| tail])do
      rules([{one, n + m} | tail])
    end
    def rules([{one, n},{two, m}| tail])do
      [{one, n} | rules([{two, m} | tail])]
    end

    def test() do
       #find([:c,:a,:b],[:a,:b,:c])
       #few([:c,:a,:b],[:c,:b,:a])
       rules([one: 1,one: -1, two: -1, one: -1, two: 1])
    end

  end
end