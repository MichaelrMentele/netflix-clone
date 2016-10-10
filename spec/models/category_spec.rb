require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:tag) }
  describe "recent_videos" do 
    it "should return the NUM_RECENT_VIDEOS of recent videos if more than six" do 
      test = Category.create(tag: "test")
      7.times { Video.create(title: "a", description: "a", category_id: test.id) }
      expect(test.recent_videos.size).to eq(6)
    end
    it "should return all videos if there are less than NUM_RECENT_VIDEOS total" do 
      test = Category.create(tag: "test")
      a = Video.create(title: "a", description: "a", category_id: test.id)
      expect(test.recent_videos).to eq([a])
    end
    it "should return the NUM_RECENT_VIDEOS of recent videos in reverse chronological order by created at" do
      test = Category.create(tag: "test")
      a = Video.create(title: "a", description: "a", category_id: test.id, created_at: 3.day.ago)
      b = Video.create(title: "b", description: "b", category_id: test.id, created_at: 2.day.ago)
      c = Video.create(title: "c", description: "c", category_id: test.id, created_at: 1.day.ago)
      expect(test.recent_videos).to eq([c,b,a])
    end
    it "should return an empty array if there are no videos" do
      test = Category.create(tag: "test")
      expect(test.recent_videos).to eq([])
    end
  end
end