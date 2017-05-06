class Player
  attr_accessor :color, :moves, :pawn_dir

  def initialize(color, moves, pawn_dir)
    @color = color
    @moves = moves
    @pawn_dir =  pawn_dir #1 means pawn moves downward; -1 moves upward
  end

end

#white = Player.new("White", ["♔", "♕", "♖", "♗"," ♗", "♙"])
#black = Player.new("Black", ["♚", "♛", "♜", "♝", "♞", "♟"])
white = Player.new("White", [" k", " q", " r", " b", " n", " p"], -1)
black = Player.new("Black", [" K", " Q", " R", " B", " N", " P"], 1)


class Board
  attr_accessor :board, :adv2

  def initialize
    pieces_symbol
    @board = empty_board
    @adv2 = []
    @white = Player.new("White", [" k", " q", " r", " b", " n", " p"], -1)
    @black = Player.new("Black", [" K", " Q", " R", " B", " N", " P"], 1)
    new_game
    print_board
  end

  def empty_board
    board = []
    8.times do |row|
      board << []
      8.times { board[row] << @@nil }
    end
    board
  end

  def pieces_symbol
  @@w_king = " k"
  @@w_queen = " q"
  @@w_rook = " r"
  @@w_bishop = " b"
  @@w_knight = " n"
  @@w_pawn = " p"

  @@b_king= " K"
  @@b_queen = " Q"
  @@b_rook = " R"
  @@b_bishop = " B"
  @@b_knight = " N"
  @@b_pawn = " P"

  @@nil = "  "
  end

  def print_board
    puts "      0    1    2    3    4    5    6    7"
    puts "    +----+----+----+----+----+----+----+----+"
    @board.each_with_index do |row, index|
      board_row = row.join(" | ")
      puts "#{index}   | #{board_row} |   #{index}"
      puts "    +----+----+----+----+----+----+----+----+"
    end
    puts "      a    b    c    d    e    f    g    h"
  end



