-- MONTHLY CHECKOUTS PER SUBJECT REPORT
-- create table to hold monthly checkouts per subjects report
CREATE TABLE report_monthly_checkouts_per_subject (
    id serial,
    year int NOT NULL,
    MONTH int NOT NULL,
    subject varchar(256) NOT NULL,
    checkouts int NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(year, MONTH, subject)
);

-- populate report
INSERT INTO
    report_monthly_checkouts_per_subject (year, MONTH, subject, checkouts) (
        SELECT
            MAX(mc."year"),
            MAX(mc."month"),
            MAX(s."name") AS subject,
            SUM(mc.checkouts) AS checkouts
        FROM
            monthly_checkout mc
            INNER JOIN monthly_checkout_subject mcs ON mc.id = mcs.monthly_checkout_id
            INNER JOIN subject s ON s.id = mcs.subject_id
        GROUP BY
            mc."year",
            mc."month",
            mcs.subject_id
        ORDER BY
            mc."year" DESC,
            mc."month" DESC,
            checkouts DESC
    );

-- MONTHLY CHECKOUTS PER MEDIA REPORT
-- create table
CREATE TABLE report_monthly_checkouts_per_media (
    id serial,
    year int NOT NULL,
    MONTH int NOT NULL,
    media varchar(256) NOT NULL,
    checkouts int NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(year, MONTH, media)
);

-- populate report
INSERT INTO
    report_monthly_checkouts_per_media (year, MONTH, media, checkouts) (
        SELECT
            max(mc.year),
            max(mc.month),
            max(mt."name"),
            sum(mc.checkouts) AS checkouts
        FROM
            monthly_checkout mc
            INNER JOIN material_type mt ON mc.material_type_id = mt.id
        GROUP BY
            mc.year,
            mc."month",
            mc.material_type_id
        ORDER BY
            mc."year" DESC,
            mc."month" DESC,
            checkouts DESC
    );

-- MONTHLY FICTION VS NON-FICTION
SELECT
    *
FROM
    report_monthly_checkouts_per_subject rmcps
WHERE
    rmcps.subject IN ('Fiction', 'Nonfiction')
ORDER BY
    rmcps."year" DESC,
    rmcps."month" DESC,
    rmcps.subject;

-- MONTHLY CHECKOUTS PER SUBJECT AND MEDIA
-- create table
CREATE TABLE report_monthly_checkouts_per_subject_and_media (
    id serial,
    year int NOT NULL,
    MONTH int NOT NULL,
    media varchar(256) NOT NULL,
    subject varchar(256) NOT NULL,
    checkouts int NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(year, MONTH, media)
);

-- populate report
INSERT INTO
    report_monthly_checkouts_per_subject_and_media (year, MONTH, media, subject, checkouts) (
        SELECT
            max(mc.year),
            max(mc.month),
            max(mt.name) AS media,
            max(s.name) AS subject,
            sum(mc.checkouts) AS checkouts
        FROM
            monthly_checkout mc
            INNER JOIN monthly_checkout_subject mcs ON mcs.monthly_checkout_id = mc.id
            INNER JOIN subject s ON s.id = mcs.subject_id
            INNER JOIN material_type mt ON mc.material_type_id = mt.id
        GROUP BY
            mc."year",
            mc."month",
            mc.material_type_id,
            mcs.subject_id
        ORDER BY
            mc."year" DESC,
            mc."month" DESC,
            media DESC,
            checkouts DESC
    );

-- MONTHLY EBOOK VS PRINT
SELECT
    *
FROM
    report_monthly_checkouts_per_media rmcpm
WHERE
    media IN ('BOOK', 'EBOOK')
ORDER BY
    year DESC,
    MONTH DESC,
    media;

-- create tables to hold top subjects
CREATE TABLE fiction_subject (
    id serial,
    name varchar(256),
    PRIMARY KEY(id),
    UNIQUE(name)
);

