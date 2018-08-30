class CreateProfilePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_photos do |t|
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
