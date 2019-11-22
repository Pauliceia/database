-- ************************************************************************************************************************
-- ***** Section 1. Generic script
-- ************************************************************************************************************************


-- Fix columns names
ALTER TABLE places_pilot_area_new_version
RENAME original_n TO original_number;

ALTER TABLE places_pilot_area_new_version
RENAME first_mont TO first_month;

ALTER TABLE places_pilot_area_new_version
RENAME descriptio TO description;


-- Fix columns types
ALTER TABLE places_pilot_area_new_version
-- "number"
ALTER COLUMN "number" TYPE DOUBLE PRECISION,
ALTER COLUMN "number" SET NOT NULL,
-- first_[day|month|year]
ALTER COLUMN first_day TYPE INT,
ALTER COLUMN first_month TYPE INT,
ALTER COLUMN first_year TYPE INT,
-- last_[day|month|year]
ALTER COLUMN last_day TYPE INT,
ALTER COLUMN last_month TYPE INT,
ALTER COLUMN last_year TYPE INT,
-- disc_date
ALTER COLUMN disc_date TYPE BOOLEAN USING (disc_date::int::bool),
ALTER COLUMN disc_date SET NOT NULL,
ALTER COLUMN disc_date SET DEFAULT false,
-- other
ALTER COLUMN name TYPE TEXT,
ALTER COLUMN original_number TYPE TEXT,
ALTER COLUMN description TYPE TEXT,
ALTER COLUMN source TYPE TEXT,
ALTER COLUMN id_user TYPE INT,
ALTER COLUMN id_street TYPE INT;


-- Fix sequences
-- PK
ALTER SEQUENCE IF EXISTS places_pilot_area_new_version_id_seq 
RENAME TO places_pilot_area_id_seq;


-- Fix indexes
-- geom
ALTER INDEX IF EXISTS places_pilot_area_new_version_geom_geom_idx
RENAME TO places_pilot_area_geom_geom_idx;
-- PK
ALTER INDEX IF EXISTS places_pilot_area_new_version_pkey 
RENAME TO places_pilot_area_pkey;


-- Remove the old 'places_pilot_area' table, if it exists
-- DROP TABLE IF EXISTS places_pilot_area;

-- Rename 'tb_places' table to 'places_pilot_area' table
ALTER TABLE places_pilot_area_new_version 
RENAME TO places_pilot_area;

-- Add the FK constraint to the 'places_pilot_area' table
ALTER TABLE places_pilot_area
ADD CONSTRAINT places_pilot_area_fk_street_id
FOREIGN KEY (id_street) REFERENCES streets_pilot_area (id)
ON UPDATE CASCADE ON DELETE CASCADE;
