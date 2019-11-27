require 'rails_helper'

shared_examples_for 'Commentable' do
  it 'should create comment' do
    commentable.create_comment(user, 'test')
    expect(commentable.comments.where(user: user).first.body).to eq 'test'
  end
end
