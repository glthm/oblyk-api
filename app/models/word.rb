# frozen_string_literal: true

class Word < ApplicationRecord
  include Slugable
  include Searchable
  include ActivityFeedable

  has_paper_trail only: %i[name definition]

  has_one_attached :picture
  belongs_to :user, optional: true
  has_many :reports, as: :reportable

  validates :name, :definition, presence: true

  default_scope { order(:name) }

  def summary_to_json
    JSON.parse(
      ApplicationController.render(
        template: 'api/v1/words/summary.json',
        assigns: { word: self }
      )
    )
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: %w[name],
            fuzziness: :auto
          }
        }
      }
    )
  end

  def feed_parent_id
    id
  end

  def feed_parent_type
    self.class.name
  end
end
