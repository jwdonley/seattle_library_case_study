-- create index on year, month of monthly_checkout table --
CREATE INDEX idx_monthly_checkout_year_month ON monthly_checkout(year, MONTH);

-- remove rows without any subjects --
DELETE FROM
    monthly_checkout mc
WHERE
    mc.subjects IS NULL;

-- clean up subjects table --
-- get number of subjects with each string length
SELECT
    char_length(name) len,
    count(*) cnt
FROM
    subject s
GROUP BY
    len
ORDER BY
    len DESC;

-- get longest subjects
SELECT
    name
FROM
    subject s
WHERE
    char_length(name) > 68
ORDER BY
    char_length(name) DESC;

-- delete subjects longer than 70
DELETE FROM
    subject
WHERE
    char_length(name) > 70;