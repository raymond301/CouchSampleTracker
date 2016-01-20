#!/usr/bin/env bash

rake db:drop:all
rake db:migrate
rake db:reset

echo "Uploading New RedCap Database"
rails runner lib/tasks/upload_newRedCap.rb -d lib/tasks/CouchLabSampleTracki_DATA_2016-01-15_NEW.csv
echo "Uploading Old RedCap Database"
rails runner lib/tasks/upload_OLD_redcap.rb -d lib/tasks/SampleTrackingForAll_DATA_2016-01-15_OLDREDCAP.csv
echo "Uploading Variant Validation RedCap Database"
rails runner lib/tasks/upload_Validations.rb -d lib/tasks/VariantValidationsFo_DATA_2016-01-19_1432.csv

