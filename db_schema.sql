DROP TABLE IF EXISTS stat_subject;

DROP TABLE IF EXISTS monthly_checkouts_per_item;

DROP TABLE IF EXISTS usage_class;

DROP TABLE IF EXISTS material_type;

DROP TABLE IF EXISTS creator;

DROP TABLE IF EXISTS publisher;

DROP TABLE IF EXISTS subject;

-- Create usage class table
CREATE TABLE usage_class (
    id serial,
    name varchar(10) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);

-- Create material type table 
CREATE TABLE material_type (
    id serial,
    name varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

-- Create creator table 
CREATE TABLE creator (
    id serial,
    name varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

-- Create publisher table
CREATE TABLE publisher (
    id serial,
    name varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

-- Create subject table
CREATE TABLE subject (
    id serial,
    name varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

-- Create monthly checkouts per item table
CREATE TABLE monthly_checkouts_per_item (
    id serial,
    usage_class_id int NOT NULL,
    material_type_id int NOT NULL,
    checkout_year int NOT NULL,
    checkout_month int NOT NULL,
    checkouts int NOT NULL,
    title varchar(750) NOT NULL,
    creator_id int,
    publisher_id int,
    publication_year varchar(32),
    PRIMARY KEY(id),
    CONSTRAINT fk_usage_class FOREIGN KEY(usage_class_id) REFERENCES usage_class(id) ON DELETE RESTRICT,
    CONSTRAINT fk_material_type FOREIGN KEY(material_type_id) REFERENCES material_type(id) ON DELETE RESTRICT,
    CONSTRAINT fk_creator FOREIGN KEY(creator_id) REFERENCES creator(id) ON DELETE
    SET
        NULL,
        CONSTRAINT fk_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(id) ON DELETE
    SET
        NULL
);

-- Create item subject table
CREATE TABLE stat_subject (
    stat_id int NOT NULL,
    subject_id int NOT NULL,
    PRIMARY KEY(stat_id, subject_id),
    CONSTRAINT fk_stat FOREIGN KEY(stat_id) REFERENCES monthly_checkouts_per_item(id) ON DELETE CASCADE,
    CONSTRAINT fk_subject FOREIGN KEY(subject_id) REFERENCES subject(id) ON DELETE CASCADE,
    UNIQUE(stat_id, subject_id)
);