require_relative 'user'
# an excessive but object oriented solution
class Bot < User
  attr_reader :slack_id, :name, :real_name, :time_zone, :is_bot, :send_as, :emoji
  def initialize(slack_id: , name:, real_name:, time_zone: ,is_bot: , send_as: '', emoji: '')
    super(slack_id: slack_id,
          name: name,
          real_name: real_name,
          time_zone: time_zone,
          is_bot: is_bot)
    @send_as = send_as
    @emoji = emoji
  end

  def self.current_bot
    users = User.list_all
    url = 'https://slack.com/api/auth.test'
    query = {token: Bot.token}
    sleep(0.5)
    response = HTTParty.get(url, query: query)['user_id']
    user = users.find{ |user| user.slack_id == response}
    return Bot.new(slack_id: user.slack_id,
                   name: user.name,
                   real_name: user.real_name,
                   time_zone: user.time_zone,
                   is_bot: user.is_bot)
  end

  def set_emoji(emoji)
    # regex checks for correct emoji format:
    # (:EMOJI:, EMOJI, alphanumeric and dashes only (can also have exactly TWO colons on either side))
    raise ArgumentError, "invalid emoji" unless /^(:[a-zA-Z0-9_]+:)/ =~ emoji || /^([a-zA-Z0-9_]+)/ =~ emoji
    @emoji = emoji
    return emoji
  end

  def set_send_as (username)
    @send_as = username
    return username
  end

  def self.list_all
    bots = super
    bots = bots.filter{ |user| user.is_bot || user.slack_id == "USLACKBOT"}
    return bots
  end
end