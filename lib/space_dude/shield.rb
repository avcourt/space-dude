class Shield

    def initialize()
      @x = 330
      @y = 330
      @z = 18
      @image = $game.images[:shield]
    end

    def draw(x, y, z)
      @image.draw_rot(x, y, z) unless @image.nil?
    end

    def update(x, y, z)
      @x = x
      @y = y
      @z = z
      @image = $game.images[:empty]
      if $game.button_down?(Gosu::KbS)
        @image = $game.images[:shield]
      end
    end
end
