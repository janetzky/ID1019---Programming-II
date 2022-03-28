defmodule Huffman do
  def sample() do
    'the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off'
  end

    def text() do
      'this is something that we should encode'
    end
    def test do
      sample = sample()
      tree = tree(sample) #working    Building the tree with..
      encode = encode_table(tree) # working  Tar reda på plats/koordinat
    #  decode = decode_table(tree)
      text = text()
      seq = encode(text, encode) #working
      IO.inspect(seq)
    # first_decode =decode1(seq, encode)
    #  second_decode = decode2(seq, decode)
    #  IO.inspect(first_decode)
    #  #IO.inspect(second_decode)
  end



    ##########################################################

    def tree(sample) do
      freq = freq(sample)
      huffman(freq)
    end

  # Build the encoding table.
  def encode_table(tree) do
    #codes(tree, [])
    # codes_better(tree, [], [])
    Enum.sort( codes(tree, []), fn({_,x},{_,y}) -> length(x) < length(y) end)
  end

  def codes({a, b}, sofar) do
    left = codes(a, [0 | sofar])
    right = codes(b, [1 | sofar])
    left ++ right
  end
  def codes( a, code) do
    [{a, Enum.reverse(code)}]
  end

  ## A better travering of the tree
  def codes_better({a, b}, sofar, acc) do
    left = codes_better(a, [0 | sofar], acc)
    codes_better(b, [1 | sofar], left)
  end
  def codes_better(a, code, acc) do
    [{a, Enum.reverse(code)} | acc]
  end

##################################################################################

  def encode([], _) do [] end
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

########################DECODE WITH THE TABLE############################


  def decode1([], _) do
    []
  end

  def decode1(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode1(rest, table)]
  end
  def decode_char(seq, n, table) do
      {code, rest} = Enum.split(seq, n)
      case List.keyfind(table, code, 1) do
        {char, _} ->
          {char, rest};
        nil ->
        decode_char(seq, n+1, table)
        end
  end
########################## DECODE WITH THE TREE########################################

  def decode_table(tree) do
    tree
  end

  def decode2(seq, tree) do decode2(seq, tree, tree) end
  def decode2([], char, _) do [char] end
  def decode2([0 | seq], {left, _}, tree) do decode2(seq, left, tree) end
  def decode2([1 | seq], {_, right}, tree) do decode2(seq, right, tree) end
  def decode2(seq, char, tree) do [char | decode2(seq, tree, tree)] end

########################################################################################
    ## Sample = foorr ---> f:1, o:2, r:2
    ##
    ##
    def freq(sample) do
      freq(sample, [])
    end
    def freq([], freq) do
      freq
    end
    def freq([char | rest], freq) do
      freq(rest, count(char, freq))
    end

    def count(char, []) do [{char, 1}] end
    def count(char, [{char, n} | freq]) do [{char, n+1} | freq] end
    def count(char, [head | freq]) do [head | count(char, freq)] end


    ############### HUFFMAN TRÄDET ######################

    def huffman(freq) do
      sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
      huffman_tree(sorted)
    end

    #Build the tree
    def huffman_tree([{tree, _}]) do tree end
    def huffman_tree([{char1, char1_freq}, {char2, char2_freq} | rest]) do
      huffman_tree(insert({{char1, char2}, char1_freq + char2_freq}, rest))
    end
    #insert the tuple at right position
    def insert({char, freq}, []) do [{char, freq}] end
    def insert({char1, char1_freq}, [{char2, char2_freq} | rest]) do
        if char1_freq < char2_freq do
           [{char1, char1_freq}, {char2, char2_freq} | rest]
        else
           [{char2, char2_freq} | insert({char1, char1_freq}, rest)]
        end
    end
   # def insert({char1, char1_freq}, [{char2, char2_freq} | rest]) do
   #   [{char2, char2_freq} | insert({char1, char1_freq}, rest)]
   # end

###############################################################################
  def read(file, n) do
    {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    {_, t6} = time(fn -> decode1(encoded, encode) end)
    {_, t7} = time(fn -> decode2(encoded, decode) end)

    #IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    #IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    #IO.puts("decoded with tree in #{t7} ms")

  end
end
