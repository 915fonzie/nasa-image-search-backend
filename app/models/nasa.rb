class Nasa < ApplicationRecord
    include PgSearch::Model

    has_many :keywords
    has_many :hrefs
    pg_search_scope :search_by_term, against: [:title, :description, :photographer], #defining what can be used to find the file you're looking for
    using: {
        tsearch: { #using tsearch to be able to search every word against eveything that's defined
            any_word: true,
            prefix: true
        }
    }

end
