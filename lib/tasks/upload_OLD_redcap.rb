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


#dbFile=Rails.root.join('lib','tasks','CouchLab_OldRedCap2.csv')
#dbFile=Rails.root.join('lib','tasks','SampleTrackingForAll_DATA_2016-01-07_0754.csv')

allStudyGroups=SiteOfOrigin.all.group_by(&:study_group) #.map(&:first)
genderSource={'1'=>'Male','2'=>'Female','99'=>'Unknown'}
keepOriginSites=Hash.new


@pjts = Project.all.group_by(&:short)
newRedCapPrjtMap={'project_id___1'=>'simplexocc','project_id___2'=>'demok','project_id___3'=>'pan_pdx','project_id___4'=>'gepar',
                  'project_id___5'=>'tnbc_cc','project_id___6'=>'cimba','project_id___7'=>'simplexo_ex','project_id___8'=>'upenn_ds',
                  'project_id___9'=>'pan_rna','project_id___10'=>'pan_ex','project_id___11'=>'pan_cc','project_id___12'=>'coh_ds',
                  'project_id___13'=>'bcfr'}

###### need to fix up plate_barcode in old to fit in either source or submission plate


@header = Array.new
def hDx (str)
  return @header.index(str)
end


if File.exist?(dbFile)
  puts "\nStarting Old Redcap..."
  File.readlines(dbFile).each_with_index do |ln, idx|
    #puts idx
    next if ln =~ /^$/

    rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }
    if idx == 0
      @header = rr
      next
    end

    if idx % 100 == 0
      print " . "
    end
    if idx % 1000 == 0
      puts " * "
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
      puts "MULTIPLE SAMPLES ON 1 ROW ISSUE!!!!"
      pp [idx, sampArr]
      pp [SampleAliase.where(:name => rr[1]).first, SampleAliase.where(:name => rr[3]).first]
      puts "\n\n"
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

   # pp rr[0..8].join("|")

      s=Sample.create({gender: genderSource[ rr[hDx('gender')] ],ethnicity:rr[hDx('ethnicity')],cancer_type:rr[hDx('cancer_type')],
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
    for i in [8,9,10,11,15,16,17,33,34]
      if !rr[i].empty?
        DemographicInformation.create(sample:s,title:@header[i].camelize,value:rr[i])
      end
    end


    ######## Mapp to projects ##########
    for i in 18..31
      if rr[i] == "1"
        sh=newRedCapPrjtMap[@header[i]]
        @pjts[sh][0].samples << s
        @pjts[sh][0].save!
       # pp [i, sh, @pjts[sh]]
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



    ###### Grab file locations where available  ########
    if ! rr[hDx('bam_local')].empty?
      FileLocation.create(sample:s,typeCast:'Local Bam',location:rr[hDx('bam_local')])
    end
    if ! rr[hDx('bam_remote')].empty?
      FileLocation.create(sample:s,typeCast:'FTP Bam',location:rr[hDx('bam_remote')])
    end
    if ! rr[hDx('vcf_local')].empty?
      FileLocation.create(sample:s,typeCast:'Local VCF',location:rr[hDx('vcf_local')])
    end
    if ! rr[hDx('vcf_remote')].empty?
      FileLocation.create(sample:s,typeCast:'FTP VCF',location:rr[hDx('vcf_remote')])
    end
    if ! rr[hDx('gvcf_local')].empty?
      FileLocation.create(sample:s,typeCast:'Local gVCF',location:rr[hDx('gvcf_local')])
    end
    if ! rr[hDx('gvcf_remote')].empty?
      FileLocation.create(sample:s,typeCast:'FTP gVCF',location:rr[hDx('gvcf_remote')])
    end




    # ### submission plate and ngs bic data
    ngsStr = rr[42..45].join('')
    if !ngsStr.empty?
      sm = MayoSubmission.create(sample:s)
      if ! rr[hDx('lane_num')].empty? then sm.lane_number = rr[hDx('lane_num')] end
      if ! rr[hDx('sequence_index')].empty? then sm.sequence_index = rr[hDx('sequence_index')] end
      if ! rr[hDx('flowcell')].empty? then sm.flowcell = rr[hDx('flowcell')] end
      if ! rr[hDx('ngs_protal_batch')].empty? then sm.ngs_protal_batch = rr[hDx('ngs_protal_batch')] end
      sm.save!
    end


    #### first, source location
    if ! rr[hDx('source_plate')].empty?
      FreezerLocation.create(sample:s,plate_name:rr[hDx('source_plate')],plate_type:'Source Plate',process_step:"Source",well:rr[hDx('source_well')] )
    end
    if ! rr[hDx('submission_plate')].empty?
      FreezerLocation.create(sample:s,plate_name:rr[hDx('submission_plate')],plate_type:'Submission Plate',process_step:"Submission",well:rr[hDx('well')] )
    end

    # pp [idx, s, s.site_of_origin]



    s.save!
    # break if idx > 10

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end
