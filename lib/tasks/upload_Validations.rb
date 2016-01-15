require 'pp'

### Usage: ruby autoRsyncRCF.rb -u <me> -p <my secret> -c <PI_lan_id> -f </NN-primsec>
#### Help Statement ####
if ARGV[0]=='-h' || ARGV[0]=='--help'
  usageStr="Usage: ruby  This script will parse and upload your New Couch RedCap file.\n\n"
  usageStr+="\t-d <redcap file new db .csv> [required]\n"
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







@header = Array.new
def hDx (str)
  return @header.index(str)
end


if File.exist?(dbFile)
  puts "Starting..."
  File.readlines(dbFile).each_with_index do |ln, idx|
    #puts idx
    next if ln =~ /^$/

    rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
    if idx == 0
      @header = rr
      next
    end

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end