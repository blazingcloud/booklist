class DefaultBookDescription < ActiveRecord::Migration
  def self.up
    change_column :books, :description, :string, :null => false, :default => ""
  end

  def self.down
  end
end
