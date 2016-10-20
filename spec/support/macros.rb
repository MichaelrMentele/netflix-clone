def set_current_user(user: nil, clear: false)
  if clear
    session[:user_id] = nil
  else
    session[:user_id] = user || Fabricate(:user).id
  end
end

def set_current_admin(admin: nil)
  session[:user_id] = admin || Fabricate(:admin).id
end

def current_user
  User.find(session[:user_id])
end

def sign_in(user=nil, admin: false)
  admin ? user_type = :admin : user_type = :user

  user = user || Fabricate(user_type)

  visit login_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  click_link "Welcome"
  click_link("Sign Out")
end

def view(video)
  find("a[href='/videos/#{video.id}']").click
  page.should have_content video.title
end