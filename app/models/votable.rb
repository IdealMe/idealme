module Votable
  extend ActiveSupport::Concern

  module ClassMethods
    def is_votable
      true
    end
  end

  module InstanceMethods
    def vote_score
      self.up_votes - self.down_votes
    end

    def up_voted?(owner)
      !Vote.where(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id, :up_vote => true, :down_vote => false).first.nil?
    end

    def down_voted?(owner)
      !Vote.where(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id, :up_vote => false, :down_vote => true).first.nil?
    end

    def un_vote(owner)
      ActiveRecord::Base.transaction do
        vote = Vote.where(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id).first
        if vote
          if vote.up_vote
            self.up_votes -= 1
          elsif vote.down_vote
            self.down_votes -= 1
          end
          vote.destroy
          self.save!
        end
      end
    end

    def up_vote(owner)
      ActiveRecord::Base.transaction do
        vote = Vote.where(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id).first
        if vote.nil?
          vote = Vote.create!(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id, :up_vote => true, :down_vote => false)
          self.up_votes += 1
          self.save!
        else
          if vote.down_vote
            vote.up_vote = true
            vote.down_vote = false
            vote.save!
            self.up_votes += 1
            self.down_votes -= 1
            self.save!
          end
        end
        vote
      end
    end

    def down_vote(owner)
      ActiveRecord::Base.transaction do
        vote = Vote.where(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id).first
        if vote.nil?
          vote = Vote.create!(:votable_type => self.class.name, :votable_id => self.id, :owner_id => owner.id, :up_vote => false, :down_vote => true)
          self.down_votes += 1
          self.save!
        else
          if vote.up_vote
            vote.up_vote = false
            vote.down_vote = true
            vote.save!
            self.up_votes -= 1
            self.down_votes += 1
            self.save!
          end
        end
        vote
      end
    end
  end
end
