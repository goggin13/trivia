class ChangeDefaultOfCorrectOnOptions < ActiveRecord::Migration[6.0]
  def change
    change_column_default :options, :correct, false
  end
end
