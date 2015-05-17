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

    let(:monk) { video = Fabricate(:video, title: 'Monk')}
    let(:south_park) { video = Fabricate(:video, title: 'South Park')}

    context 'for authorized user' do

      let(:user) { user = Fabricate(:user)}
      before do
        login_user user
      end
      before do
        Fabricate(:queue_item, video: monk, user: user)
        post :create, video_id: south_park.id
      end
      it 'adds a new item to the queue' do
        expect(QueueItem.count).to be 2
      end
      it 'does not add a video to the queue if it is already there' do
        post :create, video_id: south_park.id
        expect(QueueItem.count).to be 2
      end
      it 'sets the order value to the end of the queue' do
        expect(QueueItem.last.order_value).to eq 2
      end
      it 'is associated with the video' do
        expect(QueueItem.last.video).to eq south_park
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
        post :create, video_id: south_park.id
      end

      it 'redirects to the sign_in page' do
        expect(response).to redirect_to sign_in_path
      end

      it 'sets the error message' do
        expect(flash[:error]).to be
      end
    end
  end

  describe 'DELETE :destroy' do


    context 'for authorized user' do

      let(:user) { user = Fabricate(:user) }
      before do
        login_user user
        2.times do
          Fabricate(:queue_item, user: user)
        end
      end

      it 'removes the video from the queue' do
        delete :destroy, id: user.queue_items.last.id

        expect(user.queue_items.count).to eq 1
      end

      it 'removes the video from the queue of the current user' do
        second_user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: second_user)
        delete :destroy, id: queue_item.id

        expect(second_user.queue_items.count).to eq 1
      end

      it 'reorganizes the order of the remaining items' do
        delete :destroy, id: user.queue_items.sample.id

        user.queue_items.reload
        user.queue_items.each_with_index do |queue_item,idx|
          expect(queue_item.order_value).to eq idx+1
        end
      end

      it 'redirects to the my_queue page' do
        delete :destroy, id: user.queue_items.last.id
        expect(response).to redirect_to my_queue_path
      end

      it 'sets the notice' do
        delete :destroy, id: user.queue_items.last.id
        expect(flash[:notice]).to be
      end
    end

    context 'for unauthorized user' do

      before do
        user = Fabricate(:user)
        2.times do
          Fabricate(:queue_item, user: user)
        end
      end

      it 'does not change the queue items' do
        delete :destroy, id: QueueItem.last.id
        expect(QueueItem.count).to eq 2
      end

      it 'redirects to the sign_in page' do
        delete :destroy, id: QueueItem.last.id
        expect(response).to redirect_to sign_in_path
      end

      it 'sets the error message' do
        delete :destroy, id: QueueItem.last.id
        expect(flash[:error]).to be
      end
    end
  end

  describe 'PUT :update' do

    let(:user) { user = Fabricate(:user) }
    let(:queue_items) { queue_items = QueueItem.order(:id) }
    before do
      3.times do |i|
        Fabricate(:queue_item, user: user, order_value: i+1)
      end
    end

    context 'for authorized user' do
      before do
        login_user user
      end
      context 'for valid order values' do
        it 'updates the order of the queue items' do
          post :update, queue_items: [  {id: queue_items.first, order_value: 1},
                                        {id: queue_items[1].id, order_value: 3},
                                        {id: queue_items.last, order_value: 2} ]

          queue_items.reload
          expect(queue_items.first.order_value).to eq(1)
          expect(queue_items[1].order_value).to eq(3)
          expect(queue_items.last.order_value).to eq(2)
        end

        it 'updates the order of the queue items even if the order values are not continuous' do
          post :update, queue_items: [  {id: queue_items.first, order_value: 1},
                                        {id: queue_items[1].id, order_value: 5},
                                        {id: queue_items.last, order_value: 2} ]

          queue_items.reload
          expect(queue_items.first.order_value).to eq(1)
          expect(queue_items[1].order_value).to eq(3)
          expect(queue_items.last.order_value).to eq(2)
        end
      end

      context 'for invalid values' do

        before do
          post :update, queue_items: [  {id: queue_items.first, order_value: 1},
                                        {id: queue_items[1].id, order_value: 'aaa'},
                                        {id: queue_items.last, order_value: 2} ]
        end

        it 'does not update anything if any order value is not a positive integer' do
          queue_items.reload
          expect(queue_items.first.order_value).to eq(1)
          expect(queue_items[1].order_value).to eq(2)
          expect(queue_items.last.order_value).to eq(3)
        end

        it 'sets the error message if an error occurs' do
          expect(flash[:error]).to be
        end
      end
    end

    context 'for unauthorized user' do

      before do
        post :update, queue_items: [  {id: queue_items.first, order_value: 1},
                                      {id: queue_items[1].id, order_value: 3},
                                      {id: queue_items.last, order_value: 2} ]
      end

      it 'does not update anything' do
        queue_items.reload
        expect(queue_items.first.order_value).to eq(1)
        expect(queue_items[1].order_value).to eq(2)
        expect(queue_items.last.order_value).to eq(3)
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