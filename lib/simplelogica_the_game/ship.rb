module SimplelogicaTheGame
  class Ship


    include Sprite
    SPEED = 350 # pixels / second

    attr_accessor :bullet

    def initialize
      self.initialize_sprite
      @x = $game.width / 2
      @y = $game.height - 260
      @image = $game.images[:ship]
      @z = 10
      @radius = 30
      @bullet = 0

    end

    def update
      # move horizontally if <- or -> are pressed
      @y -= SPEED * $game.delta if $game.button_down?(Gosu::KbUp)
      @y += SPEED * $game.delta if $game.button_down?(Gosu::KbDown)
      @x -= SPEED * $game.delta if $game.button_down?(Gosu::KbLeft)
      @x += SPEED * $game.delta if $game.button_down?(Gosu::KbRight)

      # @bullet = (@bullet + 1) % 5 if $game.button_down?(Gosu::KbA)
      # @bullet += 1 if $game.button_down?(97)
      # clamp @x so the ship always stays inside the screen
      @x = [[@x, $game.width-80].min, 80].max
      @y = [[@y, $game.height-260].min, 80].max
    end

  end
end
