-- ************************************************************************************************************************
-- ***** Fix 'streets_pilot_area_new_version' table
-- ************************************************************************************************************************

-- fix 'changeset_' column name
-- ALTER TABLE streets_pilot_area_new_version
-- RENAME changeset_ TO changeset_id;

-- fix columns type
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

-- copy values from 'id_street' column to the created 'id' column above
UPDATE streets_pilot_area_new_version 
SET id = id_street;

-- add PK constraint to 'id' column
ALTER TABLE streets_pilot_area_new_version
ADD PRIMARY KEY (id);

-- add FK constraint to 'changet_id' column
ALTER TABLE streets_pilot_area_new_version 
ADD CONSTRAINT constraint_changeset_id FOREIGN KEY (changeset_id)
REFERENCES changeset (changeset_id)
ON UPDATE CASCADE ON DELETE CASCADE;


-- ************************************************************************************************************************
-- ***** Specific script to add the new streets to Edit database
-- ************************************************************************************************************************

-- add 'perimeter' column (because the Edit portal uses it)
-- ALTER TABLE streets_pilot_area_new_version 
-- ADD COLUMN perimeter INT;

-- add default value (0) to created column above (if perimeter is zero, then Edit portal generates the perimeter based on LineString)
-- UPDATE streets_pilot_area_new_version 
-- SET perimeter = 0;

-- remove unnecessary table if it exists
DROP TABLE IF EXISTS tb_type_logradouro;


-- ************************************************************************************************************************
-- ***** Rename 'streets_pilot_area_new_version' to 'tb_street'
-- ************************************************************************************************************************

-- remove the FK constraint of tb_places,
-- because if there is a FK related to streets_pilot_area, then it is not possible to delete it
ALTER TABLE tb_places
DROP CONSTRAINT IF EXISTS fk_street_id;

-- remove the old 'tb_street' table
DROP TABLE tb_street;

-- rename 'streets_pilot_area_new_version' table to 'tb_street'
ALTER TABLE streets_pilot_area_new_version 
RENAME TO tb_street

-- add the FK constraint to the tb_places again
ALTER TABLE tb_places
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES tb_street (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;
