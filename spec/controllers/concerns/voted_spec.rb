require 'rails_helper'

shared_examples "Voted" do

  it 'create vote' do
    login(user)
    expect { post :vote_up, params: { id: votable }, format: :json }.to change(Vote, :count).by 1
  end

end
