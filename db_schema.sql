DROP TABLE IF EXISTS item_subject;

DROP TABLE IF EXISTS checkouts_per_month;

DROP TABLE IF EXISTS item;

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
    name varchar(256) NOT NULL,
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
CREATE TABLE item (
    id serial,
    usage_class_id int NOT NULL,
    material_type_id int NOT NULL,
    title varchar(750) NOT NULL,
    creator_id int,
    publisher_id int,
    publication_year varchar(32),
    PRIMARY KEY(id),
    CONSTRAINT fk_usage_class FOREIGN KEY(usage_class_id) REFERENCES usage_class(id) ON DELETE RESTRICT,
    CONSTRAINT fk_material_type FOREIGN KEY(material_type_id) REFERENCES material_type(id) ON DELETE RESTRICT,
    CONSTRAINT fk_creator FOREIGN KEY(creator_id) REFERENCES creator(id) ON DELETE SET NULL,
    CONSTRAINT fk_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(id) ON DELETE SET NULL
);

-- Create item subject table
CREATE TABLE item_subject (
    item_id int NOT NULL,
    subject_id int NOT NULL,
    PRIMARY KEY(item_id, subject_id),
    CONSTRAINT fk_item_subject_item FOREIGN KEY(item_id) REFERENCES item(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_subject_subject FOREIGN KEY(subject_id) REFERENCES subject(id) ON DELETE CASCADE,
    UNIQUE(item_id, subject_id)
);

-- Create checkouts per month table
CREATE TABLE checkouts_per_month (
    id SERIAL,
    item_id int NOT NULL,
    year int NOT NULL, 
    month int NOT NULL,
    checkouts int NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_checkouts_per_month_item FOREIGN KEY(item_id) REFERENCES item(id) ON DELETE CASCADE,
    UNIQUE(item_id, year, month)
);