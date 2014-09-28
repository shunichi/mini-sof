module VotableMethods
  extend ActiveSupport::Concern

  included do
    def votes_by(user)
      votes_for.where(voter: user)
    end

    def vote_value_by(user)
      votes = votes_by(user)
      if votes.size == 0
        0
      else
        votes.first.vote_flag ? 1 : -1
      end
    end

    def toggle_vote_up(user)
      if votes_by(user).up.any?
        unvote_by user
      else
        upvote_by user
      end
    end

    def toggle_vote_down(user)
      if votes_by(user).down.any?
        unvote_by user
      else
        downvote_by user
      end
    end

    def votes_score
      get_upvotes.size - get_downvotes.size
    end
  end
end