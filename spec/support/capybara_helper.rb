module CapybaraHelper
  def sign_in(user)
    visit sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end

  def sign_out(user)
    click_link "Welcome, #{user.full_name}"
    click_link 'Sign Out'
  end

  def follow_reviewer_of_the_video(video, reviewer)
    click_link 'Videos'
    find(:xpath, "//a[@href='#{video_path(video)}']").click
    within("//article[@class='review']") do
      find(:xpath, "*/*/*/a[@href='#{user_path(reviewer)}']")
    end.click
    click_link 'Follow'
  end
end