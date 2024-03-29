-- Create raw data table
DROP TABLE monthly_checkouts_per_item_raw;
CREATE TABLE monthly_checkouts_per_item_raw (
    usage_class varchar(64),
    checkout_type varchar(64),
    material_type varchar(64),
    checkout_year int,
    checkout_month int,
    checkouts int,
    title varchar(2000),
    creator varchar(256),
    subjects TEXT,
    publisher varchar(2000),
    publication_year varchar(256)
);

-- import raw data from csv (Download here: https://data.seattle.gov/Community/Checkouts-by-Title/tmmm-ytt6)
\copy monthly_checkouts_per_item_raw(usage_class, checkout_type, material_type, checkout_year, checkout_month, checkouts, title, creator, subjects, publisher, publication_year) FROM 'Checkouts_by_Title.csv' WITH DELIMITER ',' CSV HEADER;

-- Add columns for ids
ALTER TABLE monthly_checkouts_per_item_raw ADD usage_class_id int;
ALTER TABLE monthly_checkouts_per_item_raw ADD material_type_id int;
ALTER TABLE monthly_checkouts_per_item_raw ADD creator_id int;
ALTER TABLE monthly_checkouts_per_item_raw ADD publisher_id int;
ALTER TABLE monthly_checkouts_per_item_raw ADD item_id int;

-- populate usage_class table
INSERT INTO usage_class (name) SELECT DISTINCT usage_class FROM monthly_checkouts_per_item_raw;

-- insert usage_class ids into raw table
UPDATE monthly_checkouts_per_item_raw SET usage_class_id = 
(SELECT usage_class.id FROM usage_class WHERE usage_class.name = monthly_checkouts_per_item_raw.usage_class);

-- populate material_type table
INSERT INTO material_type (name) SELECT DISTINCT material_type FROM monthly_checkouts_per_item_raw;

-- populate creator table (got an issue with a null creator in here)
INSERT INTO creator (name) SELECT DISTINCT creator FROM monthly_checkouts_per_item_raw;

-- populate publisher table
INSERT INTO publisher (name) SELECT DISTINCT publisher FROM monthly_checkouts_per_item_raw;

-- insert material_type ids into raw table
-- insert creator ids into raw table
-- insert publisher ids into raw table
UPDATE monthly_checkouts_per_item_raw 
SET material_type_id = (SELECT material_type.id FROM material_type WHERE material_type.name = monthly_checkouts_per_item_raw.material_type);

-------------v      These next commands were taking more than 24+ hours to run before I canceled them. Needed to re-think my approach to the issue.

UPDATE monthly_checkouts_per_item_raw 
SET publisher_id = (SELECT publisher.id FROM publisher WHERE publisher.name = monthly_checkouts_per_item_raw.publisher);
UPDATE monthly_checkouts_per_item_raw 
SET creator_id = (SELECT creator.id FROM creator WHERE creator.name = monthly_checkouts_per_item_raw.creator);

-- TODO:
--      - populate item table and put item_id on raw table
--      - populate subjects table with distinct values (complex due to csv subject lists on items)
--      - populate item_subject table
--      - drop monthly_checkouts_per_item_raw table
--      - delete '[not listed]' entries from creator and publisher tables.