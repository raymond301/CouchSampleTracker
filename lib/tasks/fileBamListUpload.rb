require 'pp'

### Usage: ruby autoRsyncRCF.rb -u <me> -p <my secret> -c <PI_lan_id> -f </NN-primsec>
#### Help Statement ####
if ARGV[0]=='-h' || ARGV[0]=='--help'
  usageStr="Usage: ruby  This script will parse and upload BAMLIST file.\n\n"
  usageStr+="\t-i <file.list> [required]\n"
  puts usageStr+"\n"
  exit 0
end
opt = Hash[*ARGV]


#### Check Input Params ####
if !opt.has_key?('-i')
  puts "Missing BAMLIST File!"
  exit 1
end
dbFile=opt['-i']



urlPrefix="ftp://rcfisinl1-212"
output = File.open("BAMLIST.unmapped.txt","w")

File.readlines(dbFile).each_with_index do |ln, idx|
  ln.chomp!
  next if ln =~ /^$/
  next if ln =~ /^#/

  nom = File.basename(ln)
  nom.sub!(/\.igv-sorted\.bam$/, '')

  newAliaseName = nil

  ally=SampleAliase.where(:name => nom)
  if ally.empty?
    newAliaseName = nom
    nom.sub!(/^s_/, '')
    ally=SampleAliase.where(:name => nom)
  end


  if ally.empty?
    output.puts ln
    next
  end

  ally.map{|m| m.sample_id}.uniq.each do |sid|
    s=Sample.find(sid)
    if !newAliaseName.nil?
      SampleAliase.create({sample:s,name:newAliaseName,typeCast:"VcfIdFromBic" })
    end
    FileLocation.create(sample:s,typeCast:'Source Bam',location:"#{urlPrefix}/#{ln}")
  end



#  break if idx > 80

end