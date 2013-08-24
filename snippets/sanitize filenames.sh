# replace characters other than  A-Za-z0-9~.,_()'-  with _
sed -e s/[^A-Za-z0-9.,_\(\)\-]/_/g 
