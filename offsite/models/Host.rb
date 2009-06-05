class Host 
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :ip, String
  property :uptime, Integer
  property :created_at, DateTime, :default => lambda { DateTime.now }
end
