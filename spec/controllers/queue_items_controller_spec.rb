require 'spec_helper'

describe QueueItemsController do

  describe 'GET :index' do

    context 'for authorized user' do

      before do
        user = Fabricate(:user)
        login_user user
      end

      it 'sets the @queue_items variable' do
        queue_item_1 = Fabricate(:queue_item, user: current_user)
        queue_item_2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array [queue_item_1, queue_item_2]
      end
    end

    context 'for unauthorized user' do
      it 'redirects to the sign_in page' do
        get :index
        expect(response).to redirect_to sign_in_path
      end
      it 'sets the error message' do
        get :index
        expect(flash[:error]).to be
      end
    end
  end

end