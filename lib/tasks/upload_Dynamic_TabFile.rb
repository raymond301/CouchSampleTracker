require 'pp'

accepted_formats = [".txt", ".tsv"]
### Usage: ruby autoRsyncRCF.rb -u <me> -p <my secret> -c <PI_lan_id> -f </NN-primsec>
#### Help Statement ####
if ARGV[0]=='-h' || ARGV[0]=='--help'
  usageStr="Usage: ruby  This script will parse and upload your file.\n"
  usageStr+="Format of file: 2 header rows. Line 1 = db Object Name & Line 2 = Object Attribute.\n\n"
  usageStr+="Format of file: First Column is always a sample name look up. Will return message if sample not found.\n\n"
  usageStr+="\t-d <formatted file .tsv> [required]\n"
  usageStr+="\t-t 1 Flag Denotes Purpose to Track Changes [optional] 1=Yes, 0=No\n"
  puts usageStr+"\n"
  exit 0
end
opt = Hash[*ARGV]


#### Check Input Params ####
if !opt.has_key?('-d')
  puts "Missing RedCap File!"
  exit 1
end
dbFile=opt['-d']

if ! accepted_formats.include? File.extname(dbFile)
  puts "Incorrect File Type: Need tab-deliminated file (.tsv)"
  exit
end

trackUpdates = true
if opt.has_key?('-t')
  trackUpdates = false
end



@ObjectHeader=Array.new
@AttrHeader=Array.new
firstApperanceCheck=true
File.readlines(dbFile).each_with_index do |ln, idx|
  #puts idx
  next if ln =~ /^$/
  ln.chomp!

  rr=ln.split(/\t/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
  if idx == 0
    @ObjectHeader = rr
    ### add check to validate all strings are ligit models
    next
  elsif idx == 1
    @AttrHeader = rr
    next
  end


  ally=SampleAliase.where(:name => rr[0])

  if ally.nil?
    puts "Unable to Find Sample: #{rr[0]}"
    next
  end

  if ally.size > 1
    puts "Found Multiple Sample Matches: #{rr[0]}"
    pp ally
    next
  end

  s=ally.first.sample

  pp [idx, rr[0],ally,s]
  keepSampleObjectPerRow = Hash.new
  ### get single set of objects
  @ObjectHeader.uniq.each do |o|
    if o == 'Sample'
      keepSampleObjectPerRow[o] = s #Sample.find(s.id)
    else
      keepSampleObjectPerRow[o] = o.constantize.where(:sample_id => s.id)
    end
  end

  ### need to check that fields are valid
  if firstApperanceCheck

    firstApperanceCheck=false
  end


  for r in 1..rr.size-1
    puts keepSampleObjectPerRow[@ObjectHeader[r]][@AttrHeader[r]]


    puts rr[r]
  end


   break if idx > 3

end




