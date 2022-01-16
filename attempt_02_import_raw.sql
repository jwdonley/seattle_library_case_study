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
\copy monthly_checkouts_per_item_raw(
    usage_class,
    checkout_type,
    material_type,
    checkout_year,
    checkout_month,
    checkouts,
    title,
    creator,
    subjects,
    publisher,
    publication_year
)
FROM
    'raw_data\Checkouts_by_Title.csv' WITH DELIMITER ',' CSV HEADER;

-- remove all older entries
DELETE FROM
    monthly_checkouts_per_item_raw
WHERE
    checkout_year < 2015;

-- populate usage_class table
INSERT INTO
    usage_class (name) (
        SELECT
            DISTINCT usage_class
        FROM
            monthly_checkouts_per_item_raw
    );

-- insert usage_class ids into raw table
UPDATE
    monthly_checkouts_per_item_raw
SET
    usage_class_id = (
        SELECT
            usage_class.id
        FROM
            usage_class
        WHERE
            usage_class.name = monthly_checkouts_per_item_raw.usage_class
    );

-- populate material_type table
INSERT INTO
    material_type (name) (
        SELECT
            DISTINCT material_type
        FROM
            monthly_checkouts_per_item_raw
    );

-- insert material_type ids into raw table
UPDATE
    monthly_checkouts_per_item_raw
SET
    material_type_id = (
        SELECT
            material_type.id
        FROM
            material_type
        WHERE
            material_type.name = monthly_checkouts_per_item_raw.material_type
    );

-- populate subject table
INSERT INTO
    subject (name) (
        SELECT
            DISTINCT unnest(string_to_array(subjects, ', ')) AS subject
        FROM
            monthly_checkouts_per_item_raw
    );

-- add temporary column to target table
ALTER TABLE
    monthly_checkout
ADD
    subjects text NULL;

--------------TODO-------------v
-- fill monthly_checkout table
INSERT INTO
    monthly_checkout (
        year,
        MONTH,
        checkouts,
        publication_year,
        usage_class_id,
        material_type_id,
        subjects
    ) (
        SELECT
            checkout_year,
            checkout_month,
            checkouts,
            publication_year,
            usage_class_id,
            material_type_id,
            subjects
        FROM
            monthly_checkouts_per_item_raw
    );

-- populate monthly checkout subject junction table
INSERT INTO
    monthly_checkout_subject (monthly_checkout_id, subject_id) (
        SELECT
            mc.id,
            s.id
        FROM
            monthly_checkout AS mc,
            subject AS s
        WHERE
            s.name IN (
                SELECT
                    unnest(string_to_array(mc.subjects, ', '))
            )
);

-- drop temporary subjects column
ALTER TABLE
    monthly_checkout DROP COLUMN subjects;