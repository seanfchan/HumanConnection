require 'spec_helper'

describe "accounts/edit.html.erb" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :new_record? => false,
      :login => "MyString",
      :password => "MyString",
      :account_type => 1,
      :oauth_token => "MyString"
    ))
  end

  it "renders the edit account form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => account_path(@account), :method => "post" do
      assert_select "input#account_login", :name => "account[login]"
      assert_select "input#account_password", :name => "account[password]"
      assert_select "input#account_account_type", :name => "account[account_type]"
      assert_select "input#account_oauth_token", :name => "account[oauth_token]"
    end
  end
end
