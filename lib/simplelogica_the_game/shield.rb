class Shield

    def initialize(x, y, z)
      @x = x
      @y = y
      @z = z
      @image = $game.images[:shield]
    end

    def draw
      @image.draw_rot(@x, @y, @z, @angle) unless @image.nil?
    end

    def update
      if $game.button_down?(Gosu::KbS)
        self.draw
      end
    end
end
