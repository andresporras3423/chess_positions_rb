require 'rspec'
require_relative './../lib/positions'
require_relative './../lib/cell'
describe "movements when king is in check" do
  it "when white king is in check and knight can protect" do
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

  it "when black king is in check and knight can protect" do
    positions=Positions.new
    positions.white_pieces = {
      "wk" => Cell.new(7, 7),
      "wq1" => Cell.new(7, 4)}
    positions.black_pieces = {
      "bk" => Cell.new(0, 4),
      "bn1" => Cell.new(0, 6)}
    positions.set_initial_board
    movements = positions.available_black_moves.to_a
    expect(movements.size).to equal(5)
  end
end