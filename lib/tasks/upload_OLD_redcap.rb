require 'pp'

dbFile=Rails.root.join('lib','tasks','CouchLab_OldRedCap2.csv')

allStudyGroups=SiteOfOrigin.all.group_by(&:study_group) #.map(&:first)
genderSource={'1'=>'Male','2'=>'Female','99'=>'Unknown'}

#pp allStudyGroups
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

    if !sampList.empty?
      ### Grab or create the sample
      s=Sample.find(sampList[0])

      if ! s.nil?
        for i in 1..6
          if missingAlias[i]
            SampleAliase.create({sample:s,name:rr[i],typeCast:@header[i].camelize })
          end
        end

        # check ethnicity
        ### if stored ethnicity is UNK -- overwrite with old known content
        if s.ethnicity == "UNK" && ! rr[13].empty?
          s.ethnicity = rr[13]
        end
        next  ## no need to coninue on existing samples.
      end
    end


      ## Standardize Speciess
      sps = rr[hDx('species')].capitalize ||= 'Human'
      if sps =~ /^Homo/
        sps = 'Human'
      end

      s=Sample.create({gender:genderSource[ rr[hDx('gender')] ],ethnicity:rr[hDx('ethnicity')],cancer_type:rr[hDx('cancer_type')],
          tissue_source:rr[hDx('tissue_source')],case_control:rr[hDx('case_control')],species:sps})


     ## Find or Create a study group / site of origin
     if allStudyGroups[rr[hDx('study_group')]].size == 1
       s.site_of_origin = allStudyGroups[rr[hDx('study_group')]].first
     else
       raise [rr[hDx('study_group')], allStudyGroups[rr[hDx('study_group')]].size ].inspect
     end






    pp [idx, s, s.site_of_origin]



    s.save!
  break if idx > 330

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end
