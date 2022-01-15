DROP TABLE IF EXISTS monthly_checkout_subject;

DROP TABLE IF EXISTS monthly_checkout;

DROP TABLE IF EXISTS usage_class;

DROP TABLE IF EXISTS material_type;

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

-- Create subject table
CREATE TABLE subject (
    id serial,
    name varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

-- Create monthly checkouts per item table
CREATE TABLE monthly_checkout (
    id serial,
    year INT NOT NULL,
    month INT NOT NULL,
    checkouts INT NOT NULL,
    publication_year INT,
    usage_class_id INT NOT NULL,
    material_type_id INT NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_usage_class FOREIGN KEY(usage_class_id) REFERENCES usage_class(id) ON DELETE RESTRICT,
    CONSTRAINT fk_material_type FOREIGN KEY(material_type_id) REFERENCES material_type(id) ON DELETE RESTRICT
);

-- Create item subject table
CREATE TABLE monthly_checkout_subject (
    monthly_checkout_id int NOT NULL,
    subject_id int NOT NULL,
    PRIMARY KEY(monthly_checkout_id, subject_id),
    CONSTRAINT fk_monthly_checkout_subject FOREIGN KEY(monthly_checkout_id) REFERENCES monthly_checkout(id) ON DELETE CASCADE,
    CONSTRAINT fk_subject_monthly_checkout FOREIGN KEY(subject_id) REFERENCES subject(id) ON DELETE CASCADE,
    UNIQUE(monthly_checkout_id, subject_id)
);