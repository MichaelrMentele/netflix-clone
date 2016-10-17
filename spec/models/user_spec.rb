require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:reviews).order('created_at DESC') }
  it { is_expected.to have_many(:queue_items).order('position ASC') }

  it "generates a random token when the user is created" do
    alice = Fabricate(:user)
    expect(alice.token).to be_present
  end

  describe "#in_queue" do 
    it "returns true when the video is in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.in_queue?(video)).to be true
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.in_queue?(video)).to be false
    end
  end
end