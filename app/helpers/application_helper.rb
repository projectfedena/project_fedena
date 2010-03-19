# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_stylesheets
    stylesheets = [] unless stylesheets
    ["#{controller.controller_path}/#{controller.action_name}"].each do |ss|
      stylesheets << ss
    end
  end
end
