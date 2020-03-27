class AddUsernameToUsers < ActiveRecord::Migration[6.0]
  def change
    UserAnswers.destroy_all
    User.destroy_all
    add_column :users, :username, :text
    change_column :users, :email, :string, :null => true
    remove_index :users, :email
  end
end
