# Common properties for all accounts
module AccountProperties

  # Called when this module is included
  def self.included(base)

    # Add this code to all classes that include this module
    base.class_eval do
      # Accessors
      attr_accessible :id, :last_sync_time, :person_id, :account_type

      # Relationship
      belongs_to :person

      # Validation
      validates :person_id, :presence => true
      validates :account_type, :presence => true

      # Each account needs to specify this.
      # Ex. Social Accounts use a unique_id check. 
      #     Email Accounts should use email address.
      #     etc...
      def mergeable(other)
        return true
      end

      # Finds an existing account based on the search key.
      # If it is found then it is returned. Otherwise, create 
      # a new person and account then associate them
      def find_or_create(search_key, options)
        # Key to search for better be included
        return if !options.has_key? search_key

        # Check if they are already in the DB
        friend_account = self.class.send("find_by_#{search_key.to_s}", options[search_key])

        # Add an account and person to the DB
        if !friend_account
          # Create a person
          friend_person = Person.new
          friend_person.save

          # Create an account
          options[:person_id] = friend_person.id
          friend_account = self.class.new(options)
          friend_account.save
        end
        friend_account
      end

      # Default merge function for accounts. 
      # Copy over all columns if they are not already filled.
      def merge(other)
        # Make sure these should be merged
        return if !mergeable(other)

        self.class.column_names.each { |column|
          eval "self.#{column} = other.#{column} if self.#{column}.blank?"
        }
      end

    end

  end

end

