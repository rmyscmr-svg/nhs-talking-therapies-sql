"""
Load the NHS Talking Therapies key measures CSV into a SQLite database.

Download the file "Monthly Time Series for Key Measures, August 2025 to August 2026"
from NHS England Digital and put it in the data/ folder first.
"""
import csv
import sqlite3
from pathlib import Path

CSV_FILE = Path("data/nhstalkingtherapies_time_series_aug_2025_aug_2026_key_measures.csv")
DB_FILE = Path("talking_therapies.db")

conn = sqlite3.connect(DB_FILE)
cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS tt_monthly")
cur.execute("""
    CREATE TABLE tt_monthly (
        period_start   TEXT,
        period_end     TEXT,
        group_type     TEXT,
        org_code1      TEXT,
        org_name1      TEXT,
        org_code2      TEXT,
        org_name2      TEXT,
        measure_id     TEXT,
        measure_name   TEXT,
        value_raw      TEXT,   -- original value, '*' means suppressed
        value          REAL    -- numeric value, NULL when suppressed
    )
""")

rows = 0
with open(CSV_FILE, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    batch = []
    for r in reader:
        raw = r["MEASURE_VALUE"].strip()
        try:
            num = float(raw)
        except ValueError:
            num = None  # '*' = small numbers hidden by NHS for privacy
        batch.append((
            r["REPORTING_PERIOD_START"], r["REPORTING_PERIOD_END"], r["GROUP_TYPE"],
            r["ORG_CODE1"], r["ORG_NAME1"], r["ORG_CODE2"], r["ORG_NAME2"],
            r["MEASURE_ID"], r["MEASURE_NAME"], raw, num,
        ))
        rows += 1
    cur.executemany("INSERT INTO tt_monthly VALUES (?,?,?,?,?,?,?,?,?,?,?)", batch)

cur.execute("CREATE INDEX idx_group_measure ON tt_monthly (group_type, measure_name)")
conn.commit()
conn.close()
print(f"Loaded {rows:,} rows into {DB_FILE}")
