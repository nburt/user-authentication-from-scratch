require 'sinatra/base'
require 'bcrypt'
require './lib/users_repository'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
    @users_repository = UsersRepository.new
  end

  get '/' do
    if session[:user_id].nil?
      erb :index, locals: {:email => nil, :user_id => nil}
    else
      email = @users_table[:id => session[:user_id]][:email]
      admin = @users_table[:id => session[:user_id]][:administrator]
      erb :index, locals: {:email => email, :user_id => session[:user_id], :admin => admin}
    end
  end

  get '/register' do
    erb :register, :locals => {:error_message => nil}
  end

  post '/register' do
    if @users_table[:email => params[:email]].nil?
      user_password = BCrypt::Password.create(params[:password])
      session[:user_id] = @users_table.insert(:email => params[:email], :password => user_password)
      redirect '/'
    else
      erb :register, :locals => {:error_message => "That email address already exists"}
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    erb :login, locals: {:error_exists => false, :error_message => nil}
  end

  post '/login' do
    user_email = @users_table[:email => params[:email]]
    if user_email.nil? || BCrypt::Password.new(user_email[:password]) != params[:password]
      erb :login, locals: {:error_message => "Invalid email or password"}
    else
      session[:user_id] = user_email[:id]
      redirect '/'
    end
  end

  get '/users' do
    users = @users_repository.get_users(session[:user_id])
    admin_email = @users_repository.get_user_email(session[:user_id])
    erb :users, :locals => {:users => users, :admin_email => admin_email}
  end
end
