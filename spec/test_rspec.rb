require 'rspec'
require_relative './../lib/positions'
require_relative './../lib/cell'
describe "Factorial" do
  it do
    positions=Positions.new
    positions.black_pieces = {
      "bk" => Cell.new(7, 7),
      "bq1" => Cell.new(7, 4)}
    positions.white_pieces = {
      "wk" => Cell.new(0, 4),
      "wn1" => Cell.new(0, 6)}
    positions.set_initial_board
    movements = positions.available_white_moves.to_a
    expect(movements.size).to equal(5)
  end
end