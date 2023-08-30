import psycopg2

def connect_to_database():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="DataScience",
            user="your_username",
            password="your_password"
        )
        return conn
    except:
        print("Unable to connect to database.")


def get_algorithm_names():
    """Get the names of all algorithms in the database.

    Returns:
        List of names of all algorithms in the database.
    """
    conn = connect_to_database()
    cur = conn.cursor()
    cur.execute("SELECT \"Algorithm Name\" FROM Algorithm LIMIT 1000")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [row[0] for row in rows]

def search_algorithm_name():
    rows = fetch_algorithm_data()
    for row in rows:
        if "Sequential Patterns" in row[0]:
            return row[1]
