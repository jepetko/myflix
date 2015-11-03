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

  def as_indexed_json(options={})
    as_json only: [:title, :description], include: {reviews: { only: [:content] }}
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
      {
          query: {
              multi_match: {
                  query: query,
                  fields: fields,
                  operator: 'and'
              }
          }
      }
    end
  end

end