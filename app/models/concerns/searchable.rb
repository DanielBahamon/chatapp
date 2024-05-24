module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {
      analysis: {
        tokenizer: {
          ngram_tokenizer: {
            type: 'ngram',
            min_gram: 3,
            max_gram: 4,
            token_chars: ['letter', 'digit']
          }
        },
        analyzer: {
          ngram_analyzer: {
            type: 'custom',
            tokenizer: 'ngram_tokenizer',
            filter: ['lowercase']
          }
        }
      }
    } do
      mapping do
        indexes :body, type: 'text', analyzer: 'ngram_analyzer'
      end
    end
  end

  def self.search(query, chat_id = nil)
    must_clauses = [{ match: { body: { query: query, operator: 'and' } } }]
    must_clauses << { term: { chat_id: chat_id } } if chat_id

    params = {
      query: {
        bool: {
          must: must_clauses
        }
      }
    }
    self.__elasticsearch__.search(params).records
  end
end
