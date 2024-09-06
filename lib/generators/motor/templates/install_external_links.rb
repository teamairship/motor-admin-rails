class <%= migration_class_name %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def self.up
    create_table :motor_external_links do |t|
      t.column :name, :string, null: false
      t.column :url, :string, null: false
      t.column :relative, :boolean, null: false, default: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :preferences, :text, null: false
      t.column :deleted_at, :datetime

      t.timestamps
    end
  end

  def self.down
    drop_table :motor_external_links
  end
end
