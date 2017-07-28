      @audio = [
      stage_music_0: "assets/fixtures/Hypnotic-Puzzle.mp3",
      stage_music_1: "assets/fixtures/The-Toy-Factory.mp3",
      stage_music_2: "assets/fixtures/Tronic-Trouble_v001.mp3",
      stage_music_3: "assets/fixtures/Defending-Their-City.mp3",
    ]
    # puts @audio

    track = 1

    title = @audio[:"stage_music_#{track.to_s}"]
    puts "title:#{title}"
