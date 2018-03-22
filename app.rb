class App < Sinatra::Base

	enable :sessions

	get '/' do
		slim(:index)
	end

	get '/login' do
		slim(:login)
	end

end           
