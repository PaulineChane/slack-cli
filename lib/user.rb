require_relative 'recipient'
require 'dotenv'
require 'table_print'
# require 'slack_api_error'

Dotenv.load

class User < Recipient

  attr_reader :real_name, :status_text, :status_emoji

  def initialize(slack_id:, name:, real_name:, status_text: '', status_emoji: '')
    super(slack_id: slack_id,name: name)
    @real_name = real_name
    @status_text = status_text
    @status_emoji = status_emoji
  end

  # reader methods
  def details
    tp self, :slack_id, :name, :real_name, :status_text, :status_emoji
  end

  # class methods
  def self.list_all
    url = 'https://slack.com/api/users.list'
    param = {token: ENV['SLACK_TOKEN']}
    raw_users = User.get(url, param)['members']
    all_users = raw_users.map do |member|
      User.new(slack_id: member['id'],
               name: member['name'],
               real_name: member['real_name'],
               status_text: member['status_text'],
               status_emoji: member['status_emoji'])
    end
    return all_users
  end
end