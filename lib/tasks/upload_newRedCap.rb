require 'pp'

dbFile=Rails.root.join('lib','tasks','CouchLab_NewRedCap.csv')
sampleSource={'1'=>'Thibodeau ID','2'=>'Couch Lab','3'=>'RLIMS','4'=>'External Collaborator'}
genderSource={'1'=>'Male','2'=>'Female','99'=>'Unknown'}
keepOriginSites=Hash.new
extraColumns=[14,15,16,17,20,21,23,24,25,27,28]

@header = Array.new
def hDx (str)
  return @header.index(str)
end

@pjts = Project.all.group_by(&:short)
newRedCapPrjtMap={'project_id___1'=>'simplexocc','project_id___2'=>'demok','project_id___3'=>'pan_pdx','project_id___4'=>'gepar',
                  'project_id___5'=>'tnbc_cc','project_id___6'=>'cimba','project_id___7'=>'simplexo_ex','project_id___8'=>'upenn_ds',
                  'project_id___9'=>'pan_rna','project_id___10'=>'pan_ex','project_id___11'=>'pan_cc','project_id___12'=>'coh_ds',
                  'project_id___13'=>'bcfr','project_id___14'=>'ov_pdx'}

concMethod={'1'=>'Qubit','2'=>'Picogreen','3'=>'Nanodrop','4'=>'Trinean','99'=>'Unknown'}
### parse last number


aliqoutTrack=Hash.new
keepable=[0,1]

