require 'spec_helper'

describe "accounts/index.html.erb" do
  before(:each) do
    assign(:accounts, [
      stub_model(Account,
        :login => "Login",
        :password => "Password",
        :account_type => 1,
        :oauth_token => "Oauth Token"
      ),
      stub_model(Account,
        :login => "Login",
        :password => "Password",
        :account_type => 1,
        :oauth_token => "Oauth Token"
      )
    ])
  end

  it "renders a list of accounts" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Login".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Oauth Token".to_s, :count => 2
  end
end
