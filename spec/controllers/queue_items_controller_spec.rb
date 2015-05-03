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

  describe 'POST :create' do


    context 'for authorized user' do

      before do
        user = Fabricate(:user)
        login_user user
        post :create, queue_item: Fabricate.attributes_for(:queue_item)
      end

      it 'adds a new item to the queue' do
        expect(QueueItem.count).to be 1
      end
      it 'belongs to the queue of the current user' do
        expect(QueueItem.last.user).to eq current_user
      end
      it 'redirects to the my_queue page' do
        expect(response).to redirect_to my_queue_path
      end
      it 'sets the notice' do
        expect(flash[:notice]).to be
      end
    end

    context 'for unauthorized user' do

      before do
        post :create, queue_item: Fabricate.attributes_for(:queue_item)
      end

      it 'redirects to the sign_in page' do
        expect(response).to redirect_to sign_in_path
      end

      it 'sets the error message' do
        expect(flash[:error]).to be
      end
    end
  end

end