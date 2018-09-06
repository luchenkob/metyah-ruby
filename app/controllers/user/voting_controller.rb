class User::VotingController < ApplicationController
  def vote
    @voter = User.find(params[:voter_id])
    @votable = User.find(params[:votable_id])
    @vote_action = params[:vote_action].to_s.downcase.to_sym
    @action_scope = params[:action_scope].to_s.downcase.to_sym

    case @vote_action
    when :upvote
      puts "Upvote"
      @voter.upvotes(@votable)
    when :downvote
      puts "downvote"
      @voter.downvotes(@votable)
    when :unvote
      puts "unvotes"

      @voter.votes.where(votable_id: @votable.id).destroy_all
    end

    respond_to do |format|
      format.js
    end
  end
end
