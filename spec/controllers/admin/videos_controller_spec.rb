require 'spec_helper'

describe Admin::VideosController do

  include CarrierWave::Test::Matchers

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
      expect(assigns(:video)).to be_a_new(Video)
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
      before(:each) do
        admin = Fabricate(:admin)
        login_user admin
      end

      context 'without images' do

        before do
          video_attrs = Fabricate.attributes_for(:video, category_id: category.id)
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

      context 'with images' do

        before do
          video_attrs = Fabricate.attributes_for(:video_with_covers_provided, category_id: category.id)
          LargeCoverUploader.enable_processing = true
          SmallCoverUploader.enable_processing = true
          post :create, video: video_attrs
        end
        after do
          LargeCoverUploader.enable_processing = false
          SmallCoverUploader.enable_processing = false
        end

        it 'processes large cover image' do
          expect(Video.last.large_cover.url).to be
        end

        it 'processes small cover image' do
          expect(Video.last.small_cover.url).to be
        end

        it 'resizes the small cover image to' do
          expect(Video.last.small_cover).to have_dimensions(166, 236)
        end

        it 'resizes the large cover image to' do
          expect(Video.last.large_cover).to have_dimensions(665, 375)
        end

        it 'builds the name as composition of the original file name, attribute, uploader and UUID' do
          file_name = File.basename(Video.last.large_cover.url)
          expect(file_name).to match(/picture_dummy__large_cover__LargeCoverUploader__[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}\.png/)
        end
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