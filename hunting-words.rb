
input = [
  'carro', 'cachorro'
  ]

size = 10

o = [('a'..'z')].map(&:to_a).flatten
o[rand(o.length)]

require 'matrix'

matrix = Matrix.build(size, size) { o[rand(o.length)] }

require 'functional'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

matrix

mutableMatrix = Marshal.load(Marshal.dump(matrix))

input.each do |word|
  index = []
  either = nil
  matrix.each_with_index do |e, row, col|  
    if word.chars.first == e
      if col + word.size < size # linha
        either = Functional::Either.left([row, col])
        break
      elsif row + word.size < size # coluna
        either = Functional::Either.right([row, col])
        break
      end
    end
  end
  
  chars = word.chars
  
  if either != nil and either.right?
    puts "coluna #{either.right}"
    r,c = either.right
    (r..r+word.length-1).each_with_index do |column, index|
      puts "#{chars[index]} in #{column},#{r}"
      mutableMatrix.[]= column, r, chars[index]
    end
  elsif either != nil and either.left?
    puts "linha #{either.left}" 
    r,c = either.left
    (c..c+word.length-1).each_with_index do |row, index|
      puts "#{chars[index]} in #{c},#{row}"
      mutableMatrix.[]= c, row, chars[index]
    end
  else
    puts "Not possible to insert #{word}"
  end
end

mutableMatrix
