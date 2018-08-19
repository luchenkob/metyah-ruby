class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.string :timezone
      t.decimal :tax_rate, :precision => 6, :scale => 5
      t.string :currency
      t.string :date_format
      t.string :time_format

      t.timestamps
    end
  end
end
