require "space_dude/shield"
require "space_dude/version"
require "space_dude/sprite"
require "space_dude/bullet"
require "space_dude/ship"
require "space_dude/enemy"
require "space_dude/game"

module SpaceDude

  def self.init
    begin
      $game = SpaceDude::Game.new
      $game.begin!
    rescue Interrupt => e
      puts "\r Something goes wrong! :("
    end
  end

end

SpaceDude.init
