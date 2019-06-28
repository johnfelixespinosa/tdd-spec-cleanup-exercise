require "rails_helper"

RSpec.describe Invitation do

  describe "callbacks" do
    describe "after_save" do
      context "with valid data" do
        it "invites the user" do
          user = User.new(email: "rookie@example.com")
          team = Team.new(name: "A fine team")
          invitation = Invitation.new(team: team, user: user)

          invitation.save
          
          expect(user).to be_invited
        end
      end

      context "with invalid data" do
        it "does not save the invitation" do
          user = User.new(email: "rookie@example.com")
          team = Team.new(name: "A fine team")
          invitation = Invitation.new(team: team, user: user)
          invitation.team = nil
          
          invitation.save
          
          expect(invitation).not_to be_valid
          expect(invitation).to be_new_record
        end

        it "does not mark the user as invited" do
          user = User.new(email: "rookie@example.com")
          team = Team.new(name: "A fine team")
          invitation = Invitation.new(team: team, user: user)
          invitation.team = nil
          
          invitation.save
          
          expect(user).not_to be_invited
        end
      end
    end
  end

  describe "#event_log_statement" do
    context "when the record is saved" do

      it "include the name of the team" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        
        invitation.save
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("A fine team")
      end

      it "include the email of the invitee" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        
        invitation.save
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("rookie@example.com")
      end
    end

    context "when the record is not saved but valid" do
      it "includes the name of the team" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("A fine team")
      end

      it "includes the email of the invitee" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("rookie@example.com")
      end

      it "includes the word 'PENDING'" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("PENDING")
      end
    end

    context "when the record is not saved and not valid" do
      it "includes INVALID" do
        user = User.new(email: "rookie@example.com")
        team = Team.new(name: "A fine team")
        invitation = Invitation.new(team: team, user: user)
        invitation.user = nil
        
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("INVALID")
      end
    end
  end
end