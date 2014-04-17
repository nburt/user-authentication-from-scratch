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

  def get_users(id)
    if @users_table[:id => id][:administrator]
      @users_table.select(:id, :email).to_a
    else
      "You do not have access to this page"
    end
  end

  def get_user_email(id)
    if @users_table[:id => id][:administrator]
      @users_table[:id => id][:email]
    else
      "You do not have sufficient privileges"
    end
  end
end