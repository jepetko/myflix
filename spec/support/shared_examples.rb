shared_examples 'requires sign in' do
  it 'redirects to sign in page' do
    logout_user
    action
    response.should redirect_to sign_in_path
    expect(flash[:error]).to be
  end
end