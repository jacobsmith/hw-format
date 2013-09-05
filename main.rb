require 'sinatra'
require 'data_mapper'
require 'bcrypt'
require "./database_models.rb"
require "./create_pdf.rb"


include ERB::Util
set :sessions, true
set :session_secret, "you'll never guess this!"
set :session_expire_after,  2592000 

helpers do
    
  def login?
    if session[:username].nil?
      return false
    else
      return true
    end
  end
      
  def username
    return session[:username]
  end
        
end

before do
#  puts "This is the session: " + session.inspect.to_s
#  user = User.all
#  puts user.inspect.to_s
end


def link_to(text, url)
  "<a href='#{url}' >#{text}</a>"
end


get '/' do
  link_to('Tarea Escrita', "/form")  
end


get '/form' do
  erb :tarea_escrita_new
end


get '/all' do
  @documents = Tarea_Escrita.all
  erb :user_all 
end


post '/form' do

  ##add each param to database
  p = params
  @document = Tarea_Escrita.create(
    :name => p["username"],
    :teacher => p["teacher"],
    :due_date => p["due_date"],
    :class_number => p["class_number"],
    :filename => p["filename"],
    :para1 => p["para1"],
    :para2 => p["para2"],
    :para3 => p["para3"],
    :para4 => p["para4"],
    :created_at => Time.now
  )
  @document.save

  redirect '/all'
end


get '/edit/:id' do
  erb :tarea_escrita_edit
end


post '/edit/:id' do
  puts params[:id]
  entry = Tarea_Escrita.get(params[:id])


  p = params
  entry.update(
    :name => p["username"],
    :teacher => p["teacher"],
    :due_date => p["due_date"],
    :class_number => p["class_number"],
    :filename => p["filename"],
    :para1 => p["para1"],
    :para2 => p["para2"],
    :para3 => p["para3"],
    :para4 => p["para4"],
    :last_save => Time.now
  )

redirect '/all'

end



get '/print/:id' do
  document = Tarea_Escrita.get(params[:id])

  puts "This is document from print id: " + document.inspect.to_s
  puts document[:name]

  pdf = To_pdf.tarea_escrita(document)


  File.open(pdf, "rb") do |file|
    send_file(file, :disposition => 'attachment', :filename => document[:filename] + ".pdf")
  end

end


get '/signup' do
  erb :signup
end

post "/signup" do
  #Authentication inspired by: http://128bitstudios.com/2011/11/21/authentication-with-sinatra/ 
  p = params
#  flash[:notice] = "Passwords do not match--please double check."
  puts p
  if p["password"] != p["password_confirmation"]
   puts 'passwords don\'t match'
  else 
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(p["password"], password_salt)
 
    @user = User.new(
     :email => p["email"],
     :real_name => p["real_name"],
     :password_salt => password_salt,
     :password_hash => password_hash
     )
     puts @user.valid?.to_s + ' is user valid?'
    @user.save!

   session[:username] = p["username"]
   redirect "/all"
  end
end

get "/login" do
  erb :login
end

post "/login" do
  puts params
 if User.first(:email => params[:email])
   user = User.first(:email => [params[:email]])
   puts user.inspect.to_s
   if user[:password_hash] == BCrypt::Engine.hash_secret(params[:password], user[:password_salt])     
     session[:username] = user[:email] 
     redirect "/all"
   end
 else
   puts "didn't log in"
   redirect "/logout"
 end 
end



get "/logout" do
 session[:username] = nil
 session.clear
   redirect "/"
end

get "/session" do
#  session[:time] = Time.now 
  erb :check_session
end

