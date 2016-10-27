class Video < ActiveRecord::Base
<<<<<<< HEAD
  include Elasticsearch::Model
  index_name ["myflix", Rails.env].join('_') # create separate indexes for each environment

||||||| merged common ancestors
=======
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks # auto imports to active record to keep them synchronized

  index_name ["myflix", Rails.env].join('_') # create separate indexes for each environment

>>>>>>> elastic-search
  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC'}
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }

    if query.present? && options[:reviews].present?
      search_definition[:query][:multi_match][:fields] << "reviews.description"
    end

    if options[:rating_from].present? || options[:rating_to].present?
      lower_bound = options[:rating_from] ? options[:rating_from].to_f : 0
      upper_bound = options[:rating_to] ? options[:rating_to].to_f : 5

      search_definition[:filter] = {
        range: {
          average_rating: {
            gte: lower_bound,
            lte: upper_bound
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      only: [:title, :description], 
      methods: [:average_rating],
      include: { 
        reviews: { only: [:description] } 
      }
    )
  end  

  def average_rating
    reviews.size > 0 ? rating_sum / reviews.size.to_f : 0.0
  end

  private
  
  def rating_sum
    reviews.inject(0) { |sum, review| sum + review.rating }
  end
end