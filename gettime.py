from datetime import datetime as dt, timedelta
import datetime
import sys

start=sys.argv[1]
duration=sys.argv[2]
time_stamp = int(start) / 1000 

date_time = dt.fromtimestamp(time_stamp)
print(date_time)
fulldate = date_time + datetime.timedelta(milliseconds=int(duration))
fulldate = fulldate.replace(microsecond=0)
print(fulldate)
