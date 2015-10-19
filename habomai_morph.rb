require 'natto'

$natto = Natto::MeCab.new
hash = {}

N = 3

def parse_text(hash, text)
  data = ["__BEGIN__", "__BEGIN__"]
  $natto.parse(text) do |n|
    if n.surface != nil
      data << n.surface
    end
  end
  data << "__END__"
  data.each_cons(N).each do |x|
    suffix = x.pop
    prefix = x
    hash[prefix] ||= []
    hash[prefix] << suffix
  end
  hash
end

def markov(hash)
  random = Random.new
  prefix = ["__BEGIN__", "__BEGIN__"]
  res = []
  loop do
    n = hash[prefix].length
    prefix = [prefix[1], hash[prefix][random.rand(0..n-1)]]
    res << prefix[0] if prefix[0] != "__BEGIN__"
    if hash[prefix].last == "__END__"
      res << prefix[1]
      break
    end
  end
  res
end

File.open("habomaijiro.txt", "r") do |file|
  file.each_line do |line|
    parse_text(hash, line)
  end
end

res = markov(hash).join
puts res
