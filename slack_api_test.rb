require 'httparty'
require 'dotenv'
Dotenv.load

URL = "https://slack.com/api/conversations.list"
SLACK_TOKEN = ENV['SLACK_TOKEN']

query = {token: SLACK_TOKEN}

response = HTTParty.get(URL, query: query)
p response