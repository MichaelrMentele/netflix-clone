require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should have_many(:reviews).order("created_at DESC")}

  describe "search_by_title" do
    it "returns an empty array when there are no matches" do
      futurama = Video.create(title: 'blah', description: "can't be empty")
      expect(Video.search_by_title("test")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      test = Video.create(
        {
        title: "test",
        description: "can't be empty"
        }
      )
      matches = Video.search_by_title("test")
      expect(matches).to eq([test])
    end

    it "returns array of one for partial match" do
      Video.create([
        {
        title: "testing",
        description: "can't be empty"
        },
        {
        title: "dog",
        description: "can't be empty"
        },
      ])
      matches = Video.search_by_title("test")
      expect(matches.size).to eq(1)
    end

    it "returns an array of all matches ordered by create time" do
      testing = Video.create(title: "testing",
        description: "can't be empty"
        )
      tester = Video.create(title: "tester",
        description: "can't be empty",
        created_at: 1.day.ago
        )

      matches = Video.search_by_title("test")
      expect(matches).to eq([testing, tester])
    end

    it "returns an empty array when an empty string is searched" do 
      testing = Video.create(title: "testing",
        description: "can't be empty"
        )
      tester = Video.create(title: "tester",
        description: "can't be empty",
        created_at: 1.day.ago
        )

      expect(Video.search_by_title("")).to eq([])
    end
  end
end
