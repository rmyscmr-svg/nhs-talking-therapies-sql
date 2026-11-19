"""Run every .sql file in sql/ and save each result as a CSV in results/."""
import csv
import sqlite3
from pathlib import Path

conn = sqlite3.connect("talking_therapies.db")
Path("results").mkdir(exist_ok=True)

for sql_file in sorted(Path("sql").glob("*.sql")):
    query = sql_file.read_text()
    cur = conn.execute(query)
    headers = [c[0] for c in cur.description]
    rows = cur.fetchall()
    out = Path("results") / (sql_file.stem + ".csv")
    with open(out, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(headers)
        w.writerows(rows)
    print(f"{sql_file.name}: {len(rows)} rows -> {out}")

conn.close()
