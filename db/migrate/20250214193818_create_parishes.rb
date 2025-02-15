class CreateParishes < ActiveRecord::Migration[8.0]
  def change
    create_table :parishes do |t|
      t.string :name

      t.timestamps
    end
  end
end
