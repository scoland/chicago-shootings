class AddStoryUrlToVictims < ActiveRecord::Migration
  def change
    add_column :victims, :story_url, :string
  end
end
