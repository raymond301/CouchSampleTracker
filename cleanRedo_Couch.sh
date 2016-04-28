#!/usr/bin/env bash

rake db:drop:all
rake db:migrate
rake db:reset

echo "Uploading New RedCap Database"
#rails runner lib/tasks/upload_newRedCap.rb -d lib/assets/data/Couch/CouchLabSampleTracki_DATA_2016-04-05_1350.csv
rails runner lib/tasks/upload_newRedCap.rb -d /Users/m088378/Desktop/Couch/CouchLabSampleTracki_DATA_2016-04-20_1317.csv

echo "Uploading Old RedCap Database"
rails runner lib/tasks/upload_OLD_redcap.rb -d /Users/m088378/Desktop/Couch/OldRedCap/SampleTrackingForAll_DATA_2016-04-05_1344.csv

#echo "Uploading Variant Validation RedCap Database"
#rails runner lib/tasks/upload_Validations.rb -d lib/tasks/VariantValidationsFo_DATA_2016-01-19_1432.csv
#echo "Uploading Paths from Steve"
#rails runner lib/tasks/fileBamListUpload.rb -i lib/tasks/data_source/BAMFILES.list

echo "Renormalize the Database"
rails runner lib/tasks/normalizer.rb

