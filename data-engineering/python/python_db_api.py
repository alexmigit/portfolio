from dmodule import connect # type: ignore

# Create connection object
connection = connect ( 'database_name' , 'username' , 'password' )

# Create a cursor object
cursor = connection.cursor ( )

# Run queries
cursor.execute( 'select * from mytable' )
results = cursor.fetchall ( )

# Free up resources
cursor.close()
connection.close()
