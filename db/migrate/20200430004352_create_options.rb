class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.references :poll
      t.text :option_description
      t.integer :voted_times, default: 0
      t.timestamps
    end
  end
end
