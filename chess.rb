class Player
  attr_accessor :color, :moves, :pawn_dir, :king_moved, :l_rook_moved, :r_rook_moved

  def initialize(color, moves, pawn_dir)
    @color = color
    @moves = moves
    @pawn_dir =  pawn_dir #1 means pawn moves downward; -1 moves upward
    @king_moved = false
    @l_rook_moved = false
    @r_rook_moved = false
  end

end


class Board
  attr_accessor :board, :adv2, :white, :black, \
  :w_king, :w_queen, :w_rook, :w_bishop, :w_knight, :w_pawn, \
  :b_king, :b_queen, :b_rook, :b_bishop, :b_knight, :b_pawn, :nil

  def initialize
    pieces_symbol
    @board = empty_board
    @adv2 = []
    #@white = Player.new("White", [" k", " q", " r", " b", " n", " p"], -1)
    #@black = Player.new("Black", [" K", " Q", " R", " B", " N", " P"], 1)
    @white = Player.new("White", [" ♔", " ♕", " ♖", " ♗", " ♘", " ♙"], -1)
    @black = Player.new("Black", [" ♚", " ♛", " ♜", " ♝", " ♞", " ♟"], 1)
    new_game
    #print_board
  end

  def empty_board
    board = []
    8.times do |row|
      board << []
      8.times { board[row] << @nil }
    end
    board
  end

#  def pieces_symbol
#  @w_king = " k"
#  @w_queen = " q"
#  @w_rook = " r"
#  @w_bishop = " b"
#  @w_knight = " n"
#  @w_pawn = " p"
#
#  @b_king= " K"
#  @b_queen = " Q"
#  @b_rook = " R"
#  @b_bishop = " B"
#  @b_knight = " N"
#  @b_pawn = " P"

#  @nil = "  "
#  end

