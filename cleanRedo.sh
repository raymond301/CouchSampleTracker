#!/usr/bin/env bash

rake db:drop:all
rake db:migrate
rake db:reset

rails runner lib/tasks/upload_newRedCap.rb -d lib/tasks/CouchLabSampleTracki_DATA_2016-01-15_NEW.csv
rails runner lib/tasks/upload_OLD_redcap.rb -d lib/tasks/SampleTrackingForAll_DATA_2016-01-15_OLDREDCAP.csv

