class CreateBases < ActiveRecord::Migration
  def change
    create_table :bases do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
