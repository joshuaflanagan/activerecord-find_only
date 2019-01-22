require "active_record"
require "active_record/only/version"

module ActiveRecord
  module Only
    class TooManyRecords < ActiveRecord::ActiveRecordError
    end

    # Gives the only record that matches the criteria.
    # If no record matches the criteria, nil is returned.
    # If more than one record matches the criteria, TooManyRecords is raised.
    def only
      found_records = take(2)
      if found_records.length > 1
        raise TooManyRecords
      end
      found_records[0]
    end

    # Gives the only record that matches the criteria.
    # If no record matches the criteria, RecordNotFound is raised.
    # If more than one record matches the criteria, TooManyRecords is raised.
    def only!
      only || raise_record_not_found_exception!
    end
  end

  Relation.class_eval do
    include Only
  end

  Querying.class_eval do
    delegate :only, :only!, to: :all
  end

  Associations::CollectionProxy.class_eval do
    def only
      if loaded?
        if records.length > 1
          raise ActiveRecord::Only::TooManyRecords
        end
        records[0]
      else
        super
      end
    end
  end

end
