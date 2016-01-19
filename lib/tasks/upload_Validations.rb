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
#  puts "Starting..."
  File.readlines(dbFile).each_with_index do |ln, idx|
    next if ln =~ /^$/

    rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
    if idx == 0
      @header = rr
      next
    end

    if rr[hDx('sample_id')] =~ /;/
      rr[hDx('sample_id')] = rr[hDx('sample_id')].split(/;/).first
    end

    ally=SampleAliase.where(:name => rr[hDx('sample_id')] )
    if ally.size == 0
      ally=SampleAliase.where(:name => rr[hDx('sample_id')].gsub!(/^s_/,'') )
    end


    ### Just one sample name, exact match - must be this one
    if ally.size == 1
      mySample = ally.first.sample
    elsif ally.map{|a| a.sample_id}.uniq.compact.size == 1  ## all aliases map back to same sample
      mySample = ally.first.sample
    elsif ally.size == 0
      puts "NO MATCHING SAMPLE [#{rr[hDx('sample_id')]}]"
      puts rr.compact.join(" | ")
      next
    else
      puts "MULTIPLE ALIASES"
      pp ally
      exit
    end

    v = Validation.create(sample: mySample)
    if ! rr[hDx('chr')].empty? then v.chr = rr[hDx('chr')] end
    if ! rr[hDx('pos')].empty? then v.pos = rr[hDx('pos')] end
    if ! rr[hDx('ref')].empty? then v.ref = rr[hDx('ref')] end
    if ! rr[hDx('alt')].empty? then v.alt = rr[hDx('alt')] end
    if ! rr[hDx('hgvs')].empty?
      if rr[hDx('hgvs')] =~ /_p\./
        tmp = rr[hDx('hgvs')].split("_")
        v.hgvs_c = tmp[0]
        v.hgvs_p = tmp[1]
      else
        v.hgvs_c = rr[hDx('hgvs')]
      end
    end

    if ! rr[hDx('gene')].empty? then v.gene = rr[hDx('gene')] end
    if ! rr[hDx('transcript')].empty? then v.transcript = rr[hDx('transcript')] end
    if ! rr[hDx('exon')].empty? then v.exon = rr[hDx('exon')] end
    if ! rr[hDx('primer_f')].empty? then v.primer_forward = rr[hDx('primer_f')] end
    if ! rr[hDx('primer_r')].empty? then v.primer_reverse = rr[hDx('primer_r')] end
    if ! rr[hDx('pcr_size')].empty? then v.pcr_size = rr[hDx('pcr_size')] end
    if ! rr[hDx('ann_temp')].empty? then v.annealing_temp = rr[hDx('ann_temp')] end
    if ! rr[hDx('notes')].empty? then v.notes = rr[hDx('notes')] end
    if rr[hDx('valid')] == "0"
      v.confirmation = false
    else
      v.confirmation = true
    end


    v.save!
    #pp [ally,mySample,v]
    #pp [ally,v]

    #puts "\n\n"
    #break if idx > 3

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end