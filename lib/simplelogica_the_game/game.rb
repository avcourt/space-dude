require 'gosu'

module SimplelogicaTheGame
  class Game < Gosu::Window

    attr_reader :images, :audio, :fx, :delta, :enemies, :bullets, :ship
    attr_accessor :score

    SPEED = 400

    IMAGE_ASSETS = {
      background_title: "assets/images/backgrounds/space_dick.png",
      background_stage: "assets/images/backgrounds/stage.png",
      stageUI: "assets/images/backgrounds/spaceship_in_song.png",
      background_game_over: "assets/images/backgrounds/game_over_1.png",
      paused_backround: "assets/images/backgrounds/paused_backround.png",
      space: "assets/images/backgrounds/space.png",
      space_2: "assets/images/backgrounds/space_2.jpg",
      space_3: "assets/images/backgrounds/space_3.png",
      space_4: "assets/images/backgrounds/space_4.png",
      ship: "assets/images/player/spaceship_3_small_longer.png",
      ship_burst: "assets/images/player/spaceship_3_small_long_burst.png",
      ship_reverse: "assets/images/player/spaceship_3_small_reverse.png",
      ship_left: "assets/images/player/spaceship_left_1.png",
      ship_right: "assets/images/player/spaceship_right_1.png",
      shield: "assets/images/player/shield_p.png",
      ship_shield: "assets/images/player/shield_ship.png",
      bullet_0: "assets/images/player/bullet_0.png",
      bullet_1: "assets/images/player/bullet_1.png",
      bullet_2: "assets/images/player/bullet_2.png",
      bullet_3: "assets/images/player/bullet_3.png",
      # bullet_4: "assets/images/player/bullet_4.png",
      # bullet_5: "assets/images/player/bullet_5.png",
      enemy_1: "assets/images/enemies/ufo_1.png",
      enemy_2: "assets/images/enemies/ufo_6.png",
      enemy_3: "assets/images/enemies/ufo_4.png",
      empty: "assets/images/player/empty.png"
    }

    AUDIO_ASSETS = {
      title_music: "assets/fixtures/Tronic-Trouble_v001.mp3",
      stage_music_0: "assets/fixtures/Hypnotic-Puzzle.mp3",
      stage_music_1: "assets/fixtures/The-Toy-Factory.mp3",
      stage_music_2: "assets/fixtures/Mega_Drive-Converter.mp3",
      stage_music_3: "assets/fixtures/Defending-Their-City.mp3",
      game_over_music: "assets/fixtures/Evil-Automation.mp3",

    }

    FX_ASSETS = {
      shoot_0: "assets/fixtures/shoot.wav",
      shoot_1: "assets/fixtures/bomb_2.wav",
      shoot_2: "assets/fixtures/missle.wav",
      shoot_3: "assets/fixtures/lazt.wav",
      kill: "assets/fixtures/bomb_explosion.wav",
      shoot: "assets/fixtures/shoot.wav",
      death: "assets/fixtures/death.wav",
      blast: "assets/fixtures/blast.wav",
      radio: "assets/fixtures/radio.flac",
      reload: "assets/fixtures/reload.wav",

    }

    FONT_ASSETS = {
      font: "assets/fonts/pixelade-webfont.ttf"
    }

    def initialize
      super 857, 1050
      self.caption = "Space Dick: PT:1"
      @images = {}
      @audio = {}
      @track = 0
      @fx = {}
      @paused = false

      @ship = nil
      # @shield = new
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
      @audio[:"stage_music_#{@track = rand(4)}"].play(true)
      @screen = :stageUI
    end

    def draw
      @images[@screen].draw(0, 0, 2)
      @font.draw("ESC to Quit", 20, 10, 3, 1, 0.8, Gosu::Color::GRAY)


      if @screen == :stageUI
        @ship.draw
        # @shield.draw
        @bullets.each {|bullet| bullet.draw }
        @enemies.each {|enemy| enemy.draw }

        if @space_y < 0
          @space_y += SPEED * $game.delta
        else
          @space_y = -1050
        end
        @images[:space].draw(0, @space_y, 0)

        @font.draw("SCORE", 50, 878, 3, 2, 1, Gosu::Color::WHITE)
        @font.draw("#{@score}".rjust(5, '0'), 52, 918, 3, 2, 1, Gosu::Color::WHITE)

        # @font.draw("#{@ship.bullet}", 668, 892, 3, 2, 1, Gosu::Color::WHITE)

        @font.draw("WEAPON", 712, 877, 3, 1.2, 0.75, Gosu::Color::WHITE)
        @images[:"bullet_#{@ship.bullet}"].draw(736, 935, 2, 2.5, 2.5)
        track_title = AUDIO_ASSETS[:"stage_music_#{@track}"].split('/')[-1]

        @font.draw("Track: #{track_title}", 580, 10, 3, 0.6, 0.7, Gosu::Color::GRAY)
        # @font.draw("Track:#{@track}", 600, 10, 3, 0.7, 0.7, Gosu::Color::WHITE)
        # @font.draw("PAUSED", 67, 210, 3, 8, 7, Gosu::Color::GRAY) if @paused
        #
        if @paused
          @font.draw("PAUSED", 67, 210, 3, 8, 7, Gosu::Color::GRAY)
          @font.draw("<space> ................ shoot", 230, 500, 3, 1.3, 1, Gosu::Color::WHITE)
          @font.draw("<A> .... change weapon", 230, 532, 3, 1.3, 1, Gosu::Color::WHITE)
          @font.draw("<D> ........... change song", 230, 564, 3, 1.3, 1, Gosu::Color::WHITE)
          @font.draw("<P> ............ toggle pause", 230, 596, 3, 1.3, 1, Gosu::Color::WHITE)
        end


      elsif @screen == :background_game_over
        @font.draw("SCORE: #{@score.to_s.rjust(5, '0')}", 244, 522, 3, 2, 1, Gosu::Color::WHITE)

        prompt = "Hit <Enter> to play again"
        if Time.now.to_i % 2 == 0
            @font.draw(prompt, 229, 445, 3, 1.2, 0.7, Gosu::Color::AQUA)
        end



      end
    end

    def update
      if @screen == :stageUI
        unless @paused
          self.update_delta
          self.spawn_enemies

          @ship.update
          @shield.update(@ship.x, @ship.y, 3)
          @bullets.each {|bullet| bullet.update }
          @enemies.each {|enemy| enemy.update }

          self.handle_kills
        else
          puts "paused"
          #@screen = :paused_backround
        end
      end
    end

    def button_up(key)
      if key == Gosu::KbEscape
        self.close
      end

      if @screen == :background_title
        self.stage
      elsif @screen == :background_game_over
        if key == Gosu::KbReturn
          @dead = false
          restart
          self.begin!
        end
      elsif @screen == :stageUI

        if key == Gosu::KbSpace
          self.shoot
        end
        @ship.bullet = (@ship.bullet + 1) % 4 if key == (Gosu::KbA)
        # @audio[:"stage_music_#{(@track += 1) % 4}"].play(true) if key == (Gosu::KbD)
        if key == (Gosu::KbD)
          @fx[:radio].play(0.2)
          @audio[:"stage_music_#{@track = (@track + 1) % 4}"].play(true)
        end
        if key == (Gosu::KbP)
          @paused ^= true
          toggle_music
          # @screen = :stageUI if @paused
        end


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
      puts @last_time
    end

    def setup_game
      @last_time = Gosu::milliseconds / 1000.0
      @ship = Ship.new
      @shield = Shield.new
      @score = 0
    end

    def shoot
      @bullets.push(Bullet.new(@ship.x, @ship.y, @ship.bullet)) unless @ship.nil?
      @fx[:"shoot_#{@ship.bullet}"].play(0.2)
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
      @fx[:blast].play(0.3)
      @fx[:shoot_2].play
      @screen = :background_game_over
      @audio[:game_over_music].play(true)
    end

    def restart
      @bullets = []
      @enemies = []
    end

    def toggle_music
      current_song = Gosu::Song.current_song
      # puts "#{Gosu::Song.current_song}"if Gosu::Song.current_song
      if current_song.playing?
        current_song.pause
      else
        current_song.play(true)
      end
    end



  end# class game
end#module
