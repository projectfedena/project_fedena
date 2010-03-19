class CreateNewsComments < ActiveRecord::Migration
  def self.up
    create_table :news_comments do |t|
      t.text :content
      t.references :news
      t.references :author
      t.timestamps
    end
  end

  def self.down
    drop_table :news_comments
  end
end
