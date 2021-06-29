def make_hash(arr)
    hash = Hash.new([])
    arr.each do |word|
        hash[word[0]] += [word]
    end
    return hash 
end
 