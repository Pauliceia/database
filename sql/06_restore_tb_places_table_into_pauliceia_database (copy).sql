-- ************************************************************************************************************************
-- ***** WARNING: Run the following script after restore 'tb_places' in 'pauliceia' database
-- ************************************************************************************************************************

-- Remove the old 'places_pilot_area' table, if it exists
DROP TABLE IF EXISTS places_pilot_area;

-- Rename 'tb_places' table to 'places_pilot_area' table
ALTER TABLE tb_places 
RENAME TO places_pilot_area;

-- Rename the sequence from 'places_pilot_area' table
ALTER SEQUENCE IF EXISTS tb_places_id_seq RENAME TO places_pilot_area_id_seq;

-- Rename the PK from 'places_pilot_area' table
ALTER INDEX IF EXISTS pk_id_places RENAME TO constraint_places_pilot_area_id_pk;
