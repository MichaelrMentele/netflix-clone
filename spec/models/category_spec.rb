require 'spec_helper'

describe Category do
  it "saves itself" do 
    cat = Category.new(tag: "comedies")
    cat.save
    expect(Category.first).to eq(cat)
  end

  it "has many videos" do 
    cat = Category.create(tag: "comedies")
    monk = Video.create(title: "monk", description: "funny", category_id: cat.id)
    futurama = Video.create(title: "futurama", description: "funny", category_id: cat.id)
    south_park = Video.create(title: "south park", description: "funny", category_id: cat.id)

    expect(cat.videos).to include(monk, futurama, south_park)
  end
end