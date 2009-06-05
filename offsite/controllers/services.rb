get '/services' do
  @services = Service.all
  haml :services
end

get '/newservice' do
  haml :newservice
end

post '/addservice' do
  service = Service.new
  service.name = params[:name]
  service.regex = params[:regex]
  service.save
  redirect '/services'
end