#  def print_board
#    puts "      a    b    c    d    e    f    g    h"
#    puts "    +----+----+----+----+----+----+----+----+"
#    @board.each_with_index do |row, index|
#      board_row = row.join(" | ")
#      puts "#{8 - index}   | #{board_row} |   #{8 - index}"
#      puts "    +----+----+----+----+----+----+----+----+"
#    end
#    puts "      a    b    c    d    e    f    g    h"
#  end

  #  def pieces_symbol
  #  @@w_king = "♔"
  #  @@w_queen = "♕"
  #  @@w_rook = "♖"
  #  @@w_bishop = "♗"
  #  @@w_knight = "♘"
  #  @@w_pawn = "♙"

  #  @@b_king= "♚"
  #  @@b_queen = "♛"
  #  @@b_rook = "♜"
  #  @@b_bishop = "♝"
  #  @@b_knight = "♞"
  #  @@b_pawn = "♟"

  #  @@nil = "  "
  #  end

  def new_game
    @board[0] = [@@b_rook, @@b_knight, @@b_bishop, @@b_queen, @@b_king, @@b_bishop, @@b_knight, @@b_rook]
    @board[1] = []
    8.times { @board[1] << @@b_pawn}
    @board[6] = []
    8.times { @board[6] << @@w_pawn}
    @board[7] = [@@w_rook, @@w_knight, @@w_bishop, @@w_queen, @@w_king, @@w_bishop, @@w_knight, @@w_rook]
  end


  def find_piece(piece)
    matches = []
    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        matches << [i,j] if square == piece
      end
    end
    matches
  end

  def rook_moves(player, pos) #[row, col]
    valid_moves = []
    row = pos[0]; col = pos[1]

    [1,-1].each do |sign| #positive checks right-hand side, negative checks left-hand side
      7.times do |i|
        #horizontal
        if (col + (i + 1) * sign).between?(0, 7) #make sure stays within the board; starts from col+1 to col+7; and col-1 to col-7
          if (1..i).to_a.all? {|j| @board[row][col + j * sign] == @@nil }  #make sure sqaures between [row,col] and [row, col+i+1] is empty
            valid_moves << [row, col + (i + 1) * sign] if !player.moves.include? @board[row][col + (i + 1) * sign] #reject if the square contains the curr player's piece
          end
        end
        #vertical
        if (row + (i + 1) * sign).between?(0, 7)
          if (1..i).to_a.all? {|j| @board[row + j * sign][col] == @@nil }
            valid_moves << [row + (i + 1) * sign, col] if !player.moves.include? @board[row + (i + 1) * sign][col]
          end
        end
      end
    end
    valid_moves
  end

  def bishop_moves(player, pos) #[row,col]
    valid_moves = []
    row = pos[0]; col = pos[1]
    [1,-1].each do |sign|
      7.times do |i|
        #from upper-left to lower-right
        if (col + (i + 1) * sign).between?(0, 7) and (row + (i + 1) * sign).between?(0, 7) #make sure stays within the board; starts from row+1/col+1 to row+7/col+7; and row-1/col-1 to row-7/col-7
          if (1..i).to_a.all? {|j| @board[row + j * sign][col + j * sign] == "  " }  #make sure sqaures between [row,col] and [row+i+1, col+i+1] is empty
            if !player.moves.include? @board[row + (i + 1) * sign][col + (i + 1) * sign] #reject if the square contains the curr player's piece
              valid_moves << [row + (i + 1) * sign, col + (i + 1) * sign]
            end
          end
        end
        #from lower-left to upper-right
        if (row + (i + 1) * sign).between?(0, 7) and (col + (i + 1) * -1 * sign).between?(0, 7)
          if (1..i).to_a.all? {|j| @board[row + j * sign][col + j * -1 * sign] == "  " }
            if !player.moves.include? @board[row + (i + 1) * sign][col + (i + 1) * -1 * sign]
              valid_moves << [row + (i + 1) * sign, col + (i + 1) * -1 * sign]
            end
          end
        end
      end
    end
    valid_moves
  end

  def queen_moves(player, pos)
    rook_moves(player, pos) + bishop_moves(player, pos)
  end

  def knight_moves(player, pos)
    displacements = [[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
    displace_by(displacements, player, pos)
  end

  def king_moves(player, pos)
    displacements = [[1,1],[1,-1],[-1,1],[-1,-1],[1,0],[0,1],[-1,0],[0,-1]]
    displace_by(displacements, player, pos)
  end


  def displace_by(displacements, player, pos)
    valid_moves = []
    row = pos[0] ; col = pos[1]
    displacements.each do |displace_by|
      displaced_row  = row + displace_by[0]
      displaced_column = col + displace_by[1]
      if displaced_row.between?(0,7) and displaced_column.between?(0,7)
        if !player.moves.include? @board[displaced_row][displaced_column]
          valid_moves << [displaced_row, displaced_column]
        end
      end
    end
    valid_moves
  end

  def pawn_moves(player, pos)
    valid_moves = []
    row = pos[0] ; col = pos[1]
    if (row + player.pawn_dir).between?(0,7)
      #advance 1 square to empty space
      valid_moves << [row + player.pawn_dir, col] if @board[row + player.pawn_dir][col] == @@nil
      #move diagonially to capture opponent piece
      [1, -1].each do |i|
        if (col + i).between?(0,7)
          square = @board[row + player.pawn_dir][col + i]
          if !player.moves.include? square and square != @@nil #i.e. square contains oppo piece
            valid_moves << [row + player.pawn_dir, col + i]
          end
        end
      end
    end
    valid_moves = valid_moves + pawn_adv2(player, pos) + en_passant(player, pos)

  end

  def pawn_adv2(player, pos)
    valid_moves = []
    row = pos[0] ; col = pos[1]
    if player.color == "White" and row == 6 #i.e. rank 2
      valid_moves << [row - 2, col] if @board[row - 2][col] == @@nil
    elsif player.color == "Black" and row == 1 #i.e. rank 7
      valid_moves << [row + 2, col] if @board[row + 2][col] == @@nil
    end
    valid_moves
  end

  #def pawn_adv2?(player, pos)
  #  pawn_adv2(player, pos).size != 0
  #end

  def en_passant(player, pos)
    valid_moves = []
    row = pos[0] ; col = pos[1]
    if [row, col + 1] == @adv2
      valid_moves << [row + player.pawn_dir, col + 1]
    elsif [row, col - 1] == @adv2
      valid_moves << [row + player.pawn_dir, col - 1]
    end
    valid_moves
  end

  def piece_in_square(pos)
    row = pos[0] ; col = pos[1]
    @board[row][col]
  end

  def check_move(player, start, finish) #[row,col],[row,col] BUT only if the move doesnt cause the players own king in check - TBC
    valid = false
    piece = piece_in_square(start)
    if player.moves.include? piece
      valid_moves = find_valid_moves(piece, player, start)
      if valid_moves.include? finish
        puts "a"
        #the following tests if the move puts the player in check
        temp_board = @board.clone #saves a copy of @board & @adv2
        temp_adv2 = @adv2.clone
        8.times { |i| temp_board[i] = @board[i].clone } #Note: it seems each row of temp_board is linked with @board

        make_move(player, start, finish)
        valid = true if !check?(oppo_player(player))
        @board = temp_board
        @adv2 = temp_adv2
      end
    end
    valid
  end


  def oppo_player(player)
    player.color == "White" ? @black : @white
  end

  def make_move(player, start, finish)
      piece = piece_in_square(start)
      #if the piece is a pawn
      if [@@b_pawn, @@w_pawn].include? piece
        @board[@adv2[0]][@adv2[1]] = @@nil if finish == en_passant(player, start)[0] #remove the opponent pawn if en passant
        @adv2 = finish == pawn_adv2(player, start)[0] ? finish : [] #if pawn advances 2 steps, set @pawn_adv2 to the finish square; otherwise, reset @pawn_adv2
      else
        @adv2 = []
      end
      @board[finish[0]][finish[1]] = piece
      @board[start[0]][start[1]] = @@nil
  end

  def valid_make(player, start, finish)
    make_move(player, start, finish) if check_move(player, start, finish)
    print_board
  end

  def all_valid_moves(player)
    valid_moves = []
    player.moves.each do |piece|
      sqaures_with_piece = find_piece(piece)
      sqaures_with_piece.each do |pos|
        valid_moves += find_valid_moves(piece, player, pos)
      end
    end
    valid_moves
  end

  def find_valid_moves(piece, player, pos)
    case piece
    when @@b_pawn, @@w_pawn
      pawn_moves(player, pos)
    when @@b_knight, @@w_knight
      knight_moves(player, pos)
    when @@b_rook, @@w_rook
      rook_moves(player, pos)
    when @@b_bishop, @@w_bishop
      bishop_moves(player, pos)
    when @@b_queen, @@w_queen
      queen_moves(player, pos)
    when @@b_king, @@w_king
      king_moves(player, pos)
    end
  end

  def check?(player)
    check = false
    if player.color == "White"
      all_valid_moves(player).each do |pos|
        row = pos[0]; col = pos[1]
        check = true if @board[row][col] == @@b_king
      end
    elsif player.color == "Black"
      all_valid_moves(player).each do |pos|
        row = pos[0]; col = pos[1]
        check = true if @board[row][col] == @@w_king
      end
    end
    check
  end


end

#board = Board.new
#board.board[1][4] = "  "
#board.board[2][4] = " R"
#board.board[3][4] = " r"
board.print_board
#board.make_move(black, [2,4], [2,3])
#board.print_board
board.valid_make(black, [2,3], [2,4])
