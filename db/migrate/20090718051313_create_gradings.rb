class CreateGradings < ActiveRecord::Migration
  def self.up
    create_table :gradings do |t|
      t.string     :name
      t.integer    :min_score
      t.timestamps
    end
    create_default_gradings
  end

  def self.down
    drop_table :gradings
  end

  def self.create_default_gradings
    [["A+", 90], ["A", 80], ["B+", 70], ["B", 60], ["C", 45], ["D", 33],
     ["Fail", 0] ].each { |g| Grading.create(:name => g[0], :min_score => g[1]) }
  end
end
