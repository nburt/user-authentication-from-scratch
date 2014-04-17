require 'spec_helper'
require 'capybara/rspec'
require './lib/users_repository'

Capybara.app = Application

feature 'Homepage' do

  before do
    users_table = DB[:users]
    users_table.delete
    users_table.insert(:email => 'abc@abc.com', :password => BCrypt::Password.create('pass'), :administrator => true)
    visit '/'
    click_link 'Register'
    fill_in 'email', :with => 'joe@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Register'
  end

  scenario 'user can register' do
    expect(page).to have_content 'Hello joe@example.com'
  end

  scenario 'user can successfully logout' do
    expect(page).to have_content 'Hello joe@example.com'
    click_link 'Logout'
    expect(page).to_not have_content 'Hello joe@example.com'
    expect(page).to have_content 'Welcome!'
  end

  scenario 'user can sign in with a valid email/password' do
    click_link 'Logout'
    click_link 'Login'
    fill_in 'email', :with => 'joe@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Login'
    expect(page).to have_content 'Hello joe@example.com'
  end

  scenario 'user cannot sign in with an invalid email' do
    click_link 'Logout'
    click_link 'Login'
    fill_in 'email', :with => 'joe-bob-malloy@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Login'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'a user cannot sign in with an invalid password' do
    click_link 'Logout'
    click_link 'Login'
    fill_in 'email', :with => 'joe@example.com'
    fill_in 'password', :with => 'password1'
    click_button 'Login'
    expect(page).to have_content 'Invalid email or password'
    visit '/'
    expect(page).to_not have_content 'Hello joe@example.com'
  end

  scenario 'an admin user can view all of the users' do
    click_link 'Logout'
    click_link 'Login'
    fill_in 'email', :with => 'abc@abc.com'
    fill_in 'password', :with => 'pass'
    click_button 'Login'
    click_link 'View all users'
    within 'h1' do
      expect(page).to have_content 'Users'
    end
    expect(page).to have_content 'joe@example.com'
    expect(page).to have_content 'abc@abc.com'
    expect(page).to have_link 'Home'
    within 'p' do
      expect(page).to have_content 'Welcome, abc@abc.com |'
    end
    expect(page).to have_link 'Logout'
  end

  scenario 'User cannot register with an email address that already exists' do
    click_link 'Logout'
    click_link 'Register'
    fill_in 'email', :with => 'abc@abc.com'
    fill_in 'password', :with => 'pass'
    click_button 'Register'
    expect(page).to have_content 'That email address already exists'
  end

end

