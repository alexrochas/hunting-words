input = [
  'carro', 'sapato'
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

	def to_pretty_s
		s = ""
		i = 0
		while i < self.column_size
			s += "\n" if i != 0
			j = 0
			while j < self.row_size
				s += ' ' if j != 0
				s += self.element(i, j).to_s
				j += 1
			end
			i += 1
		end
		s
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

puts mutableMatrix.to_pretty_s
