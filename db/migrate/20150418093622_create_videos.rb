class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :avatar
      t.string :img
      t.timestamps
    end
  end
end
