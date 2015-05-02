class CreateQueuedVideos < ActiveRecord::Migration
  def change
    create_table :queued_videos do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :order_value
      t.timestamps
    end
  end
end