#  def print_board
#    puts "      0    1    2    3    4    5    6    7"
#    puts "    +----+----+----+----+----+----+----+----+"
#    @board.each_with_index do |row, index|
#      board_row = row.join(" | ")
#      puts "#{index}   | #{board_row} |   #{index}"
#      puts "    +----+----+----+----+----+----+----+----+"
#    end
#    puts "      a    b    c    d    e    f    g    h"
#  end



  def print_board
    puts "      a    b    c    d    e    f    g    h"
    puts "    +----+----+----+----+----+----+----+----+"
    @board.each_with_index do |row, index|
      board_row = row.join(" | ")
      puts "#{8 - index}   | #{board_row} |   #{8 - index}"
      puts "    +----+----+----+----+----+----+----+----+"
    end
    puts "      a    b    c    d    e    f    g    h"
  end

  def pieces_symbol
    @w_king = " ♔"
    @w_queen = " ♕"
    @w_rook = " ♖"
    @w_bishop = " ♗"
    @w_knight = " ♘"
    @w_pawn = " ♙"

    @b_king= " ♚"
    @b_queen = " ♛"
    @b_rook = " ♜"
    @b_bishop = " ♝"
    @b_knight = " ♞"
    @b_pawn = " ♟"

    @nil = "  "
  end

  def new_game
    @board[0] = [@b_rook, @b_knight, @b_bishop, @b_queen, @b_king, @b_bishop, @b_knight, @b_rook]
    @board[1] = []
    8.times { @board[1] << @b_pawn}
    @board[6] = []
    8.times { @board[6] << @w_pawn}
    @board[7] = [@w_rook, @w_knight, @w_bishop, @w_queen, @w_king, @w_bishop, @w_knight, @w_rook]
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
          if (1..i).to_a.all? {|j| @board[row][col + j * sign] == @nil }  #make sure sqaures between [row,col] and [row, col+i+1] is empty
            valid_moves << [row, col + (i + 1) * sign] if !player.moves.include? @board[row][col + (i + 1) * sign] #reject if the square contains the curr player's piece
          end
        end
        #vertical
        if (row + (i + 1) * sign).between?(0, 7)
          if (1..i).to_a.all? {|j| @board[row + j * sign][col] == @nil }
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
      valid_moves << [row + player.pawn_dir, col] if @board[row + player.pawn_dir][col] == @nil
      #move diagonially to capture opponent piece
      [1, -1].each do |i|
        if (col + i).between?(0,7)
          square = @board[row + player.pawn_dir][col + i]
          if !player.moves.include? square and square != @nil #i.e. square contains oppo piece
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
      valid_moves << [row - 2, col] if @board[4][col] == @nil and @board[5][col] == @nil
    elsif player.color == "Black" and row == 1 #i.e. rank 7
      valid_moves << [row + 2, col] if @board[3][col] == @nil and @board[2][col] == @nil
    end
    valid_moves
  end

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
    if piece != @nil
      valid_moves = find_valid_moves(piece, player, start)
      valid = true if valid_moves.include? finish
    end
    valid
  end

  def find_valid_moves(piece, player, pos)
    case piece
    when @b_pawn, @w_pawn
      pawn_moves(player, pos)
    when @b_knight, @w_knight
      knight_moves(player, pos)
    when @b_rook, @w_rook
      rook_moves(player, pos)
    when @b_bishop, @w_bishop
      bishop_moves(player, pos)
    when @b_queen, @w_queen
      queen_moves(player, pos)
    when @b_king, @w_king
      king_moves(player, pos)
    end
  end

  def board_cache
    @temp_board = @board.clone #saves a copy of @board & @adv2
    8.times { |i| @temp_board[i] = @board[i].clone } #Note: it seems each row of temp_board is linked with @board
  end

  def load_cache
    @board = @temp_board
  end

  def oppo_player(player)
    player.color == "White" ? @black : @white
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

  def check?(player)
    check = false
    if player.color == "White"
      all_valid_moves(player).each do |pos|
        row = pos[0]; col = pos[1]
        check = true if @board[row][col] == @b_king
      end
    elsif player.color == "Black"
      all_valid_moves(player).each do |pos|
        row = pos[0]; col = pos[1]
        check = true if @board[row][col] == @w_king
      end
    end
    check
  end

  def make_move(player, start, finish)
      piece = piece_in_square(start)
      @board[finish[0]][finish[1]] = piece
      @board[start[0]][start[1]] = @nil
  end

  def move_ends_in_check?(player, start, finish)
    ends_in_check = false

    board_cache
    make_move(player, start, finish)
    ends_in_check = true if check?(oppo_player(player))
    load_cache

    ends_in_check
  end

  def valid_make(player, start, finish, pawn_promote_to = nil)
    if check_move(player, start, finish) and !move_ends_in_check?(player, start, finish)
      piece = piece_in_square(start)
      promote_pawn = false
      promote_pawn = true if [@b_pawn, @w_pawn].include? piece and pawn_promotion_valid?(player, start, finish)

      #if the piece is a pawn
      if [@b_pawn, @w_pawn].include? piece
        @board[@adv2[0]][@adv2[1]] = @nil if finish == en_passant(player, start)[0] #remove the opponent pawn if en passant
        @adv2 = finish == pawn_adv2(player, start)[0] ? finish : [] #if pawn advances 2 steps, set @pawn_adv2 to the finish square; otherwise, reset @pawn_adv2
      else
        @adv2 = []
      end
      #criteria for castling
      player.king_moved = true if [@b_king, @w_king].include? piece
      if [@b_rook, @w_rook].include? piece
        player.l_rook_moved = true if [[0,7], [7,0]].include? start
        player.r_rook_moved = true if [[0,0], [7,7]].include? start
      end
    end
    make_move(player, start, finish)
    pawn_promotion(player, finish, pawn_promote_to) if promote_pawn
    #print_board
  end

  def l_castling_valid?(player)
    player.l_rook_moved == false and castling_valid?(player, (0..3).to_a)
  end

  def r_castling_valid?(player)
    player.r_rook_moved == false and castling_valid?(player, (5..7).to_a.reverse)
  end

  def castling_valid?(player, range)
    #check the player's king has not moved
    if player.king_moved == false
      row = find_piece(@w_king)[0][0] if player == white
      row = find_piece(@b_king)[0][0] if player == black
      #check the squares between the king and rook are empty
      if range[1..-1].all? {|col| @board[row][col] == @nil }
        #check none of the moves are being attacked and the king does not end up in check
        if range.none? {|col| all_valid_moves(oppo_player(player)).include? [row, col] }
          return true
        end
      end
    end
    return false
  end

  def l_castling_make(player, move = true)
    if l_castling_valid?(player)
      castling_make(player, 0)
      player.king_moved = true if move == true
      player.l_rook_moved = true if move == true
    end
  end

  def r_castling_make(player, move = true)
    if r_castling_valid?(player)
      castling_make(player, 7)
      player.king_moved = true if move == true
      player.r_rook_moved = true if move == true
    end
  end

  def castling_make(player, col_of_rook)
    if player == white
      @board[7][col_of_rook] = @w_king
      @board[7][4] = @w_rook
    else
      @board[0][col_of_rook] = @b_king
      @board[0][4] = @b_rook
    end
  end

  def no_moves?(player)
      player.moves.each do |piece|
        sqaures_with_piece = find_piece(piece)
        sqaures_with_piece.each do |start_pos|
          valid_moves = find_valid_moves(piece, player, start_pos)
          valid_moves.each do |finish_pos|
            return false if !move_ends_in_check?(player, start_pos, finish_pos)
          end
        end
      end
      return false if l_castling_valid?(player) or r_castling_valid?(player)
      true
  end

  def sb_wins?(player)
    (player == @white and find_piece(@b_king).empty?) or (player == @black and find_piece(@w_king).empty?)
  end

  def checkmate?(player)
    check?(player) and no_moves?(oppo_player(player))
  end

  def stalemate?(player)
    !check?(oppo_player(player)) and no_moves?(player)
  end

  def pawn_promotion_valid?(player, start, finish)
    if [@w_king, @b_king].include? piece_in_square(finish)
      false #do not ask for promote piece if the player wins game
    else
      if player == @white and piece_in_square(start) == @w_pawn
        finish[0] == 0
      elsif player == @black and piece_in_square(start) == @b_pawn
        finish[0] == 7
      end
    end
  end

  def pawn_promotion(player, pos, piece)
    row = pos[0]; col = pos[1]
    i = (player == @white) ? 0 : 1
    case piece
    when "Q"
      @board[row][col] = [@w_queen, @b_queen][i]
    when "N"
      @board[row][col] = [@w_knight, @b_knight][i]
    when "B"
      @board[row][col] = [@w_bishop, @b_bishop][i]
    end
  end

