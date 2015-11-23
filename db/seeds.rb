# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Project.create([{name:'Simplexo Custom Capture',short:'simplexocc',total:2446,cases:2180,cntls:265,purpose:'City of Hope, MSKCC, Stanford, UPENN'},
    {name:'TNBC Custom Capture',short:'tnbc_cc',total:2640,cases:1824,cntls:816,purpose:'Mayo Pooled Samples, Demokratos, Ambry?'},
    {name:'CIMBA Whole Genome',short:'cimba',total:101,cases:0,cntls:0,purpose:''},
    {name:'Pancreas Exomes',short:'pan_ex',total:120,cases:0,cntls:0,purpose:'PANIN'},
    {name:'Simplexo Exomes',short:'simplexo_ex',total:247,cases:0,cntls:0,purpose:'Mayo Familial Breast Cancer & UPENN'},
    {name:'Pancreas SPORE mRNA',short:'pan_rna',total:68,cases:0,cntls:0,purpose:'mRNA expression'},
    {name:'Demokritos',short:'demok',total:326,cases:272,cntls:0,purpose:'Connection to TNBC Group, 24 samples < 1M reads'},
    {name:'Pancreas PDX',short:'pan_pdx',total:15,cases:13,cntls:0,purpose:'SPORE xenographs, Tumors'},
    {name:'Gepar Quinto',short:'gepar',total:495,cases:0,cntls:0,purpose:'German Clinical Trial; [480 in 1st batch, ~500 coming => mix and match]'},
    {name:'UPENN DataSharing',short:'upenn_ds',total:1456,cases:0,cntls:0,purpose:'Different Capture Kit'},
    {name:'Pancreas SPORE CC',short:'pan_cc',total:96,cases:0,cntls:96,purpose:'McWilliams (Collab.), Simplexo CC Kit'},
    {name:'COH DataSharing',short:'coh_ds',total:360,cases:0,cntls:0,purpose:'Converted from Varscan'},
    {name:'BreastCancerFamilyRegistry',short:'bcfr',total:86,cases:0,cntls:0,purpose:'New York, Fox Chase Cancer Center'},
    {name:'Ovarian PDX',short:'ov_pdx',total:0,cases:0,cntls:0,purpose:''},
    #{name:'FFPE',short:'ffpe',total:0,cases:0,cntls:0,purpose:'mRNA expression'},
    {name:'CARRIERS',short:'carrier',total:0,cases:0,cntls:0,purpose:'HiPlex, 28 Gene Panel'}
])


#newRedCapPrjtMap={'project_id___1'=>'simplexocc','project_id___2'=>'demok','project_id___3'=>'pan_pdx','project_id___4'=>'gepar',
#'project_id___5'=>'tnbc_cc','project_id___6'=>'cimba','project_id___7'=>'simplexo_ex','project_id___8'=>'upenn_ds',
#'project_id___9'=>'pan_rna','project_id___10'=>'pan_ex',project_id___11'=>'pan_cc','project_id___12'=>'coh_ds','project_id___13'=>'bcfr','project_id___14'=>'ov_pdx'}

# 1, SIMPLEXO | 2, Demokratos | 3, Pancreas PDX | 4, German Clinical Trial | 5, TNBC Custom Capture |
# 6, CIMBA WGS | 7, Familial Breast Cancer Exomes | 8, UPENN Data Sharing | 9, Pancreas mRNA | 10, Pancreas Exomes |
# 11, Pancreas SPORE CC | 12, COH Data Sharing | 13, Offsite Breast Cancer Family Registry | 14, Ovarian PDX | 50, to_delete