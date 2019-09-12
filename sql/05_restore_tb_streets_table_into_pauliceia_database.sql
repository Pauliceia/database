-- ************************************************************************************************************************
-- ***** Section 1. Generic script
-- ************************************************************************************************************************

-- Remove the FK constraint from 'places_pilot_area*',
-- because if there is a FK related to 'streets_pilot_area' table, then it is not possible to remove it
ALTER TABLE places_pilot_area
DROP CONSTRAINT IF EXISTS fk_street_id;

ALTER TABLE places_pilot_area2
DROP CONSTRAINT IF EXISTS constraint_fk_id_street;


-- ************************************************************************************************************************

-- Do it, just if it is necessary
-- TODO: fix problems from 'version_' tables, where the sequence name from 'version_' table is the save from original table

-- Remove the sequence from table id
ALTER TABLE version_streets_pilot_area 
ALTER COLUMN id DROP DEFAULT;

-- ************************************************************************************************************************


-- Remove 'streets_pilot_area' table, if it exists
DROP TABLE IF EXISTS streets_pilot_area;

-- Rename 'tb_street' table to 'streets_pilot_area'
ALTER TABLE tb_street 
RENAME TO streets_pilot_area;


-- ************************************************************************************************************************

-- Do it, just if it is necessary
-- TODO: backup 'tb_places' from 'pauliceia_edit' and restore in 'pauliceia'

DELETE FROM places_pilot_area
WHERE id = 3825;

DELETE FROM places_pilot_area
WHERE id = 4084;

-- ************************************************************************************************************************


-- Add the FK constraint to the 'places_pilot_area*' table again
ALTER TABLE places_pilot_area
ADD CONSTRAINT fk_street_id
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE places_pilot_area2
ADD CONSTRAINT fk_street_id
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;
