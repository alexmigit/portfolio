# Required libraries
from bs4 import BeautifulSoup
import requests
import pandas as pd
import sqlite3
from datetime import datetime

# Extract information
def extract(url, table_attribs):
    ''' Extracts country GDP data from the webpage and returns a DataFrame. '''
    try:
        response = requests.get(url)
        response.raise_for_status()  # Check for request errors
    except requests.RequestException as e:
        log_progress(f"Data extraction failed: {e}")
        return pd.DataFrame(columns=table_attribs)
    
    soup = BeautifulSoup(response.text, 'html.parser')
    rows = soup.find_all('tbody')[2].find_all('tr')
    data_rows = [
        {"Country": row.find_all('td')[0].a.get_text(strip=True),
         "GDP_USD_millions": row.find_all('td')[2].get_text(strip=True)}
        for row in rows if row.find_all('td') and row.find_all('td')[0].a
    ]
    
    return pd.DataFrame(data_rows, columns=table_attribs)

# Transform data
def transform(df):
    ''' Converts GDP from millions to billions and renames the column. '''
    df["GDP_USD_millions"] = (
        df["GDP_USD_millions"].str.replace(",", "").astype(float) / 1000
    ).round(2)
    return df.rename(columns={"GDP_USD_millions": "GDP_USD_billions"})

# Load data
def load_to_csv(df, csv_path):
    ''' Saves the DataFrame to a CSV file. '''
    df.to_csv(csv_path, index=False)

def load_to_db(df, sql_connection, table_name):
    ''' Saves the DataFrame as a table in the database. '''
    df.to_sql(table_name, sql_connection, if_exists='replace', index=False)

def run_query(query_statement, sql_connection):
    ''' Runs a SQL query on the database and prints the output. '''
    query_output = pd.read_sql(query_statement, sql_connection)
    print(query_output)

# Log progress
def log_progress(message):
    ''' Logs messages to a file with timestamps. '''
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open("etl_optimized_log.txt", "a") as f:
        f.write(f"{timestamp} : {message}\n")

# Main process
if __name__ == "__main__":
    url = 'https://web.archive.org/web/20230902185326/https://en.wikipedia.org/wiki/List_of_countries_by_GDP_%28nominal%29'
    table_attribs = ["Country", "GDP_USD_millions"]
    csv_path = './Users/alex/Documents/repos/edx/IBM_PY0221EN/Countries_by_GDP.csv'
    db_name = 'World_Economies.db'
    table_name = 'Countries_by_GDP'

    log_progress('Starting ETL process...')
    
    df = extract(url, table_attribs)
    if df.empty:
        log_progress("ETL process aborted due to extraction failure.")
    else:
        log_progress('Data extraction complete.')
        
        df = transform(df)
        log_progress('Data transformation complete.')
        
        load_to_csv(df, csv_path)
        log_progress('Data saved to CSV.')
        
        with sqlite3.connect(db_name) as sql_connection:
            load_to_db(df, sql_connection, table_name)
            log_progress('Data loaded to database.')

            query_statement = f"SELECT * FROM {table_name} WHERE GDP_USD_billions >= 100"
            run_query(query_statement, sql_connection)

        log_progress("ETL process completed.")
