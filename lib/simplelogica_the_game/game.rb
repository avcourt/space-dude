require 'gosu'

module SimplelogicaTheGame
  class Game < Gosu::Window

    attr_reader :images, :audio, :fx, :delta, :enemies, :bullets, :ship
    attr_accessor :score

    SPEED = 400

    IMAGE_ASSETS = {
      background_title: "assets/images/backgrounds/title.png",
      background_stage: "assets/images/backgrounds/stage.png",
      stageUI: "assets/images/backgrounds/stageUI.png",
      background_game_over: "assets/images/backgrounds/game_over_1.png",
      space: "assets/images/backgrounds/space.png",
      space_2: "assets/images/backgrounds/space_2.jpg",
      space_3: "assets/images/backgrounds/space_3.png",
      space_4: "assets/images/backgrounds/space_4.png",
      ship: "assets/images/player/ship.png",
      bullet_0: "assets/images/player/bullet_0.png",
      bullet_1: "assets/images/player/bullet_1.png",
      bullet_2: "assets/images/player/bullet_2.png",
      bullet_3: "assets/images/player/bullet_3.png",
      # bullet_4: "assets/images/player/bullet_4.png",
      # bullet_5: "assets/images/player/bullet_5.png",
      enemy_1: "assets/images/enemies/enemy_1.png",
      enemy_2: "assets/images/enemies/enemy_2.png",
      enemy_3: "assets/images/enemies/enemy_3.png"
    }

    AUDIO_ASSETS = {
      title_music: "assets/fixtures/title.wav",
      stage_music: "assets/fixtures/stage.wav",
      game_over_music: "assets/fixtures/game_over.wav"
    }

    FX_ASSETS = {
      shoot: "assets/fixtures/shoot.wav",
      kill: "assets/fixtures/bomb_explosion.wav"
    }

    FONT_ASSETS = {
      font: "assets/fonts/pixelade-webfont.ttf"
    }

    def initialize
      super 857, 1050
      self.caption = "Simplelogica: The Game"
      @images = {}
      @audio = {}
      @fx = {}

      @ship = nil
      @bullets = []
      @enemies = []
      @screen = nil
      @dead = false
      @space_y = -1050
      self.load_assets
    end

    def begin!
      self.setup_game
      @audio[:title_music].play(true)
      @screen = :background_title
      self.show
    end

    def stage
      @audio[:title_music].stop()
      @audio[:stage_music].play(true)
      @screen = :stageUI
    end

    def draw
      @images[@screen].draw(0, 0, 2)
      @font.draw("esc to exit", 20, 10, 3, 1, 1, Gosu::Color::WHITE)

      if @screen == :stageUI
        @ship.draw
        @bullets.each {|bullet| bullet.draw }
        @enemies.each {|enemy| enemy.draw }

        if @space_y < 0
          @space_y += SPEED * $game.delta
        else
          @space_y = -1050
        end
        @images[:space].draw(0, @space_y, 0)

        @font.draw("SCORE", 134, 902, 3, 2, 1, Gosu::Color::WHITE)
        @font.draw("#{@score}".rjust(5, '0'), 136, 936, 3, 2, 1, Gosu::Color::WHITE)

        # @font.draw("#{@ship.bullet}", 668, 892, 3, 2, 1, Gosu::Color::WHITE)

        @font.draw("WEAPON", 597, 877, 3, 1.5, 0.75, Gosu::Color::WHITE)
        @images[:"bullet_#{@ship.bullet}"].draw(668, 921, 2, 2, 2)

      elsif @screen == :background_game_over
        @font.draw("SCORE: #{@score.to_s.rjust(5, '0')}", 252, 580, 3, 2, 1, Gosu::Color::WHITE)
      end
    end

    def update
      if @screen == :stageUI
        self.update_delta
        self.spawn_enemies

        @ship.update
        @bullets.each {|bullet| bullet.update }
        @enemies.each {|enemy| enemy.update }

        self.handle_kills
      end
    end

    def button_up(key)
      if key == Gosu::KbEscape
        self.close
      end

      if @screen == :background_title
        self.stage
      elsif @screen == :stageUI
        if key == Gosu::KbSpace
          self.shoot
        end
        @ship.bullet = (@ship.bullet + 1) % 4 if key == (Gosu::KbA)
      end
    end

    protected

    def load_assets
      IMAGE_ASSETS.each do |key, value|
        @images[key] = Gosu::Image.new(value)
      end

      AUDIO_ASSETS.each do |key, value|
        @audio[key] = Gosu::Song.new(self, value)
      end

      FX_ASSETS.each do |key, value|
        @fx[key] = Gosu::Sample.new(self, value)
      end

      @font = Gosu::Font.new(self, FONT_ASSETS[:font], 40)
    end

    def update_delta
      current_time = Gosu::milliseconds / 1000.0
      @delta = [current_time - @last_time, 0.25].min
      @last_time = current_time
    end

    def setup_game
      @last_time = Gosu::milliseconds / 1000.0
      @ship = Ship.new
      @score = 0
    end

    def shoot
      @bullets.push(Bullet.new(@ship.x, @ship.y, @ship.bullet)) unless @ship.nil?
      @fx[:shoot].play(0.2)
    end

    def spawn_enemies
      if rand(50) < 50 * @delta
        @enemies.push(Enemy.new(rand(3)+1))
      end
    end

    def handle_kills
      @enemies.reject! {|x| x.killed? }
      @bullets.reject! {|x| x.killed? }
      self.game_over if @ship.killed? && !@dead
    end

    def game_over
      @dead = true
      @fx[:kill].play
      @screen = :background_game_over
      @audio[:game_over_music].play(true)
    end

  end
end
