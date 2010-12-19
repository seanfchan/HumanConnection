require 'test_helper'

class RoutingTest < ActionController::TestCase

  def test_email_account_routes
    email = ["email_accounts", "gmail_accounts", "hotmail_accounts", "yahoo_accounts"]
    email.each { |account|
      assert_routing "/#{account}/new", { :controller => account, :action => "new" }
      assert_routing "/#{account}/1/edit", { :controller => account, :action => "edit", :id => "1" }
      assert_routing "/#{account}/1", { :controller => account, :action => "show", :id => "1" }
      assert_routing({ :method => "post", :path => "#{account}" }, { :controller => account, :action => 'create' })
      assert_routing({ :method => "put", :path => "#{account}/1" }, { :controller => account, :action => 'update', :id => "1" })
      assert_routing({ :method => "delete", :path => "#{account}/1" }, { :controller => account, :action => 'destroy', :id => "1" })
    }
  end

  def test_phone_account_routes
    phone = ["phone_accounts", "android_accounts", "iphone_accounts", "win_mob_accounts", "blackberry_accounts"]
    phone.each { |account|
      assert_routing "/#{account}/new", { :controller => account, :action => "new" }
      assert_routing "/#{account}/1/edit", { :controller => account, :action => "edit", :id => "1" }
      assert_routing "/#{account}/1", { :controller => account, :action => "show", :id => "1" }
      assert_routing({ :method => "post", :path => "#{account}" }, { :controller => account, :action => 'create' })
      assert_routing({ :method => "put", :path => "#{account}/1" }, { :controller => account, :action => 'update', :id => "1" })
      assert_routing({ :method => "delete", :path => "#{account}/1" }, { :controller => account, :action => 'destroy', :id => "1" })
    }
  end

  def test_social_account_routes
    social = ["facebook_accounts", "linked_in_accounts", "twitter_accounts"]
    social.each { |account|
      assert_routing "/#{account}/new", { :controller => account, :action => "new" }
      assert_routing "/#{account}/callback", { :controller => account, :action => "callback" }
      assert_routing "/#{account}/1", { :controller => account, :action => "show", :id => "1" }
      assert_routing({ :method => "delete", :path => "#{account}/1" }, { :controller => account, :action => 'destroy', :id => "1" })
    }
  end

  def test_accounts_routes
    assert_routing "/accounts", { :controller => "accounts", :action => "index" }
  end

  def test_home_routes
    assert_routing "/home", { :controller => "home", :action => "index" }
  end

  def test_custom_routes
    assert_routing "/home", { :controller => "home", :action => "index" }
    assert_routing "/signup", { :controller => "users", :action => "new" }
    assert_routing "/register", { :controller => "users", :action => "create" }
    # TODO: @jon Figure out why these two test cases do not work
    # assert_routing "/login", { :controller => "sessions", :action => "new" }
    # assert_routing "/logout", { :controller => "sessions", :action => "destroy" }
    assert_routing "/activate/123asdf", { :controller => "users", :action => "activate", :activation_code => "123asdf" }
  end

end
