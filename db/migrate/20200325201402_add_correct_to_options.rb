class AddCorrectToOptions < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :correct, :boolean
  end
end
