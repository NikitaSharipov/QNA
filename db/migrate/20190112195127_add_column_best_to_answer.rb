class AddColumnBestToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
