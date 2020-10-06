
class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(slack_id, name)
    super(slack_id, name)
  end
end