class User::VotingController < ApplicationController
  def vote
    @voter = User.find(params[:voter_id])
    @votable = User.find(params[:votable_id])
    @action = params[:action].to_s.downcase.to_sym
    @action_scope = params[:action_scope].to_s.downcase.to_sym

    case action
    when :upvote
      @voter.upvotes(@votable)
    when :downvote
      @voter.downvotes(@votable)
    end

    respond_to do |format|
      format.js
    end
  end
end
