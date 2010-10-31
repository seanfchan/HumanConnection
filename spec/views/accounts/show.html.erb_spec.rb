require 'spec_helper'

describe "accounts/show.html.erb" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :login => "Login",
      :password => "Password",
      :account_type => 1,
      :oath_token => "Oath Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Login/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Password/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Oath Token/)
  end
end
