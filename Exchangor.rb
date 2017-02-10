require 'net/http'
require 'json'
require 'sendgrid-ruby'

threshold = ARGV[0]
CURRENCY = ARGV[1]
receiver = ARGV[2]
CURRENCY_API_SECRET = ARGV[3]
SENDGRID_API_SECRET = ARGV[4]

from_email = 'Exchangor@exchangor_utility.com'
url = "http://apilayer.net/api/live?access_key=#{CURRENCY_API_SECRET}&currencies=#{CURRENCY}&format=1";

uri = URI(url)
response = Net::HTTP.get(uri)
json = JSON.parse(response)

if(json['success'] && json['quotes'][CURRENCY.delete(',')]>=threshold.to_f)
  message = "Exchange rates above #{json['quotes'][CURRENCY.delete(',')]}. Consider transferring money now.";
  subject = "Favourable Exchange Rates !!";
elsif(!json['success'])
  message = "There is some issue with the Exchangor API. Please look into it";
  subject = "Issue with the Exchangor API";
end

include SendGrid

unless message.nil? && message.empty?
  from = Email.new(email: from_email)
  to = Email.new(email: receiver)
  content = Content.new(type: 'text/plain', value: message)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: SENDGRID_API_SECRET)
  response = sg.client.mail._('send').post(request_body: mail.to_json)
end



