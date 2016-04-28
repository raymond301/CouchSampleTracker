#!/usr/bin/env bash

rake db:drop:all
rake db:migrate
rake db:reset

echo "Uploading New RedCap Database"
rails runner lib/tasks/upload_newRedCap.rb -d lib/tasks/CouchLabSampleTracki_DATA_2016-01-15_NEW.csv



echo "Renormalize the Database"
rails runner lib/tasks/normalizer.rb

