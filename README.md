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


## 4. Fix

### 4.1 Import 'tb_places' table from 'pauliceia_edit' database into 'pauliceia' database

1. Open QGIS and export 'tb_places' table from 'pauliceia_edit' database as a Shapefile called 'places_pilot_area.shp'.

2. Import the generated Shapefile above in the database using ogr2ogr using the following instructions.

The following command imports the 'places_pilot_area.shp' file in the 'pauliceia' database, using 'id' as the primary key (i.e. FID). The generated table is called 'places_pilot_area_new_version'.

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/places_pilot_area/places_pilot_area.shp -nln places_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=id -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

3. Inside 'pauliceia' database, run the following script to fix the table requirements:

sql/4_1_restore_tb_places_from_edit_database_into_pauliceia_database.sql

4. Remove and create the layer again on Geoserver


### 4.2 Import and fix the 'streets_pilot_area' Shapefile into the 'pauliceia_edit' database

Just do these steps if 'streets_pilot_area' Shapefile was updated and it is necessary to import it again into the 'pauliceia_edit' database, in order to replace the old 'tb_street' table.

1. If you did not fix the Shapefile, then follow the instructions listed in the first section above in order to fix the 'streets_pilot_area' Shapefile.

2. Import the 'streets_pilot_area' (Shapefile) in the database using ogr2ogr through the following instructions.

The following command imports the 'streets_pilot_area.shp' file in the 'pauliceia_edit' database, using 'id' as the primary key (i.e. FID). The generated table is called 'streets_pilot_area_new_version'.

ogr2ogr -append -f "PostgreSQL" PG:"host=localhost dbname=pauliceia_edit user=postgres password=postgres" /home/inpe/Documents/dockers/pauliceia-local/applications/database/streets_pilot_area/streets_pilot_area.shp -nln streets_pilot_area_new_version -a_srs EPSG:4326 -skipfailures -lco FID=id -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI

3. Inside 'pauliceia_edit' database, run 'manually' the following script to fix the table requirements. This script renames 'streets_pilot_area_new_version' table to 'tb_street' and fix some problems:

sql/4_2_fix_tb_street_table_in_the_edit_database.sql


### 4.3 Import 'tb_street' table from 'pauliceia_edit' database into 'pauliceia' database

1. First of all, update the 'places_pilot_area' from 'pauliceia_edit' database into 'pauliceia' database, as described in section 4.1.

2. If the 'streets_pilot_area' Shapefile was updated, then follow the instructions described in section 4.2.

Backup the 'tb_street' table from 'pauliceia_edit' database and restore it into 'pauliceia' database.

3. Inside 'pauliceia' database, run 'manually' the following script to fix the table requirements:

sql/4_3_restore_tb_streets_table_into_pauliceia_database.sql

4. Remove and create the layer again on Geoserver
