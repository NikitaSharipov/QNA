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

end
