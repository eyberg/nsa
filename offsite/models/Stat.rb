class Stat
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :fullname, String
  property :pid, Integer
  property :cpu, Float
  property :mem, Float
  property :created_at, DateTime, :default => lambda { DateTime.now }
end
