require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "movie attributes must not be empty" do
    movie = Movie.new
    assert movie.invalid?
    assert movie.errors[:title].any?
    assert movie.errors[:description].any?
    assert movie.errors[:image_url].any?
    # assert movie.errors[:is_finished].any?
    # assert movie.errors[:last_updated].any?
  end
  
  def new_movie(image_url) 
    Movie.new (:title => "test movie",
               :description => " tset desdf",
               :image_url => image_url
               :is_finished =>true)
  end
  
  test "movie image url is gif jpg and png" do
    ok = %w{frwer.gif sdfi.jpg sidof.png sodifj.JPG sdoif.Jpg http://sdfisjdfij/sdfoij/sdfjoi.gif}
    bad = %w{fsdf.doc sdfi.gif/more sdifojs.more}
    
  end
end
