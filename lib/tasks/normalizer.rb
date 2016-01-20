require 'pp'

## Modify all samples, attributes specific
Sample.all.each do |s|
  s.case_control.downcase.capitalize!

  s.save!
end