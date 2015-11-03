class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ['myflix', Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :link, LinkUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('lower(title) LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

  def average_rating
    reviews.average(:rating).round(2).to_f if reviews.any?
  end

  def as_indexed_json(options={})
    as_json methods: [:average_rating], only: [:title, :description], include: {reviews: { only: [:content] }}
  end

  def self.search(query, options={})
    builded_query = build_query(query, options)
    self.__elasticsearch__.search builded_query
  end

  def self.explain(query, options={})
    builded_query = build_query(query, options)
    self.__elasticsearch__.client.explain index: index_name, type: 'video', id: options[:id], body: builded_query
  end

  private

  def self.build_query(query, options={})
    if query.present?
      fields = %w{title^100 description^50}
      fields << 'reviews.content^1' if options[:reviews].present?
      query_obj = {
        query: {
            multi_match: {
                query: query,
                fields: fields,
                operator: 'and'
            }
        }
      }

      if options[:rating_from].present? || options[:rating_to].present?
        ranking = {}
        ranking[:gte] = options[:rating_from] if options[:rating_from].present?
        ranking[:lte] = options[:rating_to] if options[:rating_to].present?
        query_obj[:filter] = {
          range: {
              average_rating: ranking
          }
        }
      end
      query_obj
    end
  end
end