require './spec/spec_helper'
require 'rspec'
require 'users_repository'

describe UsersRepository do
  it 'allows users to be assigned admin role' do
    users = UsersRepository.new
    id = users.create(email: "abc@abc.com", password: "pass")
    expect(users.admin?(id)).to eq false
    id2 = users.create(email: "abc@abc.com", password: "pass", administrator: true)
    expect(users.admin?(id2)).to eq true
  end
end