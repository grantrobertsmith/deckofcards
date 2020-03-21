class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
