class Discuss::ViewsGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../app/views', __FILE__)
  desc 'Copy discuss views to application'

  def views
    directory('discuss', 'app/views/discuss')
  end
end
