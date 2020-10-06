require_relative 'recipient'
require 'table_print'

class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(slack_id, name, topic, member_count)
    super(slack_id, name)
    @topic = topic
    @member_count = member_count
  end

  def details
    return tp :slack_id, :name, :topic, :member_count
  end

  def self.list_all
    response = HTTParty.get("conversations.list")
    all_channels = response["channels"].map do |channel|
      Channel.new(channel["id"], channel["name"], channel["topic"]["value"], channel["num_members"])
    end
    return all_channels
  end
end
