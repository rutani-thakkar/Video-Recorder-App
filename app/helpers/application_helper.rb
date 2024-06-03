module ApplicationHelper
  def user_can_edit(video)
    video.user == current_user
  end
end
