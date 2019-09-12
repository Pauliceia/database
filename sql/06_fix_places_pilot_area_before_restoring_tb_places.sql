-- ************************************************************************************************************************
-- ***** WARNING: If necessary, run the following script before restoring 'tb_places' in 'pauliceia' database
-- ************************************************************************************************************************

-- Rename the sequence from 'places_pilot_area' table
ALTER SEQUENCE IF EXISTS tb_places_id_seq RENAME TO places_pilot_area_id_seq;

-- Rename the PK from 'places_pilot_area' table
ALTER INDEX IF EXISTS pk_id_places RENAME TO constraint_places_pilot_area_id_pk;
