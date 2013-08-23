require "prawn"

def to_pdf(params)

paragraph2 = params[:para2] 
tab = "#{Prawn::Text::NBSP}"*10

Prawn::Document.generate("hello.pdf") do
  text string, :leading => 20, :size => 12
 
  paragraph2.each do |item|
    text tab + "- " + item, :leading => 20, :size => 12
  end
end
