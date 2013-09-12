# Find the device path of your trackpoint -
# it will return something like
# /sys/devices/platform/i8042/serio1/serio2

find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'
