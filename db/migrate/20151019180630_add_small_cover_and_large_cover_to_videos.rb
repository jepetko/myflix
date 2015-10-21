class AddSmallCoverAndLargeCoverToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :avatar
    remove_column :videos, :img
  end
end
