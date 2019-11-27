require 'rails_helper'

shared_examples_for 'Votable' do
  it 'should create vote' do
    votable.vote_up(another_user)
    expect(votable.votes.where(user: another_user).first.value).to eq 1
  end

  describe 'Author'

  it "shouldn't create vote for author" do
    votable.vote_up(user)
    expect(votable.votes.where(user: user).first).to eq nil
  end

  it "should show if not voted" do
    expect(votable.voted?(user)).to eq false
  end

  it "should show if voted" do
    votable.vote_up(another_user)
    expect(votable.voted?(another_user)).to eq true
  end

  it "should show rating" do
    votable.vote_up(another_user)
    expect(votable.rating).to eq 1
  end

  it "shouldn't vote twice" do
    votable.vote_up(another_user)
    votable.vote_up(another_user)
    expect(votable.rating).to eq 1
  end

  it "should destroy vote" do
    votable.vote_up(another_user)
    votable.cancel(another_user)
    expect(votable.voted?(another_user)).to eq false
  end

  it "should show value of user's vote" do
    votable.vote_up(another_user)
    expect(votable.vote_value(another_user)).to eq 1
  end
end
