require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  scenario 'Shows the welcome message' do
    visit '/'

    expect(page).to have_content 'Welcome!'
  end

  scenario 'user can register' do
    visit '/'
    click_link 'Register'
    fill_in 'email', :with => 'joe@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Register'
    expect(page).to have_content 'Hello joe@example.com'
  end

  scenario 'user can successfully logout' do
    visit '/'
    click_link 'Register'
    fill_in 'email', :with => 'joe@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Register'
    expect(page).to have_content 'Hello joe@example.com'
    click_link 'Logout'
    expect(page).to_not have_content 'Hello joe@example.com'
    expect(page).to have_content 'Welcome!'
  end
end