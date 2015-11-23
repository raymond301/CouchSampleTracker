require 'pp'

dbFile=Rails.root.join('lib','tasks','CouchLab_OldRedCap2.csv')

#allStudyGroups=SiteOfOrigin.all.group_by(&:study_group).map(&:first)

#    pp allStudyGroups

#exit



@header = Array.new
def hDx (str)
  return @header.index(str)
end


if File.exist?(dbFile)
  File.readlines(dbFile).each_with_index do |ln, idx|
    rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
    if idx == 0
      @header = rr
      next
    end

    ### Skip the Gepar Samples -- I already fixed in newRedCap
    next if rr[7] == "Gepar Quinto"
    next if rr[7] == "BCFR-FCCC"
    next if rr[7] == "BCFR-NYC"


    sampArr = Array.new
    missingAlias = Array.new
    for i in 1..6
      if ! rr[i].empty?
        ally=SampleAliase.where(:name => rr[i]).first
        if ally.nil?
          missingAlias[i] = true
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
      puts "MULTIPLE SAMPLES ON 1 ROW ISSUE!!!!"
      pp [idx, sampArr]
      pp [Sample.find('2830'), Sample.find('2831')]
      pp [SampleAliase.where(:name => rr[1]).first, SampleAliase.where(:name => rr[3]).first]
      exit
    end

    if sampList.empty?
      raise ['Need to handle new smaple creation'].inspect
    end

    ### Grab or create the sample
    s=Sample.find(sampList[0])

    if ! s.nil?
      for i in 1..6
        if missingAlias[i]
          SampleAliase.create({sample:s,name:rr[i],typeCast:@header[i].camelize })
        end
      end


      # check ethnicity
      if s.ethnicity == "UNK" && ! rr[13].empty?
        s.ethnicity = rr[13]
      end

      next
    end






    pp [idx, s, s.site_of_origin]



    ##pp [idx, rr[2], ally, ally.sample ]


    ### if stored ethnicity is UNK -- overwrite with old known content




    s.save!
  break if idx > 10


  end
else
  puts "UNABLE TO FILE DATABASE!!"
end
