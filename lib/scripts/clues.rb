def clues
  options = *(1..81)
  clues = []
  prng = Random.new
  while clues.length < 40
    clues.push(options.slice!(prng.rand(options.length)))
  end
  puts clues.sort
end
binding.pry
''