end

class Game
  attr_accessor :board, :white, :black

  def initialize
    @board = Board.new
    @white = @board.white
    @black = @board.black
    @curr_player = @white
    @game_end = false
    @comment = nil
    turn until @game_end == true
  end

  def oppo_player
    (@curr_player == @white)? @black : @white
  end

  def switch_player
    @curr_player = oppo_player
  end

  def turn
    @made_move = false
    if @board.stalemate?(@curr_player)
      puts "Stalemate."
      @game_end = true
    else
      until @made_move == true
        board.print_board
        puts @comment if !@comment.nil?
        puts "#{oppo_player.color} checks." if @board.check?(oppo_player)
        make_move
      end
    end

    if @board.sb_wins?(@curr_player)
      board.print_board
      puts "#{@curr_player.color} wins."
      @game_end = true
    elsif @board.checkmate?(@curr_player)
      board.print_board
      puts "Checkmate. #{@curr_player.color} wins."
      @game_end = true
    end

    switch_player
  end

  def make_move
    start = nil; fin_notation = nil; finish = nil; promote = nil; letters_in_move = ""
    @comment = nil
    puts "#{@curr_player.color}'s turn. Make your move(please use algebriac notation).'"
    move = gets.chomp.strip

    if move == "0-0"
      if board.r_castling_valid?(@curr_player)
        board.r_castling_make(@curr_player)
        @made_move = true
        start = "pass"
      end
    elsif move == "0-0-0"
      if board.l_castling_valid?(@curr_player)
        board.l_castling_make(@curr_player)
        @made_move = true
        start = "pass"
      end
    else
      move = move.scan(/\w+/).join.split("x")
      if move.size == 1
        move = move.join
        if move.length == 2
          piece = "P"; fin_notation = move
        elsif move.length == 3
          if ("a".."h").to_a.include? move[0] and ["Q","N","R","B"].include? move[-1]
             promote = move[-1]; fin_notation = move[0..1]
          else
            piece = move[0]; fin_notation = move[1..2]
          end
        elsif move.length == 4
          fin_notation = move[2..3]
          piece = move[0..1]
        end
      elsif move.size == 2 #i.e. capture
        letters_in_move = move[1].scan(/[a-zA-Z]/).join
        if move[1].length == 3 and ["Q","N","R","B"].include? move[1][-1]
          piece = move[0]; fin_notation = move[1][0..1]; promote = move[1][2]
        elsif letters_in_move.length == 1 or (letters_in_move.length == 3 and letters_in_move[-2..-1] == "ep") #in case of en passant notation
          fin_notation = move[1][0..1]
          piece = move[0]
        end
      end
      finish = convert(fin_notation) if !fin_notation.nil?
      start = find_start(piece, finish) if finish != nil
    end

    if start != "pass"
      if start != nil and finish != nil
        fin_notation = "x" + fin_notation if oppo_player.moves.include? @board.board[finish[0]][finish[1]]

        if start == "ambiguous"
          if piece == "P"
            @comment = "More than one piece can make move. Do you mean '#{@differentiate[0] + fin_notation}' or '#{@differentiate[1] + fin_notation}'."
          else #i.e. not pawn
            @comment = "More than one piece can make move. Do you mean '#{piece + @differentiate[0] + fin_notation}' or '#{piece + @differentiate[1] + fin_notation}'."
          end
        elsif finish == @board.en_passant(@curr_player, start)[0] and ( move.size != 2 or letters_in_move[-2..-1] != "ep")
          @comment = "Do you mean '#{(start[1] + 97).chr + "x" + fin_notation + "e.p."}'?"
        elsif finish != @board.en_passant(@curr_player, start)[0] and \
          ((!oppo_player.moves.include? @board.board[finish[0]][finish[1]] and move.is_a? Array) \
          or (oppo_player.moves.include? @board.board[finish[0]][finish[1]] and !move.is_a? Array)) #remind if meant capture or non-capture
          piece = (start[1] + 97).chr if piece == "P"
          if board.pawn_promotion_valid?(@curr_player, start, finish) and promote == nil
            @comment = "Do you mean '#{piece + fin_notation}'? Please also specify what piece does the pawn promote to."
          else
            @comment = "Do you mean '#{piece + fin_notation}'?"
          end
        elsif board.pawn_promotion_valid?(@curr_player, start, finish) and promote == nil
          @comment = "Plese specify what piece does the pawn promote to."
        else
          board.valid_make(@curr_player, start, finish, promote)
          @made_move = true
        end
      else
        @comment = "Invalid move."
      end
    end

    #board.print_board
  end

  def find_start(piece, finish)
    i = @curr_player == white ? 0 : 1
    if ("a".."h").to_a.include? piece or piece == "P" #i.e. pawn
      squares_with_piece = board.find_piece([board.w_pawn, board.b_pawn][i])
      valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_pawn, @curr_player, pos).include? finish}
    else
      case piece[0]
      when "R"
        squares_with_piece = board.find_piece([board.w_rook, board.b_rook][i])
        valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_rook, @curr_player, pos).include? finish }
      when "N"
        squares_with_piece = board.find_piece([board.w_knight, board.b_knight][i])
        valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_knight, @curr_player, pos).include? finish }
      when "B"
        squares_with_piece = board.find_piece([board.w_bishop, board.b_bishop][i])
        valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_bishop, @curr_player, pos).include? finish }
      when "Q"
        squares_with_piece = board.find_piece([board.w_queen, board.b_queen][i])
        valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_queen, @curr_player, pos).include? finish }
      when "K"
        squares_with_piece = board.find_piece([board.w_king, board.b_king][i])
        valid_squares = squares_with_piece.select { |pos| board.find_valid_moves(board.w_king, @curr_player, pos).include? finish }
      else
        valid_squares = []
      end
    end

    if ("a".."h").to_a.include? piece
      unique_start(valid_squares, piece) #if pawn is specified, the specified pawn is used to disambiguate
    else
      if piece.length == 1
        unique_start(valid_squares)
      elsif piece.length == 2
        unique_start(valid_squares, piece[1])
      else
        nil
      end
    end
  end

  def unique_start(valid_squares, disambiguate = nil)
    if valid_squares.size == 0
      nil
    elsif valid_squares.size == 1 and disambiguate == nil
      valid_squares[0]
    else
      if disambiguate == nil and valid_squares.size > 1
        if valid_squares[0][1] != valid_squares[1][1]
          @differentiate = [(valid_squares[0][1] + 97).chr, (valid_squares[1][1] + 97).chr]
        else
          @differentiate = [(8- valid_squares[0][0]).str, (8 - valid_squares[1][0]).str]
        end
        "ambiguous"
      else
        valid_squares_disamb = disamb(valid_squares, disambiguate)
        unique_start(valid_squares_disamb)
      end
    end
  end

  def disamb(valid_squares, disambiguate)
    if ("a".."h").to_a.include? disambiguate
      valid_squares.select {|pos| pos[1] == disambiguate.ord - 97 }
    elsif ("1".."8").to_a.include? disambiguate
      valid_squares.select {|pos| pos[0] == 8 - disambiguate.to_i}
    else
      []
    end
  end

  def convert(notation)
    row = nil; col = nil
    col = notation[0].ord - 97 if ("a".."h").to_a.include? notation[0]
    row = 8 - notation[1].to_i if ("1".."8").to_a.include? notation[1]
    if row == nil or col == nil
      nil
    else
      [row, col]
    end
  end

end

Game.new
