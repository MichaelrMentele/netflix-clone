require 'spec_helper'

describe QueueItem do 
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#rating" do 
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    it "returns the rating from the review when the review is present" do 
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end
    it "returns nil when review is not present" do 
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category_name" do 
    it "returns the category name of the video" do 
      category = Fabricate(:category, tag: "comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("comedies")
    end
  end

  describe "#category" do 
    it "returns the category of the video" do 
      category = Fabricate(:category, tag: "comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end