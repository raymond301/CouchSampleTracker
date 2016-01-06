require 'pp'

dbFile=Rails.root.join('lib','tasks','CouchLab_OldRedCap2.csv')

allStudyGroups=SiteOfOrigin.all.group_by(&:study_group) #.map(&:first)
genderSource={'1'=>'Male','2'=>'Female','99'=>'Unknown'}
keepOriginSites=Hash.new


@pjts = Project.all.group_by(&:short)
newRedCapPrjtMap={'project_id___1'=>'simplexocc','project_id___2'=>'demok','project_id___3'=>'pan_pdx','project_id___4'=>'gepar',
                  'project_id___5'=>'tnbc_cc','project_id___6'=>'cimba','project_id___7'=>'simplexo_ex','project_id___8'=>'upenn_ds',
                  'project_id___9'=>'pan_rna','project_id___10'=>'pan_ex','project_id___11'=>'pan_cc','project_id___12'=>'coh_ds',
                  'project_id___13'=>'bcfr'}

#pp allStudyGroups
#exit


@header = Array.new
def hDx (str)
  return @header.index(str)
end


if File.exist?(dbFile)
  File.readlines(dbFile).each_with_index do |ln, idx|
    next if ln =~ /^$/

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
        elsif rr[i] =~ /^Mayo_TN_CC_/
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
      pp [SampleAliase.where(:name => rr[1]).first, SampleAliase.where(:name => rr[3]).first]
      puts "\n\n"
      #exit
      next
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

    pp rr[0..8].join("|")

      s=Sample.create({gender:genderSource[ rr[hDx('gender')] ],ethnicity:rr[hDx('ethnicity')],cancer_type:rr[hDx('cancer_type')],
          tissue_source:rr[hDx('tissue_source')],case_control:rr[hDx('case_control')],species:sps})


     ## Find or Create a study group / site of origin
     stdgrp = rr[hDx('study_group')]
    if allStudyGroups.has_key?( stdgrp )
     if allStudyGroups[stdgrp].size == 1
       s.site_of_origin = allStudyGroups[stdgrp].first
     else  #if allStudyGroups[stdgrp].size > 1
       s.site_of_origin = allStudyGroups[stdgrp].first
     end

    else
       if ! keepOriginSites.has_key?( stdgrp )
         keepOriginSites[rr[hDx('study_group')]] = SiteOfOrigin.create( study_group: stdgrp )
       end
       s.site_of_origin = keepOriginSites[stdgrp]
     end

    # add names
    for i in 1..6
      if ! rr[i].empty?
        sa = SampleAliase.create({sample:s,name:rr[i],typeCast:@header[i].camelize })
      end
      if rr[1] =~ /^Mayo_TN_CC/ && i == 3
        sa.top = true
        sa.save!
      elsif i == 1
        sa.top = true
        sa.save!
      end
    end


    # add additional phenotypic data
    for i in [9,10,11,12,16,17,18,34,35]
      if ! rr[i].empty?
        DemographicInformation.create(sample:s,title:@header[i].camelize,value:rr[i])
      end
    end


    ######## Mapp to projects ##########
    for i in 19..31
      if rr[i] == "1"
        sh=newRedCapPrjtMap[@header[i]]
        @pjts[sh][0].samples << s
        @pjts[sh][0].save!
      end
    end


    ### carry over comments ###
    if ! rr[hDx('reason_failed')].empty?
      if rr[hDx('reason_failed')] =~ /Failed/i
        s.failure = true
      end
      SampleNotes.create(sample:s,title:'Failure Reason',description:rr[hDx('reason_failed')])
    end
    if ! rr[hDx('comment')].empty?
      SampleNotes.create(sample:s,title:'Legacy Comment',description:rr[hDx('comment')])
    end



    pp [idx, s, s.site_of_origin]



    s.save!
  break if idx > 10

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end
