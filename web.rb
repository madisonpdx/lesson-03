require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'sinatra/config_file'

config_file 'config.yml'

get '/' do
  erb :index
end

post '/send-sms' do
  client = Twilio::REST::Client.new settings.account_sid, settings.auth_token

  client.account.sms.messages.create(
      :from => settings.twilio_number,
      :to => settings.my_number,
      :body => params[:sms_body]
  )

  redirect '/'
end

post '/send-voice' do
  @@voice_body = params[:voice_body]

  client = Twilio::REST::Client.new settings.account_sid, settings.auth_token

  client.account.calls.create(
      :from => settings.twilio_number,
      :to => settings.my_number,
      :url => 'http://fierce-wildwood-5399.herokuapp.com/dynamic-voice-message'
  )

  redirect '/'
end

post '/dynamic-voice-message' do
  Twilio::TwiML::Response.new do |r|
    r.Say @@voice_body
  end.text
end

get '/sms-response' do
  Twilio::TwiML::Response.new do |r|
    r.Message "Hello. Thanks for the message! You said '#{params['Body']}'."
  end.text
end

get '/voice-response' do
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello. Thanks for calling the Madison Tech Start app! Goodbye.'
  end.text
end

