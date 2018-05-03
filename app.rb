require_relative 'auth.rb'
include Auth 
require 'session'

class App < Sinatra::Base

	enable :sessions

	get '/' do
		slim(:login)
	end

	get '/create_notes' do
		slim(:create_notes)
	end

	post '/login' do
		username = params[:username]
		password = params[:password]
		id = login_user(username, password, open_database())
		session[:id] = id
		if id == -1 
			return redirect('/') 
		else
			return redirect('/homepage')
		end
	end

	get '/register' do
		slim(:register)
	end

	post '/register' do
		username = params[:username].strip
		password = params[:password]
		password_confirm = params[:password_confirm]
		puts "Password: #{password}, confirm: #{password_confirm}"

		if password != password_confirm 
			puts "Passwords don't match!"
			return redirect('/register')
		end

		db = open_database()
		user = get_user_by_username(username, db)
		if user != nil
			puts "User with username '#{username}' already exists!"
			return redirect('/register')
		end
		register_user(username, password, db)
		return redirect('/')
	end

	get '/homepage' do
		if (session[:user_id])
			db = open_database()
			result = get_result(db) 
			slim(:homepage, locals:{notes:result})
		else
			redirect('/homepage')
		end
	end

	post '/create_notes' do
		if session[:user_id]
			db = open_database()
			content = params["content"]
			note = create_note(db, content,session[:id])
			redirect('/homepage')
		else
			return redirect('/homepage') 
		end
	end

	get '/logout' do
		logout_user()
		return redirect('/') 
	end

	post '/delete_notes' do
		if session[:user_id]
			note_id = params[:id]
			db = open_database()
			db.to_s 
			note_result = get_result(db)
		end
	end
end           
