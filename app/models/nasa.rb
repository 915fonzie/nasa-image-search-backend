class Nasa < ApplicationRecord
    include PgSearch::Model

    has_many :keywords
    has_many :hrefs

    pg_search_scope :search_by_term, against: [:title, :description, :photographer],
    using: {
        tsearch: {
            any_word: true,
            prefix: true
        }
    }

end
