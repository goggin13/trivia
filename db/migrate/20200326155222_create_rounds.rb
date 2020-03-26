class CreateRounds < ActiveRecord::Migration[6.0]
  def change
    create_table :rounds do |t|
      t.text :label

      t.timestamps
    end
  end
end
