require 'sinatra'

require "./create_pdf.rb"

get '/' do
	'Hi there (:'
end

get '/form' do
  erb :form
end

post '/form' do


filename = params[:filename]

	pdf = To_pdf.tarea_escrita(params)

	File.open(pdf, "rb") do |file|
	  send_file(file, :disposition => 'attachment', :filename => filename + ".pdf")
	end


end

