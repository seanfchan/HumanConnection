require 'spec_helper'

describe "accounts/new.html.erb" do
  before(:each) do
    assign(:account, stub_model(Account,
      :login => "MyString",
      :password => "MyString",
      :account_type => 1,
      :oauth_token => "MyString"
    ).as_new_record)
  end

  it "renders new account form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => accounts_path, :method => "post" do
      assert_select "input#account_login", :name => "account[login]"
      assert_select "input#account_password", :name => "account[password]"
      assert_select "input#account_account_type", :name => "account[account_type]"
      assert_select "input#account_oauth_token", :name => "account[oauth_token]"
    end
  end
end
