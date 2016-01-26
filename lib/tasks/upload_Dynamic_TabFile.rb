require 'pp'

### Usage: ruby autoRsyncRCF.rb -u <me> -p <my secret> -c <PI_lan_id> -f </NN-primsec>
#### Help Statement ####
if ARGV[0]=='-h' || ARGV[0]=='--help'
  usageStr="Usage: ruby  This script will parse and upload your file.\n"
  usageStr+="Format of file: 2 header rows. Line 1 = db Object Name & Line 2 = Object Attribute.\n\n"
  usageStr+="Format of file: First Column is always a sample name look up. Will return message if sample not found.\n\n"
  usageStr+="\t-d <formatted file .tsv> [required]\n"
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


File.readlines(dbFile).each_with_index do |ln, idx|
  #puts idx
  next if ln =~ /^$/

  rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
  if idx == 0
    @header = rr
    next
  end

  sampArr = Array.new
  missingAlias = Array.new
  for i in 1..6
    if ! rr[i].empty?
      ally=SampleAliase.where(:name => rr[i]).first
      if ally.nil?
        missingAlias[i] = true
      elsif rr[i] =~ /^Mayo_TN_CC_/
        missingAlias[i] = true
        sampArr[i] = nil
      else
        missingAlias[i] = false
        sampArr[i] = ally.sample.id
      end
    else
      missingAlias[i] = false
    end
  end

  sampList = sampArr.uniq.compact
  if sampList.length > 1
    logger.info "MULTIPLE SAMPLES ON 1 ROW ISSUE!!!!"
    logger.info [idx, sampArr]
    logger.info [SampleAliase.where(:name => rr[1]).first, SampleAliase.where(:name => rr[3]).first]
    next
  end




