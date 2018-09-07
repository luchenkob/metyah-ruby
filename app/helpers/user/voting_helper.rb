module User::VotingHelper
  def vote_status(voter, votable)
    vote = voter.voted_as_when_voted_for(votable)
    case vote
    when true
      "Favorite"
    when nil
      "No Preference"
    when false
      "Blocked"
    end
  end
end
