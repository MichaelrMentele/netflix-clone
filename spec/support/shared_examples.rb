shared_examples "require_sign_in" do
  it "redirects to the home page" do
    set_current_user(clear: true)
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "tokenable" do 
  it "generates a random token when the object is created" do
    expect(obj.token).to be_present
  end
end