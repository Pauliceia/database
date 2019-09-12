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


## 4. Import and fix the 'streets_pilot_area' Shapefile into 'pauliceia_edit' database

1. If you did not fix the Shapefile, then follow the instructions listed on the first section above in order to fix the streets_pilot_area (Shapefile).

2. Import the streets_pilot_area (Shapefile) in the database using ogr2ogr using the following instructions.

The following command imports the 'streets_pilot_area.shp' file in 'pauliceia_edit' database, using 'id' as the primary key (i.e. FID). The generated table is called 'streets_pilot_area_new_version'.

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia_edit user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/streets_pilot_area/streets_pilot_area.shp -nln streets_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=id -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

3. Inside 'pauliceia_edit' database, run 'manually' the following script to fix the table requirements. This script rename 'streets_pilot_area_new_version' table to 'tb_street' and fix some problems:

01_update_tb_streets_table.sql


## 5. Import 'tb_street' table from 'pauliceia_edit' database into 'pauliceia' database

1. Backup the 'tb_street' table, generated on section 4, from 'pauliceia_edit' database and restore it into 'pauliceia' database.

2. Inside 'pauliceia' database, run 'manually' the following script to fix the table requirements:

02_restore_tb_streets_table_into_pauliceia_database.sql

3. Remove and create the layer again on Geoserver
