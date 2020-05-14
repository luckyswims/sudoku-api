# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show update destroy]

  # GET /games
  def index
    @games = Game.all

    render json: @games
  end

  # GET /games/1
  def show
    render json: @game
  end

  # POST /games
  def create
    @game = Game.new(game_params)
    @game.board = generate_board

    if @game.save
      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def game_params
    params.require(:game).permit(:user_id, board: [])
  end

  # Method for generating a semi-random solvable sudoku puzzle
  def generate_board
    starting_seed = pick_seed
    shuffled_seed = shuffle_seed(starting_seed)
    board = scramble_values(shuffled_seed)
    board
  end

  # Method for picking which of the 4 base puzzle seeds to start with
  def pick_seed
    case rand(4)
    when 0
      [[7, 8, '', '', '', 6, '', '', ''],
       [5, '', 2, 7, '', '', 3, 9, 6],
       [3, 9, '', '', 4, 2, '', '', ''],
       ['', '', '', '', '', '', 8, 1, 3],
       ['', '', '', 9, '', 5, 4, '', ''],
       [4, 2, 7, '', '', '', 9, '', ''],
       [1, 3, '', 6, 5, 4, '', 7, 8],
       ['', '', '', 1, '', 9, 6, '', ''],
       ['', 5, '', 2, '', '', '', '', '']]
    when 1
      [[9, 1, 3, '', 5, '', 2, '', ''],
       ['', '', '', 2, '', 4, '', '', ''],
       ['', 6, 4, '', 1, '', '', 5, 8],
       ['', 9, '', '', '', 5, 8, '', 6],
       [8, 2, '', 4, '', '', 3, 7, 5],
       [3, 7, 5, '', '', '', '', 9, 1],
       ['', 3, 7, '', '', 2, '', 4, 9],
       ['', '', '', 6, 4, 9, 1, '', ''],
       [6, '', 9, '', 3, '', '', '', 2]]
    when 2
      [[5, 9, '', '', '', '', 3, '', 4],
       ['', '', '', 3, '', 4, 5, '', ''],
       [3, 2, 4, 5, '', '', '', 1, 8],
       [2, 4, 5, 9, '', '', '', '', 3],
       ['', '', 6, '', 8, 3, 2, 4, 5],
       ['', '', 3, 2, 4, '', 9, 7, ''],
       [7, '', '', '', '', '', '', 5, 9],
       ['', '', '', 4, 5, '', 7, '', ''],
       [4, 5, '', 7, '', 1, '', 3, '']]
    when 3
      [[7, '', 1, 4, '', '', '', '', 3],
       ['', 2, 8, '', 6, 3, '', 9, ''],
       [5, 6, 3, '', '', '', '', 2, 8],
       ['', '', 5, '', 3, '', '', 1, 4],
       ['', '', 7, '', '', 4, 2, 8, 5],
       [9, '', '', 2, '', 5, '', 3, 7],
       [1, '', 2, 8, 5, '', '', 7, 9],
       ['', '', '', '', '', 2, '', 5, ''],
       [8, 5, '', '', '', 9, 1, '', '']]
    end
  end

  # Method for shuffling where the values are while retaining solvability
  def shuffle_seed(seed)
    seed = shuffle_columns(seed)
    seed = shuffle_rows(seed)
    # seed = mirror(seed)
    # seed = rotate(seed)
    seed.flatten
  end

  def shuffle_columns(seed)
    column1 = rand(3)
    column2 = rand(3)
    seed = swap_columns(seed, column1, column2) unless column1 == column2
    seed
  end

  # Swaps the two sets of three columns indicated by column1 and column 2
  def swap_columns(seed, column1, column2)
    column3 = 3 - column1 - column2
    order = []
    order[column1] = column2
    order[column2] = column1
    order[column3] = column3
    seed.map do |row|
      col1 = row.slice(3 * order[0], 3)
      col2 = row.slice(3 * order[1], 3)
      col3 = row.slice(3 * order[2], 3)
      col1.concat(col2, col3)
    end
  end

  def shuffle_rows(seed)
    row1 = rand(3)
    row2 = rand(3)
    seed = swap_rows(seed, row1, row2) unless row1 == row2
    seed
  end

  def swap_rows(seed, row1, row2)
    row3 = 3 - row1 - row2
    order = []
    order[row1] = row2
    order[row2] = row1
    order[row3] = row3
    set1 = seed.slice(3 * order[0], 3)
    set2 = seed.slice(3 * order[1], 3)
    set3 = seed.slice(3 * order[2], 3)
    set1.concat(set2, set3)
  end

  def scramble_values(array)
    key = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffle
    array.map do |value|
      if value == ''
        ''
      else
        key[value - 1]
      end
    end
  end
end
