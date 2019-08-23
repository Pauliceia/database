# database


## 1. Create or active the environment:

mkvirtualenv -p /usr/bin/python3.5 pauliceia_database

workon pauliceia_database

pip install -r requirements.txt


## 2. Run script

workon pauliceia_database

python script_to_fix_accents.py


## 3. Verify the generated Shapefile (streets_pilot_area_new). 

If it is correct, then rename the folder 'streets_pilot_area_new' to 'streets_pilot_area'


## 4. Import streets_pilot_area

1. Follow the instructions listed on the first section above in order to fix the streets_pilot_area (Shapefile).

2. Import the streets_pilot_area (Shapefile) in the database using ogr2ogr.

The following command imports the 'streets_pilot_area.shp' file in PostgreSQL database, using 'id' as the primary key (i.e. FID). The generated table is called 'streets_pilot_area_new_version'.

1.1. Pauliceia database

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/streets_pilot_area/streets_pilot_area.shp -nln streets_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=id -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

1.2. Edit database

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia_edit user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/streets_pilot_area/streets_pilot_area.shp -nln streets_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=id -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

3. Run the following script to fix the table requirements:

update.sql
