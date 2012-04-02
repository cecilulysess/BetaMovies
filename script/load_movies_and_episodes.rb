Movie.transaction do 
  (1..200).each do |i|
    a_movie = Movie.create(:title => "TestMovie#{i}", :description => "#{i}'s Desc",
                 :image_url => "#{i}.jpg", :last_updated => DateTime.now,
                 :is_finished => true )
                
    (1..50).each do |j|
      Episode.create(:episode_title => "#{j}", :link => "http://bbs.sends.cc/ulysess/eftest720p.mp4",
                     :movie_id => a_movie.id)
    end
  end
end