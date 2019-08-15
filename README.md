# database

## 1. Create or active the environment:

mkvirtualenv -p /usr/bin/python3.5 pauliceia_database

workon pauliceia_database

pip install -r requirements.txt

## 2. Import streets_pilot_area

1. Import the streets_pilot_area (Shapefile) in the database using ogr2ogr:

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/streets_pilot_area/streets_pilot_area.shp -nln streets_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=fid -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

2. Follow the instructions listed on the first section above.

3. Run the following script to fix the table constraints:

update.sql