require "prawn"
class To_pdf
  def self.write(paragraph)
      return :text => paragraph, :leading => 20
    end
  def self.tarea_escrita(params)
    name = params[:username]
    teacher = params[:teacher]
    due_date = params[:due_date]
    class_number = params[:class_number]
    filename = params[:filename]
  
    paragraph1 = params[:para1]
    paragraph2 = params[:para2] 
    paragraph3 = params[:para3]
    paragraph4 = params[:para4]
 
   header = [name, teacher, class_number, due_date] 
          
  tab = "#{Prawn::Text::NBSP}"*10
  pdf = Prawn::Document.new(:margin => 72)  do |pdf|
    header.each do |info|
      pdf.text info, :leading => 20
    end

    pdf.text filename, :align => :center, :leading => 20

    #Paragraph 1 
    pdf.text paragraph1, :leading => 20

    
    #Paragraph 2, with title
    pdf.text "Elementos de la ciudad:", :align => :center, :leading => 20   

    paragraph2.split(/\n/).each do |item|
      if item.strip =~ /[A-Z]+[ÁÉÍÓÚ]+[A-Z]/
        pdf.text item, :leading => 20
      elsif item == "\r"
       pdf.text item
      else 
        pdf.text tab + "- " + item, :leading => 20
      end

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
