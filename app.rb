Bundler.require
Dotenv.load

enable :sessions
set :session_secret, ENV['SESSION_SECRET']

before do
  @client = OAuth2::Client.new(
    ENV['APPLICATION_ID'],
    ENV['APP_SECRET_KEY'],
    site: ENV['MISOCA_END_POINT'],
    authorize_url: ENV['MISOCA_AUTHORIZE_URI'],
    token_url: ENV['MISOCA_TOKEN_URI'],
  )

  if session[:token]
    @access_token = OAuth2::AccessToken.new(@client, session[:token])
  end
end

get '/' do
  if session[:token]
   result = @access_token.get('/api/v1/invoices/?limit=10')
   @invoices = JSON.parse(result.body)
   slim :'invoices/index'
  else
    slim :login
  end
end

get '/auth' do
  authorize_url = @client.auth_code.authorize_url(redirect_uri: redirect_uri, scope: 'read')
  redirect authorize_url
end

get '/callback' do
  access_token = @client.auth_code.get_token(
    params[:code],
    redirect_uri: redirect_uri
  )
  session[:token] = access_token.token
  redirect '/'
end

get '/logout' do
  session[:token] = nil
  redirect '/'
end

get '/invoice/:id/pdf' do
  result = @access_token.get('/api/v1/invoice/%d/pdf' % params[:id])
  pdf = Base64.decode64(JSON.parse(result.body)['pdf'])

  content_type 'application/pdf'
  pdf
end

def redirect_uri
  #TODO: 環境変数などからいい感じにURLを組み立てる
  'http://localhost:9393/callback'
end

