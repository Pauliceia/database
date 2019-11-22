-- ************************************************************************************************************************
-- ***** Section 1. Generic script
-- ************************************************************************************************************************

-- Remove the FK constraint from 'places_pilot_area*',
-- because if there is a FK related to 'streets_pilot_area' table, then it is not possible to remove it
ALTER TABLE places_pilot_area
DROP CONSTRAINT IF EXISTS places_pilot_area_fk_street_id;

ALTER TABLE places_pilot_area2
DROP CONSTRAINT IF EXISTS constraint_fk_id_street;


-- ************************************************************************************************************************

-- Do it, just if it is necessary
-- TODO: fix problems from 'version_' tables, where the sequence name from 'version_' table is the save from original table
-- If the above problem is fixed, then this code can be removed

-- Remove the sequence from table id
ALTER TABLE version_streets_pilot_area
ALTER COLUMN id DROP DEFAULT;

-- ************************************************************************************************************************


-- Remove 'streets_pilot_area' table, if it exists
DROP TABLE IF EXISTS streets_pilot_area;

-- Rename 'tb_street' table to 'streets_pilot_area'
ALTER TABLE tb_street
RENAME TO streets_pilot_area;

-- Fix sequence name
ALTER SEQUENCE tb_street_id_seq
RENAME TO streets_pilot_area_id_seq;

-- Fix indexes
-- geom
-- ALTER INDEX IF EXISTS places_pilot_area_new_version_geom_geom_idx
-- RENAME TO places_pilot_area_geom_geom_idx;

-- Add the FK constraint to the 'places_pilot_area*' table again
ALTER TABLE places_pilot_area
ADD CONSTRAINT places_pilot_area_fk_street_id
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE places_pilot_area2
ADD CONSTRAINT places_pilot_area2_fk_street_id
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;
