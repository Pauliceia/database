-- ************************************************************************************************************************
-- ***** Section 1. Generic script
-- ************************************************************************************************************************

-- Fix 'changeset_' column name
ALTER TABLE streets_pilot_area_new_version
RENAME changeset_ TO changeset_id;

-- Fix columns types
ALTER TABLE streets_pilot_area_new_version
ALTER COLUMN id_street TYPE INT,
ALTER COLUMN first_year TYPE INT,
ALTER COLUMN last_year TYPE INT,
-- perimeter
ALTER COLUMN perimeter TYPE INT,
ALTER COLUMN perimeter SET NOT NULL,
ALTER COLUMN perimeter SET DEFAULT 0,
-- version
ALTER COLUMN version TYPE INT,
ALTER COLUMN version SET NOT NULL,
ALTER COLUMN version SET DEFAULT 1,
-- changeset_id
ALTER COLUMN changeset_id TYPE INT,
ALTER COLUMN changeset_id SET NOT NULL,
ALTER COLUMN changeset_id SET DEFAULT 2;

-- Remove not needed 'fid' column
ALTER TABLE streets_pilot_area_new_version 
DROP COLUMN fid;

-- copy values from 'id_street' column to the created 'id' column above
-- WARNING: verify if the 'id' and 'id_street' are equal, if they are not equal, then use this code
-- UPDATE streets_pilot_area_new_version 
-- SET id = id_street;

-- add PK constraint to 'id' column
-- WARNING: if the 'streets_pilot_area_new_version' table was inserted by OGR using 'id' as 'FID' (PK), then this code is not needed
-- ALTER TABLE streets_pilot_area_new_version
-- ADD PRIMARY KEY (id);


-- ************************************************************************************************************************
-- ***** Section 2. Specific script to 'pauliceia' database
-- ************************************************************************************************************************

-- Create a backup from 'tb_streets' from 'pauliceia_edit' database and restore it into 'pauliceia' database

/*
-- add FK constraint to 'changet_id' column
ALTER TABLE streets_pilot_area_new_version 
ADD CONSTRAINT constraint_changeset_id FOREIGN KEY (changeset_id)
REFERENCES changeset (changeset_id)
ON UPDATE CASCADE ON DELETE CASCADE;

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

-- Fix sequence name
ALTER SEQUENCE streets_pilot_area_new_version_id_seq 
RENAME TO streets_pilot_area_id_seq;

-- add the FK constraint to the places_pilot_area and places_pilot_area2 again
ALTER TABLE places_pilot_area
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE places_pilot_area2
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;
*/

-- ************************************************************************************************************************
-- ***** Section 3. Specific script to 'pauliceia_edit' database
-- ************************************************************************************************************************

-- Remove the FK constraint of tb_places,
-- because if there is a FK related to tb_street table, then it is not possible to delete it
ALTER TABLE tb_places
DROP CONSTRAINT IF EXISTS fk_street_id;

-- Remove the old 'tb_street' table, if it exists
DROP TABLE IF EXISTS tb_street;

-- Remove unnecessary table, if it exists
DROP TABLE IF EXISTS tb_type_logradouro;

-- Rename 'streets_pilot_area_new_version' table to 'tb_street'
ALTER TABLE streets_pilot_area_new_version 
RENAME TO tb_street;

-- Fix sequence name
ALTER SEQUENCE streets_pilot_area_new_version_id_seq 
RENAME TO tb_street_id_seq;

-- Fix 'first_year' with no data, it adds default value (i.e. 1930)
UPDATE tb_street
SET first_year = 1930
WHERE first_year = 0;

-- Fix 'last_year' with no data, it adds default value (i.e. 1940)
UPDATE tb_street
SET last_year = 1940
WHERE last_year = 0;


-- ************************************************************************************************************************
-- ***** Subsection 3.1.
-- ************************************************************************************************************************

-- 'rua da cantareira' had two vectors, because of that, they were merged, but there were two "points 0", then remove the unnecessary one
-- DELETE FROM tb_places
-- WHERE id = 3825;

-- 'rua da cantareira' had two vectors, because of that, they were merged, but there were two "points 0", then remove the unnecessary one (id = 3825)
-- record is deleted if 'id = 3825' is found by SELECT clause
DELETE FROM tb_places p
WHERE p.id IN (
	SELECT id
	FROM tb_places
	WHERE id = 3825
);

-- there are two 'points 0' related to 'praça marechal deodoro', then remove the unnecessary one (id = 4084)
DELETE FROM tb_places p
WHERE p.id IN (
	SELECT id
	FROM tb_places
	WHERE id = 4084
);

-- ************************************************************************************************************************

-- Add the FK constraint to the tb_places table again
ALTER TABLE tb_places
ADD CONSTRAINT constraint_fk_id_street
FOREIGN KEY (id_street) REFERENCES tb_street (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;


-- ************************************************************************************************************************
-- ***** Section 4. A "SELECT" clause, in order to test the tables...
-- ************************************************************************************************************************
/*
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


SELECT *
FROM tb_street
--WHERE id = 280;
WHERE name = 'rua carlos de campos';

SELECT *
FROM tb_places
WHERE id_street = 280;
*/
