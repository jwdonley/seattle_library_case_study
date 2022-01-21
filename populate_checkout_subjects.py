import psycopg2
import hidden
import sys

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'], 
        user=secrets['user'], 
        password=secrets['pass'], 
        connect_timeout=3)

cur = conn.cursor()

# get max id
sql = '''
    SELECT max(mcs.monthly_checkout_id)
    FROM monthly_checkout_subject mcs;
'''

print('get max monthly checkout id:', sql)
cur.execute(sql)

row = cur.fetchone()

max_id = row[0]
print('max id = ', max_id)

if max_id is None:
    max_id = 1

limit = 300000

# get monthly_checkout rows
sql = '''
    SELECT mc.id, mc.subjects
    FROM monthly_checkout mc 
    ORDER BY mc.id 
    OFFSET %s
    LIMIT %s
'''

#print('get monthly checkout rows:', sql)
cur.execute(sql, (max_id, limit))


# go through results and store subjects in junction table
results = cur.fetchall()

subject_cache = {}
skippable_subjects = {"",}

rowsNotCommitted = 0

for result in results:
    monthly_checkout_id = result[0]
    subjects = result[1].split(', ')
    for subject in set(subjects):
        if subject in skippable_subjects:
            continue

        if subject not in subject_cache.keys():
            # get subject_id from db
            sql = '''
                SELECT id
                FROM subject
                WHERE name = %s;
            '''
            #print('get subject id:', sql)
            try:
                cur.execute(sql, (subject,))
            except:
                print(sql, subject)
                sys.exit()

            row = cur.fetchone()
            if row is None: #if subject does not exist, add to set of skippable subjects
                skippable_subjects.add(subject)
                continue
            else:
                subject_cache[subject] = row[0]
        
        sql = '''
            INSERT INTO monthly_checkout_subject (monthly_checkout_id, subject_id)
            VALUES (%s, %s)
        '''
        #print(monthly_checkout_id, '-', subject, '-', subject_cache[subject])
        try:
            cur.execute(sql, (monthly_checkout_id, subject_cache[subject]))
        except:
            continue
    
    rowsNotCommitted += 1

    if rowsNotCommitted > 25:
        conn.commit()
        #print('--commit--')
        rowsNotCommitted = 0
        
print(len(subject_cache))
conn.commit()
cur.close()