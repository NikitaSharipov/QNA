require 'rails_helper'

shared_examples "Commented" do

  it 'create comment' do
    login(user)
    votable = commented.class.name.downcase.to_sym
    expect { post :create_comment, params: { id: commented, votable => { comment_body: 'text' } } }.to change(Comment, :count).by 1
  end
end
