
# set the internal field spereator to newline character,
# so that spaces (e.g. in filenames) won't be interpreted
# as the separator between the items, but a part of them:
IFS=$(echo -en "\n")
# can be done like this as well:
IFS=","
