class UsersRepository

  def initialize
    @users_table = DB[:users]
  end

  def create(user_info)
    @users_table.insert(user_info)
  end

  def admin?(id)
    @users_table[:id => id][:administrator]
  end
end