class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :transcript
      t.string :file
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
