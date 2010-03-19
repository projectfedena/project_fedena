class CreateRestrictedPages < ActiveRecord::Migration
  def self.up
    create_table :restricted_pages do |t|
      t.string :controller
      t.string :action
    end
  end

  def self.down
    drop_table :restricted_pages
  end

  PAGES = [
    { :controller => 'attendance', :actions => [] },
    { :controller => 'exam', :actions => [] },
    { :controller => 'examconfig', :actions => [] },
    { :controller => 'student', :actions => [] },
    { :controller => 'subject', :actions => [] },
    { :controller => 'user', :actions => [] },
    { :controller => 'timetable', :actions => [] }
  ]

  def create_defaults
    # TODO: Load the pages to database.
  end

end
