-- ************************************************************************************************************************
-- ***** Fix 'streets_pilot_area_new_version' table
-- ************************************************************************************************************************

-- fix 'changeset_' column name
-- ALTER TABLE streets_pilot_area_new_version
-- RENAME changeset_ TO changeset_id;

-- fix columns type
ALTER TABLE streets_pilot_area_new_version
ALTER COLUMN id_street TYPE INT,
ALTER COLUMN first_year TYPE INT,
ALTER COLUMN last_year TYPE INT,
ALTER COLUMN perimeter TYPE INT NOT NULL DEFAULT 0,
ALTER COLUMN version TYPE INT NOT NULL DEFAULT 1,
ALTER COLUMN changeset_id TYPE INT NOT NULL DEFAULT 2;

-- remove not needed 'fid' column
ALTER TABLE streets_pilot_area_new_version 
DROP COLUMN fid;

-- remove old 'id' column
-- ALTER TABLE streets_pilot_area_new_version 
-- DROP COLUMN id;

-- create a new 'id' column
-- ALTER TABLE streets_pilot_area_new_version 
-- ADD COLUMN id INT;

-- copy values from 'id_street' column to the created 'id' column above
-- WARNING: verify if the 'id' and 'id_street' are equal, if they are not equal, then use this code
-- UPDATE streets_pilot_area_new_version 
-- SET id = id_street;

-- add PK constraint to 'id' column
-- WARNING: if the 'streets_pilot_area_new_version' table was inserted by OGR using 'id' as 'FID' (PK), then this code is not needed
-- ALTER TABLE streets_pilot_area_new_version
-- ADD PRIMARY KEY (id);

-- ************************************************************************************************************************
-- ***** Specific script to add the new streets to Pauliceia database
-- ************************************************************************************************************************

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
-- ***** Rename 'streets_pilot_area_new_version' ...
-- ************************************************************************************************************************

-- ************************************************************************************************************************
-- ***** ... to 'streets_pilot_area' (Pauliceia database)
-- ************************************************************************************************************************

-- remove the FK constraint of 'places_pilot_area' and 'places_pilot_area2', 
-- because if there is a FK to 'streets_pilot_area', then it is not possible to delete it
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


-- ************************************************************************************************************************
-- ***** ... to 'tb_street' (Edit database)
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


-- ************************************************************************************************************************
-- ***** A "SELECT" clause, in order to test the tables...
-- ************************************************************************************************************************

SELECT *
FROM (
	SELECT 
		snv.id as street_new_version_id, 
		tbs.id as table_street_id, 
		snv.id_street as street_new_version_id_street, 
		snv.name as street_new_version_name, 
		tbs.name as table_street_name
	FROM streets_pilot_area_new_version as snv
	LEFT JOIN (
		SELECT tbs.id, tbs.name
		FROM tb_street as tbs
		ORDER BY tbs.id
	) as tbs
	ON snv.id = tbs.id
	ORDER BY snv.id
) as snv_tbs
-- WHERE street_new_version_id != table_street_id
-- WHERE table_street_id is NULL
