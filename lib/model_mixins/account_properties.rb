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

      def == (other)
        if other.respond_to? "id"
          return id == other.id
        else
          return false
        end
      end

    end

  end

end

