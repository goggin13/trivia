class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.text :title

      t.timestamps
    end

    add_column :rounds, :game_id, :integer, null: true, foreign_key: false

    game = Game.create!(:title => "General Trivia")
    Round.update_all(:game_id => game.id)

    change_column :rounds, :game_id, :integer, null: false, foreign_key: true
  end
end
