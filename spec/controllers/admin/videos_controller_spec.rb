require 'spec_helper'

describe Admin::VideosController do

  describe 'get :new' do

    before(:each) do
      admin = Fabricate(:admin)
      login_user admin
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

    it 'sets @video variable' do
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

  end

  describe 'post :create' do

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    it_behaves_like 'requires admin' do
      let(:action) { post :create, video: {} }
    end

    context 'for valid values' do

      let(:category) { Fabricate(:category) }
      let(:video_attrs) { Fabricate.attributes_for(:video, category_id: category.id) }
      before(:each) do
        admin = Fabricate(:admin)
        login_user admin
        post :create, video: video_attrs
      end

      it 'creates a video' do
        expect(Video.all.count).to be 1
      end

      it 'associates the video with the passed category' do
        expect(Video.last.category).to eq category
      end

      it 'redirects to the new video path' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets the success message' do
        expect(flash[:success]).to be
      end
    end

    context 'for invalid values' do

      let(:video_attrs) { Fabricate.attributes_for(:video, title: '') }
      before(:each) do
        admin = Fabricate(:admin)
        login_user admin
        post :create, video: video_attrs
      end

      it 'does not create a video' do
        expect(Video.count).to be 0
      end

      it 'sets @video variable' do
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets the danger message' do
        expect(flash[:danger]).to be
      end

    end
  end

end