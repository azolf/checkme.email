class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.string :email, null: false
      t.boolean :is_valid
      t.json :validation_result

      t.timestamps
    end

    add_index :emails, :email, :unique => true
  end
end
