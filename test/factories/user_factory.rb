# File::      user_factory.rb
#
# Author::    Jon Boekenoogen (mailto:jboekeno@gmail.com)
# Copyright:: Copyright (c) 2010 <INSERT_COMPANY_NAME>

# Creates a default user to be used in testing framework.
Factory.define :user do |u|
    u.sequence(:email) { |n|   # Create increasing email addresses  
      "user#{n}@mail.com" 
    } 
    u.salt {                   # Generate sha2 token for salt
      User.make_token 
    } 
    u.password "monkey"
    u.password_confirmation "monkey"
    u.crypted_password { |a|   # Generate encrypted password for "monkey"
                               # Note salt needs to be set first for this to work.
      User.password_digest(a.password, a.salt) 
    }
end
