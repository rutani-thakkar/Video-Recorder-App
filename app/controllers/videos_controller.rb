class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: %i[show edit update destroy publish unpublish]
  before_action :check_user_access, only: :edit

  def index
    @videos = Video.where("user_id = ? OR published = ?", current_user.id, true)
  end

  def new
    @video = Video.new
  end

  def edit; end

  def create
    @video = current_user.videos.new(video_params)
    if @video.save
      redirect_to videos_path, notice: 'Video was successfully created.'
    else
      render :new
    end
  end

  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @video.destroy
    redirect_to videos_path, notice: 'Video was successfully Deleted.'
  end

  def publish
    @video.update(published: true)
    redirect_to @video, notice: 'Video was successfully published.'
  end

  def unpublish
    @video.update(published: false)
    redirect_to @video, notice: 'Video was successfully unpublished.'
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :transcript, :file)
  end

  def check_user_access
    if @video.user == current_user
      return true
    else
      redirect_to videos_path, notice: 'You are not authorized to edit this.'
    end
  end
end
