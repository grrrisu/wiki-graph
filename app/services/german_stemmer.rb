class GermanStemmer

  def stem(word)

    return word if word.length < 4

    # Step 1
    if word =~ /ern$/
      word = $`
    elsif word =~ /en$/
      word = $`
    elsif word =~ /em$/
      word = $`
    elsif word =~ /er$/
      word = $`
    elsif word =~ /es$/
      word = $`
    elsif word =~ /e$/
      word = $`
    elsif word =~ /(b|d|f|g|h|k|l|m|n|r|t)(s)$/
      word = $` + $1
    end

     # Step 2
    if word =~ /est$/
      word = $`
    elsif word =~ /en$/
      word = $`
    elsif word =~ /er$/
      word = $`
    elsif word.length > 4
      if word =~ /(b|d|f|g|h|k|l|m|n|t)(st)$/
        word = $` + $1
      end
    end

    # Step 3
    if word =~ /(^e)(isch)$/
      word = $` + $1
    elsif word =~ /(ig|lich)(keit)$/
      word = $` + $1
    elsif word =~ /(er|en)(lich)$/
      word = $` + $1
    elsif word =~ /(er|en)(heit)$/
      word = $` + $1
    elsif word =~ /(ig|[^e])(end)$/
      word = $` + $1
    elsif word =~ /(ig|[^e])(ung)$/
      word = $` + $1
    elsif word =~ /([^e])(isch)$/
      word = $` + $1
    elsif word =~ /([^e])(ig)$/
      word = $` + $1
    elsif word =~ /([^e])(ik)$/
      word = $` + $1
    end

    word
  end

  def stem_sentence (sentence)
    sentence.split(/\b/).map {|word| stem(word) if word != " " }.compact
  end

end
