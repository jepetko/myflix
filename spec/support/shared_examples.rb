shared_examples 'requires sign in' do
  it 'redirects to sign in page' do
    logout_user
    action
    expect(response).to redirect_to sign_in_path
    expect(flash[:error]).to be
  end
end

shared_examples 'requires admin' do
  it 'redirects to the home path' do
    logout_user
    login_user Fabricate(:user)
    action
    expect(response).to redirect_to home_path
    expect(flash[:danger]).to be
  end
end