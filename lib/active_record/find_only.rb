unless defined?(Arel)
  raise 'activerecord-find_only has to be required after ActiveRecord/Arel'
end

unless defined?(ActiveRecord)
  raise 'activerecord-find_only has to be required after ActiveRecord'
end

require "active_record"
require "active_record/find_only/version"

module ActiveRecord
  module FindOnly
    class TooManyRecords < ActiveRecord::ActiveRecordError
    end

    # Gives the only record that matches the criteria.
    # If no record matches the criteria, nil is returned.
    # If more than one record matches the criteria, TooManyRecords is raised.
    def find_only
      found_records = take(2)
      if found_records.length > 1
        raise TooManyRecords
      end
      found_records[0]
    end

    # Gives the only record that matches the criteria.
    # If no record matches the criteria, RecordNotFound is raised.
    # If more than one record matches the criteria, TooManyRecords is raised.
    def find_only!
      find_only || raise_record_not_found_exception!
    end
  end

  Relation.class_eval do
    include FindOnly
  end

  Querying.class_eval do
    delegate :find_only, :find_only!, to: :all
  end

  Associations::CollectionProxy.class_eval do
    def find_only
      if loaded?
        if records.length > 1
          raise ActiveRecord::FindOnly::TooManyRecords
        end
        records[0]
      else
        super
      end
    end
  end

end
