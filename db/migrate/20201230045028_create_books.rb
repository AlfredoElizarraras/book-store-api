class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :category
      t.integer :progress
      t.string :author
      t.string :progress_measure
      t.string :progress_measure_value
      t.integer :max_progress_value
      t.integer :current_progress_value

      t.timestamps
    end
  end
end
