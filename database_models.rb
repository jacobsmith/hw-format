

DataMapper.setup(:default,  "sqlite3:development.db")
  
class Document
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, String
  property :teacher, String
  property :due_date, String
  property :class_number, String
  property :filename, String, :unique => true
  property :last_save, DateTime
  property :created_at, DateTime
#  belongs_to :user
end

class Tarea_Escrita < Document
  property :para1, Text, :lazy => false  
  property :para2, Text, :lazy => false 
  property :para3, Text, :lazy => false 
  property :para4, Text, :lazy => false
end

class User
  include DataMapper::Resource
#  has n, :documents
  property :id, Serial, :key => true 
  property :email, String, :unique => true, :format => :email_address
  property :real_name, String, :required => true
  property :password_salt, String
  property :password_hash, String
end

User.raise_on_save_failure = true 
DataMapper::Logger.new($stdout, :debug)

DataMapper.finalize
DataMapper.auto_upgrade!

