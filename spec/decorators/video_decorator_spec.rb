require 'spec_helper'

describe VideoDecorator do 
  describe "#average_rating" do 
    let!(:video) { Fabricate(:video) }
    it "computes the average there is at least one review" do 
      review1 = Fabricate(:review, rating: 1, video: video)
      review2 = Fabricate(:review, rating: 3, video: video)
      expect(VideoDecorator.new(video).average_rating).to eq(2)
    end
    it "returns 0 if there is no reviews" do 
      expect(VideoDecorator.new(video).average_rating).to eq(0)
    end
  end
end