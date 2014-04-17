require './spec/spec_helper'
require 'rspec'
require 'users_repository'

describe UsersRepository do

  before do
    DB[:users].delete
  end

  it 'allows users to be assigned admin role' do
    users = UsersRepository.new
    id = users.create(:email => "abc@abc.com", :password => "pass")
    expect(users.admin?(id)).to eq false
    id2 = users.create(:email => "abc@abc.com", :password => "pass", :administrator => true)
    expect(users.admin?(id2)).to eq true
  end

  it 'allows an admin to access all the users' do
    users = UsersRepository.new
    id = users.create(:email => "def@abc.com", :password => "pass")
    id2 = users.create(:email => "abc@abc.com", :password => "pass", :administrator => true)
    expect(users.get_users(id2)).to eq [{:id => id, :email => "def@abc.com"}, {:id => id2, :email => "abc@abc.com"}]
  end

  it 'does not allow a non-admin to access all users' do
    users = UsersRepository.new
    id = users.create(:email => "adsf@adf.com", :password => "pass")
    expect(users.get_users(id)).to eq "You do not have access to this page"
  end

  it 'allows you to get a user by id if you are an admin' do
    users = UsersRepository.new
    id = users.create(:email => "def@abc.com", :password => "pass", :administrator => true)
    expect(users.get_user_email(id)).to eq('def@abc.com')
  end

  it 'does not allow your to get a user by id if you are not an admin' do
    users = UsersRepository.new
    id = users.create(:email => "def@abc.com", :password => "pass", :administrator => false)
    expect(users.get_user_email(id)).to eq('You do not have sufficient privileges')
  end
end