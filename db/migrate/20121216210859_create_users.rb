class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
