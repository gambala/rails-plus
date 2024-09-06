require 'sprockets'

namespace :assets do
  desc 'Compile CSS assets to /dist/'
  task :compile do
    env = Sprockets::Environment.new
    env.append_path 'app/assets/stylesheets'
    env.append_path 'node_modules'

    # Ensure the dist directory exists
    FileUtils.mkdir_p('dist')

    assets_to_compile = {
      'rails-plus/application.css' => 'rails-plus.css',
      'rails-plus-active-admin/application.css' => 'rails-plus-active-admin.css'
    }

    assets_to_compile.each do |source, target|
      # Load the asset
      asset = env[source]

      # Write the compiled asset to the dist directory
      File.open("dist/#{target}", 'wb') do |file|
        file.write(asset.to_s)
      end

      puts "Compiled #{source} to dist/#{target}"
    end
  end
end
