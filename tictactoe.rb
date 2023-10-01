HUMAN_MARK = 'X'
MACHINE_MARK = 'O'

MARKS = { human: HUMAN_MARK, machine: MACHINE_MARK }.freeze
WINNING_CELL_COMBOS = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
  [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
].freeze

def winning?(board, marker)
  WINNING_CELL_COMBOS.any? { |combo| combo.all? { |cell| board[cell] == marker } }
end

def tie?(board)
  board.all? { |cell| [HUMAN_MARK, MACHINE_MARK].include?(cell) }
end

def display(board)
  puts ' 1 | 2 | 3 '
  puts '---------'
  board.each_slice(3).with_index do |row, _idx|
    puts row.map { |obj| obj.nil? ? ' ' : obj }.join(' | ')
    puts '---------'
  end
end

def human_move(board)
  loop do
    input = nil
    while input&.length != 2
      puts "\nPor favor informe '#{HUMAN_MARK}' em um quadrado vazio (linha e coluna, como '1 3', para a primeira linha e terceira coluna):"
      input = gets.chomp.split.map(&:to_i)
    end
    row, col = input

    if row.between?(1, 3) && col.between?(1, 3)
      n = (row - 1) * 3 + (col - 1)
      if board[n].nil?
        board[n] = HUMAN_MARK
        break
      else
        puts 'Este quadrado já está ocupado'
      end
    else
      puts 'Linha e Coluna inválidos. Por favor escolha linhas e colunas entre 1 e 3.'
    end
  end
end

def machine_move(board)
  best_score = -Float::INFINITY
  best_move = nil

  available_cells = board.each_index.select { |i| board[i].nil? }

  available_cells.each do |cell|
    board[cell] = MACHINE_MARK
    score = minimax(board, 0, false)
    board[cell] = nil

    if score > best_score
      best_score = score
      best_move = cell
    end
  end

  board[best_move] = MACHINE_MARK
end

def minimax(board, depth, is_maximizing)
  if winning?(board, HUMAN_MARK)
    return -1
  elsif winning?(board, MACHINE_MARK)
    return 1
  elsif tie?(board)
    return 0
  end

  if is_maximizing
    best_score = -Float::INFINITY
    available_cells = board.each_index.select { |i| board[i].nil? }

    available_cells.each do |cell|
      board[cell] = MACHINE_MARK
      score = minimax(board, depth + 1, false)
      board[cell] = nil
      best_score = [best_score, score].max
    end

  else
    best_score = Float::INFINITY
    available_cells = board.each_index.select { |i| board[i].nil? }

    available_cells.each do |cell|
      board[cell] = HUMAN_MARK
      score = minimax(board, depth + 1, true)
      board[cell] = nil
      best_score = [best_score, score].min
    end

  end
  best_score
end

def play_game(human_moves_first = true)
  board = Array.new(9)

  puts '|----------------------|'
  puts '|  Novo jogo começou!  |'
  puts '|----------------------|'
  puts "\n\n"


  display(board)

  loop do
    if human_moves_first
      human_move(board)
      display(board)
      break if winning?(board, HUMAN_MARK) || tie?(board)
    else
      machine_move(board)
      display(board)
      break if winning?(board, MACHINE_MARK) || tie?(board)
    end

    if human_moves_first
      machine_move(board)
      display(board)
      break if winning?(board, MACHINE_MARK) || tie?(board)
    else
      human_move(board)
      display(board)
      break if winning?(board, HUMAN_MARK) || tie?(board)
    end
  end

  if winning?(board, HUMAN_MARK)
    puts 'Você venceu!'
  elsif winning?(board, MACHINE_MARK)
    puts 'O PC ganhou, era inevitável.'
  else
    puts 'Empate!'
  end

  puts 'Deseja jogar novamente? (s/n)'
  play_again = gets.chomp.downcase
  human_moves_first = !human_moves_first
  play_game(human_moves_first) if play_again == 's'
end

# Start the game
play_game(true) # Troque para falso para que o computador inicie o jogo
