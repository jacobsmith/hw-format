

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
  property :username, String
  property :real_name, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

