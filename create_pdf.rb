require "prawn"
class To_pdf
  def self.write(paragraph)
      return :text => paragraph, :leading => 20
    end

  def self.tarea_escrita(document)
    name = document[:name]
    teacher = document[:teacher]
    due_date = document[:due_date]
    class_number = document[:class_number]
    filename = document[:filename]
  
    paragraph1 = document[:para1]
    paragraph2 = document[:para2] 
    paragraph3 = document[:para3]
    paragraph4 = document[:para4]



   header = [name, teacher, class_number, due_date] 
         

  
  tab = "#{Prawn::Text::NBSP}"*10
  pdf = Prawn::Document.new(:margin => 72) do |pdf|
   # default_leading 20


    header.each do |info|
      pdf.text info, :leading => 20
    end

    pdf.text filename, :align => :center, :leading => 20

    #Paragraph 1 
    pdf.text paragraph1, :leading => 20 

    
    #Paragraph 2, with title
    pdf.text "Elementos de la ciudad:", :align => :center, :leading => 20   

    paragraph2.split(/\n/).each do |item|
      pdf.text tab + "- " + item, :leading => 20
    end


    #Paragraph 3, with title
    pdf.text "Elementos del poder:", :align => :center, :leading => 20
    paragraph3.split(/\n/).each do |item|
      pdf.text tab + "- " + item, :leading => 20
    end


    #Paragraph 4
    pdf.text paragraph4, :leading => 20, :size => 12
  end
  
  rendered_pdf = pdf.render_file(filename + ".pdf")
        
  return rendered_pdf
  end
end
