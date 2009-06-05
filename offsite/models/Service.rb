class Service
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :regex, String
  property :created_at, DateTime, :default => lambda { DateTime.now }
end
