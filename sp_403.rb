require 'sinatra'
require 'data_mapper'
require "./database_models.rb"
require "./create_pdf.rb"
include ERB::Util

before do
    puts '[Params]'
      p =  params
      p.each do |i| print i  end
      p.class

      puts 'Database: ' + Tarea_Escrita.all.inspect
end
#setup database

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

##add each param to database, if not exist, add new column
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

filename = params[:filename]

	pdf = To_pdf.tarea_escrita(params)

	File.open(pdf, "rb") do |file|
	  send_file(file, :disposition => 'attachment', :filename => filename + ".pdf")
	end


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

  params = p
  pdf = To_pdf.tarea_escrita(params)

  File.open(pdf, "rb") do |file|
    send_file(file, :disposition => 'attachment', :filename => params["filename"] + ".pdf")
  end

redirect '/all'

end



get '/print/:id' do
  document = Tarea_Escrita.get(params[:id])


  pdf = To_pdf.tarea_escrita(document)


  File.open(pdf, "rb") do |file|
    send_file(file, :disposition => 'attachment', :filename => params["filename"] + ".pdf")
  end

end