if File.exist?(dbFile)
  File.readlines(dbFile).each_with_index do |ln, idx|
    rr=ln.split(/\,/).map{|m| m.sub(/^\"/,'').sub(/\"$/,'') }

    if idx == 0
      @header = rr
      next
    end

    ## Standardize Speciess
    sps = rr[hDx('species')].capitalize ||= 'Human'
    if sps =~ /^Homo/
      sps = 'Human'
    end


    s=Sample.create({gender:genderSource[ rr[hDx('gender')] ],ethnicity:rr[hDx('ethnicity')],cancer_type:rr[hDx('cancer_type')],
        tissue_source:rr[hDx('tissue_source')],case_control:rr[hDx('case_control')],species:sps})

    if rr[1] == "1_arm_1"
      aliqoutTrack[rr[0]]=s.id
    else
      s.aliquot_from = aliqoutTrack[rr[0]]
    end


    ########  Add other sample names  #########
    if ! rr[hDx('sample_id')].empty?
      src1 = sampleSource[ rr[hDx('sample_id_source1')]].presence || 'Couch Lab'
      SampleAliase.create({sample:s,name:rr[hDx('sample_id')],typeCast:src1,top:true})
    end
    if ! rr[hDx('sample_id_2')].empty?
      src2 = sampleSource[ rr[hDx('sample_id_source2')]].presence || 'Couch Rename'
      SampleAliase.create({sample:s,name:rr[hDx('sample_id_2')],typeCast: src2 })
    end
    if ! rr[hDx('person_id')].empty?
      SampleAliase.create({sample:s,name:rr[hDx('person_id')],typeCast:'PersonID'})
    end
    if ! rr[hDx('tn_id')].empty?
      SampleAliase.create({sample:s,name:rr[hDx('tn_id')],typeCast:'TNID'})
    end
    if ! rr[hDx('vcf_id_from_bic')].empty?
      SampleAliase.create({sample:s,name:rr[hDx('vcf_id_from_bic')],typeCast:'NGS Core reName'})
    end
    if ! rr[hDx('sample_alias')].empty?
      SampleAliase.create({sample:s,name:rr[hDx('sample_alias')],typeCast:'Custom Export Name'})
    end


    ########  Add & tie Study Groups  #########
    originStr=[rr[hDx('study_group')],rr[hDx('institution')],rr[hDx('contact')],rr[hDx('contact_email')],rr[hDx('contact_phone')]].join("_")
    if ! keepOriginSites.has_key?(originStr)
      keepOriginSites[originStr] = SiteOfOrigin.create(institution:rr[hDx('institution')],study_group:rr[hDx('study_group')],contact:rr[hDx('contact')],contact_email:rr[hDx('contact_email')],contact_phone:rr[hDx('contact_phone')])
    end
    s.site_of_origin = keepOriginSites[originStr]


    ### submission plate and ngs bic data
    sm = MayoSubmission.create(sample:s)
   # if ! rr[hDx('submission_plate')].empty? then sm.plate = rr[hDx('submission_plate')] end
   # if ! rr[hDx('submission_well')].empty? then sm.well = rr[hDx('submission_well')] end
   # if ! rr[hDx('submission_vol')].empty? then sm.volume = rr[hDx('submission_vol')].to_f end
   # if ! rr[hDx('submission_conc')].empty? then sm.concentration = rr[hDx('submission_conc')].to_f end
   # if ! rr[hDx('submission_date')].empty? then sm.created_at = Date.parse( rr[hDx('submission_date')] ) end
    if ! rr[hDx('lane_num')].empty? then sm.lane_number = rr[hDx('lane_num')] end
    if ! rr[hDx('sequence_index')].empty? then sm.sequence_index = rr[hDx('sequence_index')] end
    if ! rr[hDx('flowcell')].empty? then sm.flowcell = rr[hDx('flowcell')] end
    if ! rr[hDx('ngs_protal_batch')].empty? then sm.ngs_protal_batch = rr[hDx('ngs_protal_batch')] end
    sm.save!


    ### carry over comments ###
    if ! rr[hDx('reason_failed')].empty?
      if rr[hDx('reason_failed')] =~ /^Failed/
        s.failure = true
      end
      SampleNotes.create(sample:s,title:'Failure Reason',description:rr[hDx('reason_failed')])
    end
    if ! rr[hDx('comment')].empty?
      SampleNotes.create(sample:s,title:'Legacy Comment',description:rr[hDx('comment')])
    end
    if ! rr[hDx('comment_tracking')].empty?
      if rr[hDx('comment_tracking')] =~ /^Failed/
        s.failure = true
      end
      SampleNotes.create(sample:s,title:'Source Plate Notes',description:rr[hDx('comment_tracking')])
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



    ######## Mapp to projects ##########
    for i in 31..45
      if rr[i] == "1"
        sh=newRedCapPrjtMap[@header[i]]
        @pjts[sh][0].samples << s
        @pjts[sh][0].save!
        #raise [i,sh,newRedCapPrjtMap[sh]].inspect
      end
    end


    #### first, source location
    if ! rr[hDx('source_plate')].empty?
      lf=FreezerLocation.create(sample:s,plate_name:rr[hDx('source_plate')],plate_type:'Source Plate',process_step:"Source",
          well:rr[hDx('source_well')],volume:rr[hDx('dna_vol')],concentration:rr[hDx('dna_conc')],dna_quality:rr[hDx('dna_quality')] )
      if ! rr[hDx('submission_date')].empty?
        lf.created_at = Date.parse( rr[hDx('submission_date')] )
      end
      for i in 51..55
        if rr[i] == "1"
          lf.concentration_method=concMethod[@header[i].split(/_/).last]
          lf.save!
        end
      end
    end


    #### second, submission location
    if ! rr[hDx('source_plate')].empty?
      lf2=FreezerLocation.create(sample:s,plate_name:rr[hDx('submission_plate')],plate_type:'Submission Plate',process_step:"Submission",
          well:rr[hDx('submission_well')],volume:rr[hDx('submission_vol')],concentration:rr[hDx('submission_conc')])
      if ! rr[hDx('submission_date')].empty?
        lf2.created_at = Date.parse( rr[hDx('submission_date')] )
      end
      for i in 59..63
        if rr[i] == "1"
          lf2.concentration_method=concMethod[@header[i].split(/_/).last]
          lf2.save!
        end
      end
    end


    ### ADD THE dynamic phenotypes
    extraColumns.each do |e|
      if ! rr[e].empty?
        DemographicInformation.create(sample:s,title:@header[e].camelize,value:rr[e])
      end
    end


    s.save!
   #break if idx > 3000
    if idx % 100 == 0
      print " . "
    end
    if idx % 1000 == 0
      puts " * "
    end

  end
else
  puts "UNABLE TO FILE DATABASE!!"
end

###### iterate over projects and save each here - more effienct



#pp @header




