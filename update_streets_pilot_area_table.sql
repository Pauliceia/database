
-- fix 'changeset_' column name
ALTER TABLE streets_pilot_area_new_version
RENAME changeset_ TO changeset_id;

-- fix type of the columns
ALTER TABLE streets_pilot_area_new_version
ALTER COLUMN id_street TYPE INT,
ALTER COLUMN name TYPE VARCHAR(100),
ALTER COLUMN obs TYPE VARCHAR(100),
ALTER COLUMN first_year TYPE INT,
ALTER COLUMN last_year TYPE INT,
ALTER COLUMN version TYPE INT NOT NULL DEFAULT 1,
ALTER COLUMN changeset_id TYPE INT;

-- remove not needed 'fid' column
ALTER TABLE streets_pilot_area_new_version 
DROP COLUMN fid;

-- remove old 'id' column
ALTER TABLE streets_pilot_area_new_version 
DROP COLUMN id;

-- create a new 'id' column
ALTER TABLE streets_pilot_area_new_version 
ADD COLUMN id INT;

-- copy values from 'id_street' column to created 'id' column above
UPDATE streets_pilot_area_new_version 
SET id = id_street;

-- add PK constraint to 'id' constraint
ALTER TABLE streets_pilot_area_new_version
ADD PRIMARY KEY (id);

-- add FK constraint to 'changet_id' column
ALTER TABLE streets_pilot_area_new_version 
ADD CONSTRAINT constraint_changeset_id FOREIGN KEY (changeset_id)
REFERENCES changeset (changeset_id)
ON UPDATE CASCADE ON DELETE CASCADE;


-- ************************************************************************************************************************
-- ***** Rename 'streets_pilot_area_new_version' to 'streets_pilot_area'
-- ************************************************************************************************************************

-- remove the FK constraint of places_pilot_area and places_pilot_area2, 
-- because if there is a FK to streets_pilot_area, then it is not possible to delete it
ALTER TABLE places_pilot_area 
DROP CONSTRAINT IF EXISTS constraint_fk_id_street;

ALTER TABLE places_pilot_area2
DROP CONSTRAINT IF EXISTS constraint_fk_id_street;

-- remove the old 'streets_pilot_area' table
DROP TABLE streets_pilot_area;

-- rename 'streets_pilot_area_new_version' table to 'streets_pilot_area'
ALTER TABLE streets_pilot_area_new_version 
RENAME TO streets_pilot_area

-- add the FK constraint to the places_pilot_area and places_pilot_area2 again
ALTER TABLE places_pilot_area
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE places_pilot_area2
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;
