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

