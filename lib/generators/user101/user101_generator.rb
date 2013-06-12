class User101Generator < Rails::Generators::Base
	source_root File.expand_path('../templates', __FILE__)

	def generateHelper
		copy_file "app/helpers/sessions_helper.rb",  "app/helpers/sessions_helper.rb"
	end
	
	def generateControllers
		copy_file "app/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
		copy_file "app/controllers/users_controller.rb", "app/controllers/users_controller.rb"
	end		
	
	def generateMigration
		copy_file "db/migrate/migration.rb", "db/migrate/#{migrationNumber}_create_users.rb"
	end

	def generateModel
		copy_file "app/models/user.rb", "app/models/user.rb"
	end

	def generateViews
		empty_directory File.join("app/views", "users")
		copy_file "app/views/users/new.html.erb", "app/views/users/new.html.erb"
		copy_file "app/views/users/show.html.erb", "app/views/users/show.html.erb"
		copy_file "app/views/users/_registration_form.html.erb", "app/views/users/_registration_form.html.erb"
		
		empty_directory File.join("app/views", "sessions")
		copy_file "app/views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
		copy_file "app/views/sessions/_login_form.html.erb", "app/views/sessions/_login_form.html.erb"

		empty_directory File.join("app/views", "shared")
		copy_file "app/views/shared/_error_messages.html.erb", "app/views/shared/_error_messages.html.erb"
	end

	def generateStylesheet
		copy_file "app/assets/stylesheets/user101.css.scss", "app/assets/stylesheets/user101.css.scss"
	end
	
	def includeSessionHelperIntoApplicationController
		file_content = File.read('app/controllers/application_controller.rb')
		file_content.sub!("protect_from_forgery\n", "protect_from_forgery\n  include SessionsHelper\n")
		File.open("app/controllers/application_controller.rb", 'w') { |file| file.write(file_content)}	
		say_status "insert", "ApplicationController file -> 'include SessionsHelper'", :blue
	end

	def addRoutes
		routes = "  resources :users, only: [:new, :create, :show]\n" +
			 "  resources :sessions, only: [:new, :create, :destroy]\n" +
			 "  match '/signup',  to: 'users#new'\n" +  
			 "  match '/signin',  to: 'sessions#new'\n" +
			 "  match '/signout', to: 'sessions#destroy', via: :delete"

		file_content = File.read('config/routes.rb')
		file_content.sub!("routes.draw do\n", "routes.draw do\n#{routes}")
		File.open("config/routes.rb", 'w') { |file| file.write(file_content)}	
		say_status "insert", "routes.rb file -> 'resources :users'", :blue
	end

	private

	def migrationNumber
		(Time.now.utc.strftime("%Y%m%d%H%M%S").to_i + 1).to_s
	end

end
