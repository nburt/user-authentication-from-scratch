require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @database = Sequel.connect(ENV['DATABASE_URL'])
    @users_table = @database[:users]
  end

  get '/' do
    if session[:user_id].nil?
      erb :index, locals: {:email => nil}
    else
      email = @users_table[:id => session[:user_id]][:email]
      erb :index, locals: {:email => email}
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    user_password = BCrypt::Password.create(params[:password])
    id = @users_table.insert(:email => params[:email], :password => user_password)
    session[:user_id] = id
    redirect '/'
  end
end
