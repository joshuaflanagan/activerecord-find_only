require "bundler/setup"
require "active_record/find_only"

ActiveRecord::Base.establish_connection(adapter: :sqlite3, database: ":memory:")

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    rebuild_db
  end

end

def rebuild_db

  ActiveRecord::Base.connection.create_table :builds, force: true do |table|
    table.column :name, :string
    table.column :widget_id, :integer
  end

  ActiveRecord::Base.connection.create_table :widgets, force: true do |table|
    table.column :name, :string
    table.column :active, :boolean
  end

end

def check_db_access
  db_access = false
  on_query = ->(*args){ db_access = true}
  ActiveSupport::Notifications.subscribed(on_query, "sql.active_record") do
    yield
  end
  db_access
end