CREATE TABLE nonfiction_subject (
    id serial,
    name varchar(256),
    PRIMARY KEY(id),
    UNIQUE(name)
);

INSERT INTO
    fiction_subject (name)
VALUES
    ('literature'),
    ('romance'),
    ('thriller'),
    ('fantasy'),
    ('mystery'),
    ('historical fiction'),
    ('juvenile fiction'),
    ('suspense'),
    ('humor (fiction)'),
    ('juvenile literature'),
    ('science fiction'),
    ('graphic novels'),
    ('young adult fiction'),
    ('picture books'),
    ('cartoons and comics'),
    ('young adult literature'),
    ('classic literature'),
    ('lgbtqia+ (fiction)'),
    ('humorous stories'),
    ('short stories'),
    ('stories in rhyme'),
    ('domestic fiction'),
    ('horror'),
    ('humorous fiction'),
    ('fantasy comics'),
    ('psychological fiction'),
    ('love stories'),
    ('adventure and adventurers fiction'),
    ('adventure stories'),
    ('erotic literature'),
    ('science fiction & fantasy'),
    ('paranormal fiction');

INSERT INTO
    nonfiction_subject (name)
VALUES
    ('biography & autobiography'),
    ('history'),
    ('self-improvement'),
    ('sociology'),
    ('business'),
    ('psychology'),
    ('politics'),
    ('science'),
    ('cooking & food'),
    ('family & relationships'),
    ('health & fitness'),
    ('cookbooks'),
    ('religion & spirituality'),
    ('essays'),
    ('new age'),
    ('humor (nonfiction)'),
    ('mythology'),
    ('nature'),
    ('autobiographies'),
    ('medical'),
    ('biographies'),
    ('philosophy'),
    ('juvenile nonfiction'),
    ('military'),
    ('sports & recreations'),
    ('literary criticism'),
    ('performing arts'),
    ('travel'),
    ('true crime'),
    ('self help'),
    ('economics'),
    ('folklore'),
    ('reference'),
    ('art'),
    ('finance'),
    ('nonfiction comics'),
    ('language arts'),
    ('technology'),
    ('instructional and educational works'),
    ('crafts'),
    ('home design & décor'),
    ('music'),
    ('computer technology'),
    ('recipes'),
    ('guidebooks'),
    ('anecdotes'),
    ('education'),
    ('lgbtqia+ (nonfiction)'),
    ('songs'),
    ('handbooks and manuals'),
    ('cooking'),
    ('spanish language materials'),
    ('law'),
    ('cooking natural foods'),
    ('gardening'),
    ('baking'),
    ('pets'),
    ('careers'),
    ('mathematics'),
    ('quick and easy cooking');

-- MONTHLY CHECKOUTS FOR TOP FICTION SUBJECTS
SELECT
    max(rmcps."year"),
    max(rmcps."month"),
    max(lower(rmcps.subject)) AS subject,
    sum(rmcps.checkouts) AS checkouts
FROM
    report_monthly_checkouts_per_subject rmcps
WHERE
    lower(rmcps.subject) IN (
        SELECT
            fs.name
        FROM
            fiction_subject fs
    )
GROUP BY
    rmcps."year",
    rmcps."month",
    subject
ORDER BY
    rmcps."year" DESC,
    rmcps."month" DESC,
    checkouts DESC;

-- MONTHLY CHECKOUTS FOR TOP NONFICTION SUBJECTS

SELECT
    max(rmcps."year"),
    max(rmcps."month"),
    max(lower(rmcps.subject)) AS subject,
    sum(rmcps.checkouts) AS checkouts
FROM
    report_monthly_checkouts_per_subject rmcps
WHERE
    lower(rmcps.subject) IN (
        SELECT
            fs.name
        FROM
            nonfiction_subject fs
    )
GROUP BY
    rmcps."year",
    rmcps."month",
    subject
ORDER BY
    rmcps."year" DESC,
    rmcps."month" DESC,
    checkouts DESC;