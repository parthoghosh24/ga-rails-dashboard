class AnalyticsController < ApplicationController



  # you need to set this according to your situation/needs
	SERVICE_ACCOUNT_EMAIL_ADDRESS = '1026062841670-tuml4lff6bh1t48vaj5d1fsn0m3v2u7d@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
	PATH_TO_KEY_FILE              = 'Candeo-3bd4ff909cc2.p12' # the path to the downloaded .p12 key file
	PROFILE                       = 'ga:101815964' # https://analytics.google.com/analytics/web/#home/a62588205w97728447p101815964/	

  def index
  	
  	require 'google/api_client'


	# set up a client instance
	client  = Google::APIClient.new(
  :application_name => 'Candeo',
  :application_version => '0.0.1')

	start_date = DateTime.now.prev_month.strftime("%Y-%m-%d")
	end_date = DateTime.now.strftime("%Y-%m-%d")

	client.authorization = Signet::OAuth2::Client.new(
		:token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
		:audience             => 'https://accounts.google.com/o/oauth2/token',
		:scope                => 'https://www.googleapis.com/auth/analytics.readonly',
		:issuer               => SERVICE_ACCOUNT_EMAIL_ADDRESS,
		:signing_key          => Google::APIClient::PKCS12.load_key(PATH_TO_KEY_FILE, 'notasecret')
	)

	client.authorization.fetch_access_token!

	api_method = client.discovered_api('analytics','v3')	

	api_method= api_method.data.ga.get


	# make queries
	result = client.execute(:api_method => api_method, :parameters => {
	  'ids'        => 'ga:101815964',
	  'start-date' => start_date,
	  'end-date'   => end_date,
	  'metrics'    => 'ga:sessions,ga:users,ga:pageviews',
	  'dimensions' => 'ga:browser,ga:city'
	})

	# puts "Results #{result.data.rows}"
	@rows = result.data.rows
  end
end
