import _sqlite3
class LoginDatabase:
    def __init__(self):
        self.con = _sqlite3.connect('mydb.db')
        self.c = self.con.cursor()

    def insert(self, uname, password):
        self.c.execute("INSERT INTO mytable VALUES ('"+uname+"','"+password+"')")
        self.con.commit()

    def exist(self, uname, password):
        ans=self.c.execute("SELECT * FROM mytable WHERE user = '"+uname+"'"+"AND pass = '"+password+"'").fetchone()
        if(ans):
            return True
        else:
            return False

    def close(self):
        self.con.close()


# Create table
#c.execute('''CREATE TABLE mytable
#            (user text, pass text)''')

# Insert a row of data
#c.execute("INSERT INTO mytable VALUES ('omri','cunio')")

# Save (commit) the changes
#con.commit()
