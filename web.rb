require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'sinatra/config_file'

config_file 'config.yml'

get '/' do
  erb :index
end

post 'send-sms' do
  client = Twilio::REST::Client.new settings.account_sid, settings.auth_token

  client.account.sms.messages.create(
      :from => settings.twilio_number,
      :to => settings.my_number,
      :body => params[:body]
  )
end

post 'send-voice' do
  client = Twilio::REST::Client.new settings.account_sid, settings.auth_token

  client.account.calls.create(
      :from => settings.twilio_number,
      :to => settings.my_number,
      :url => 'voice-message'
  )
end

get 'dynamic-voice-message' do
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello! Thanks for calling the Madison Tech Start app.'
  end.text
end

get '/sms-response' do
  Twilio::TwiML::Response.new do |r|
    r.Message "Thanks for the message! You said #{params[:body]}."
  end.text
end

get '/voice-response' do
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello! Thanks for calling the Madison Tech Start app.'
  end.text
end

