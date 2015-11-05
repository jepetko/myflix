require 'spec_helper'

describe Admin::PaymentsController do

  describe 'get :index' do

    before(:each) do
      admin = Fabricate(:admin)
      login_user admin
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end

    it 'shows the payments' do
      user = Fabricate(:user, stripe_id: 'cus_123')
      Fabricate.times(2, :payment, user: user)
      get :index
      expect(assigns(:payments)).to eq Payment.all
    end

  end

end