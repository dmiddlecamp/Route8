# first, grab the data file at
# ftp://gisftp.metc.state.mn.us/google_transit.zip
# (info at
# http://datafinder.org/metadata/transit_schedule_google_feed.html )
#
echo "Extracting the route-8-specific trip and route data"
grep '^8\-' trips.txt > trips_8.txt
grep '^8\-' routes.txt > routes_8.txt
echo "Sorting the stop times by trip_id"
sort -t, --key=1 --parallel=4 stop_times.txt > stop_times_sorted.txt
echo "Sorting on the trip_id field of the route-8 trips file"
sort -t, --key=3 trips_8.txt > trips_8_sorted.txt
echo "Extracting the route 8 stops"
join -t, -1 3 -2 1 trips_8_sorted.txt stop_times_sorted.txt > stop_times_8.txt
echo "Ordering by the stop ID for the route 8 stops"
sort -t, --key=10 stop_times_8.txt > stop_times_8_sorted.txt
echo "Sorting full list of stops"
sort -t, --key=1 stops.txt > stops_sorted.txt
echo "Linking up the full list of stops (with lat,lon etc) with route-8 stops"
join -t, -1 1 -2 10 stops_sorted.txt stop_times_8_sorted.txt > stops8.txt
echo "Prepend the header line to the data file"
echo "stop_id,stop_name,stop_desc,stop_lat,stop_lon,stop_street,stop_city,stop_region,stop_postcode,stop_country,zone_id,wheelchair_boarding,stop_url,trip_id,route_id,service_id,trip_headsign,block_id,shape_id,wheelchair_accessible,arrival_time,departure_time,stop_sequence,pickup_type,drop_off_type" > /tmp/stops8
cat stops8.txt >> /tmp/stops8
cp /tmp/stops8 stops8_header.txt
#
# Then here's some field extraction to check out how many bus visits there 
# are per day and what kinds of frequency there is.
# cut -d, -f 1 stops8_header.txt | more
# cut -d, -f 1 stops8.txt | more
# cut -d, -f 1 stops8.txt | uniq -c
# cut -d, -f 1,14 | more
# cut -d, -f 1,14 stops8.txt | more
# cut -d, -f 1,14 stops8.txt | uniq -c
# cut -d, -f 1,15 stops8.txt | uniq -c
# cut -d, -f 1,16 stops8.txt | uniq -c
# cut -d, -f 1,16 stops8.txt | uniq -c | more
# cut -d, -f 1,16 stops8.txt | sort | uniq -c
# cut -d, -f 2,16 stops8.txt | sort | uniq -c
# cut -d, -f 2,21 stops8.txt | more
# cut -d, -f 2,21 stops8.txt | sort | more
# cut -d, -f 2,16,21 stops8.txt | sort | more
