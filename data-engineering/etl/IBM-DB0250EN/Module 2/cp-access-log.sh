# cp-access-log.sh
# This script downloads the file 'web-server-access-log.txt.gz'
# from "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/".

# The script then extracts the .txt file using gunzip.

# The .txt file contains the timestamp, latitude, longitude 
# and visitor id apart from other data.

# Transforms the text delimeter from "#" to "," and saves to a csv file.
# Loads the data from the CSV file into the table 'access_log' in PostgreSQL database.

# Download access log file
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"

# Unzip the file to extract the *.txt file.
gunzip -f web-server-access-log.txt.gz

# Extract phase
echo "Extracting data..."

# Extract the columns timestamp (1), latitude (2), longitude (3) and
# visitorid (4)
#cut -d"#" -f1-4 web-server-access-log.txt
cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt

# Transform phase
echo "Transforming data..."

# Read extracted data and replace colons with commas, and
# write to csv file
tr "#" "," < extracted-data.txt > transformed-data.csv

# Load phase
echo "Loading data..."

# Set the PostgreSQL password env var.
# Replace <yourpassword> with your actual PostgreSQL password.
export PGPASSWORD=nWgDBVIUBDgroO2pWCh4Gbu2;

# Send the instructions to connect to 'template1' and
# copy the file to the table 'access_log' through command pipeline
echo "\c template1;\COPY access_log FROM '/home/project/transformed-data.csv' DELIMITERS ',' CSV HEADER;" | psql --username=postgres --host=postgres
