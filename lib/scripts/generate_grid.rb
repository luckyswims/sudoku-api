def generate
  options = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  # Create a randomized list of the numbers 1-9 to act as a base row
  base_row = options.shuffle
  prng = Random.new
  set1 = [1, 2, 3]
  result = []
  # rotate(0 - 8)
  until set1.empty?
    set2 = [0, 1, 2]
    offset1 = set1.slice!(prng.rand(set1.length))
    until set2.empty?
      offset2 = offset1 + 3 * set2.slice!(prng.rand(set2.length))
      result.push(base_row.rotate(offset2))
    end
  end
  puts result
end

binding.pry
''
