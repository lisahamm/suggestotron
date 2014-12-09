class Topic < ActiveRecord::Base
  has_many :votes, dependent: :destroy

  def self.by_vote_count(options = {})
    order = options[:order] || :desc
    limit = options[:limit] || 20

    limit = 20 if limit > 20 || limit < 0

    find_by_sql """
      SELECT * FROM topics ORDER BY (
        SELECT COUNT(*) FROM votes WHERE topic_id = topics.id
      ) #{order} LIMIT #{limit}
    """
  end
end
