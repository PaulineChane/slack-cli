class Workspace
  attr_reader :users, :channels
  attr_accessor :selected

  def initialize
    @users = []
    @channels = []
    @selected = nil
  end

  def select_channel(channel)

  end

  def select_user(user)

  end

  def send_message

  end

  def show_details

  end
end