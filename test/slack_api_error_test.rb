require_relative 'test_helper'

describe SlackApiError do
  it 'creates a custom SlackApiError that inherits from StandardError' do
    error = SlackApiError.new
    expect(error).must_be_instance_of SlackApiError
    expect(error).must_be_kind_of StandardError
  end
end