class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.references :user, foreign_key: true, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false, default: ""
      t.integer :transgender, null: false, default: 0
      t.integer :gender, null: false, default: 0
      t.integer :race, null: false, default: 0
      t.datetime :birthday, null: false
      t.integer :disabled, null: false, default: 0
      t.integer :sexuality, null: false, default: 0
      t.string :pronouns, null: false, default: ""

      t.timestamps
    end

    add_index :user_details, :transgender
    add_index :user_details, :gender
    add_index :user_details, :race
    add_index :user_details, :disabled
    add_index :user_details, :sexuality
  end
end
