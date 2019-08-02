vowels = 'aeiou'
hash = {}
('a'..'z').each.with_index(1) { |l, i| hash[l] = i if vowels.include? l }
puts hash
