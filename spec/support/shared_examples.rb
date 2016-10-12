shared_examples "require_sign_in" do
  it "redirects to the home page" do
    set_current_user(clear=true)
    action
    expect(response).to redirect_to login_path
  end
end