require 'spec_helper'

describe Video do
  it "should save itself" do
    video = Video.new(title: "monk", description: "great video")
    video.save
    expect(Video.first).to eq(video)
  end

  it "should belong to a category" do
    comedies = Category.create(tag: "comedies")
    video = Video.create(title: "monk", description: "funny", category_id: comedies.id)
    expect(video.category).to eq(comedies)
  end

  it "does not save without a title" do
    video = Video.new(description: "some stuff")
    expect(video.save).to eq(false)
  end

  it "does not save without a description" do 
    video = Video.new(title: "Title")
    expect(video.save).to eq(false)
  end
end
