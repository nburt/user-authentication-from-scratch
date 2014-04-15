require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
  end

  get '/' do
    if session[:user_id].nil?
      erb :index, locals: {:email => nil, :user_id => nil}
    else
      email = @users_table[:id => session[:user_id]][:email]
      erb :index, locals: {:email => email, :user_id => session[:user_id]}
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    user_password = BCrypt::Password.create(params[:password])
    session[:user_id] = @users_table.insert(:email => params[:email], :password => user_password)
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    erb :login, locals: {:error_exists => false, :error_message => nil}
  end

  post '/login' do

    if @users_table[:email => params[:email]] != nil
      user_password = BCrypt::Password.new(@users_table[:email => params[:email]][:password])
      if user_password == params[:password]
        session[:user_id] = @users_table[:email => params[:email]][:id]
        redirect '/'
      else
        erb :login, locals: {:error_exists => true, :error_message => "Invalid email or password"}
      end
    else
      erb :login, locals: {:error_exists => true, :error_message => "Invalid email or password"}
    end
  end
end
