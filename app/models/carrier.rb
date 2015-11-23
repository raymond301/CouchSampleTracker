class Carrier < ActiveRecord::Base
  # require 'spreadsheet' ## does not support .xlsx encoding
  require 'rubyXL'

  def self.create_from_source_manifest(params)
    #raise  params[:manifest].tempfile.path.inspect
    #book = Spreadsheet.open params[:manifest].tempfile.path
    workbook = RubyXL::Parser.parse(params[:manifest].tempfile.path)

    raise book.inspect

  end


  def self.getCurrentNotices
    notes = Array.new
    File.foreach( Rails.root.join('lib/assets/notices.txt') ).with_index do |line, idx|
      line.chomp!
      notes.push( line.split("|") )
    end
    return notes
  end



end
