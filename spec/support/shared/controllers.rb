shared_examples_for 'To save a new object' do
  it 'saves a new object in the database' do
    expect { post :create, params: params, format: :js }.to change(object_class, :count).by(1)
  end
end

shared_examples_for 'does not save a new object' do
  it 'does not save a new object' do
    expect { post :create, params: params, format: :js }.to_not change(object_class, :count)
  end
end

shared_examples_for 'To update the object' do
  it 'update the object in the database' do
    patch :update, params: params.merge(id: object.id), format: :js
    expect(assigns(('exposed_' + object.class.to_s.downcase).to_sym)).to eq object
  end
end

shared_examples_for 'To change the object attributes' do
  it 'change the object attributes' do
    patch :update, params: params.merge(id: object.id), format: :js
    object.reload

    expect(object.title).to eq 'new_title' if object.respond_to?(:title)
    expect(object.body).to eq 'new_body'
  end

  it 'render update view' do
    patch :update, params: params.merge(id: object.id), format: :js
    expect(response).to render_template :update
  end
end

shared_examples_for 'To render update view' do
  it 'render update view' do
    patch :update, params: params.merge(id: object.id), format: :js
    expect(response).to render_template :update
  end
end

shared_examples_for 'To delete the object' do
  it 'deletes the object' do
    expect { delete :destroy, params: { id: object }, format: :js }.to change(object_class, :count).by(-1)
  end
end
