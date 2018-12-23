require "bundler/setup"
require "active_record/only"

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
