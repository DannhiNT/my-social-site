class AddStatusToFollows < ActiveRecord::Migration[8.0]
  def change
    add_column :follows, :status, :string
  end
end
