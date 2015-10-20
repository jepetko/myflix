class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new video_params
    if @video.save
      flash[:success] = "The video #{@video.title} has been created."
      redirect_to new_admin_video_path
    else
      flash[:danger] = 'The video could not be created.'
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :link)
  end
end