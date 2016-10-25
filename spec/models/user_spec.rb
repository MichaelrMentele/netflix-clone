require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:reviews).order('created_at DESC') }
  it { is_expected.to have_many(:queue_items).order('position ASC') }

  it_behaves_like "tokenable" do 
    let(:obj) { Fabricate(:user) }
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

  describe "#follow" do 
    it "follows another user" do 
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to eq(true)
    end
    it "does not follow oneself" do 
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to eq(false)
    end
  end

  describe "#deactivate!" do 
    it "sets the active boolean to false" do 
      alice = Fabricate(:user, active: true)
      alice.deactivate!
      expect(alice.reload).not_to be_active
    end
  end
end