require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do

  before do
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
end

