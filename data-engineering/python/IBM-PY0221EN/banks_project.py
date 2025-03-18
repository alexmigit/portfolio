import requests
import pandas as pd
import sqlite3
from bs4 import BeautifulSoup
import logging
import time

# Exchange rate CSV path
EXCHANGE_RATE_CSV = './Documents/repos/edx/IBM_PY0221EN/exchange_rate.csv'

# Output file paths
CSV_OUTPUT_PATH = './Largest_banks_data.csv'
DB_NAME = 'Banks.db'
TABLE_NAME = 'Largest_banks'
LOG_FILE = 'code_log.txt'

# Set up logging
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def log_progress(stage):
    """Logs the progress of the code at each stage."""
    logging.info(f"Stage: {stage}")

# Task 2: Data Extraction
def extract():
    log_progress("Data extraction started")
    
    # URL for data extraction
    url = 'https://web.archive.org/web/20230908091635/https://en.wikipedia.org/wiki/List_of_largest_banks'
    
    # Fetch webpage content
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Extract table under 'By market capitalization'
    table = soup.find('table', {'class': 'wikitable'})
    df = pd.read_html(str(table))[0]  # Convert HTML table to DataFrame
    df = df[['Name', 'Market cap(US$ billion)']]  # Select relevant columns
    df.columns = ['Name', 'MC_USD_Billion']  # Rename columns for consistency
    
    log_progress("Data extraction completed")
    return df

# Task 3: Data Transformation
def transform(df):
    log_progress("Data transformation started")
    
    # Load exchange rates from the CSV file
    exchange_rates = pd.read_csv(EXCHANGE_RATE_CSV)
    usd_to_gbp = exchange_rates.loc[exchange_rates['Currency'] == 'GBP', 'Rate'].values[0]
    usd_to_eur = exchange_rates.loc[exchange_rates['Currency'] == 'EUR', 'Rate'].values[0]
    usd_to_inr = exchange_rates.loc[exchange_rates['Currency'] == 'INR', 'Rate'].values[0]

    # Add columns for MC in GBP, EUR, INR
    df['MC_GBP_Billion'] = (df['MC_USD_Billion'] * usd_to_gbp).round(2)
    df['MC_EUR_Billion'] = (df['MC_USD_Billion'] * usd_to_eur).round(2)
    df['MC_INR_Billion'] = (df['MC_USD_Billion'] * usd_to_inr).round(2)

    log_progress("Data transformation completed")
    return df

# Task 4: Load to CSV
def load_to_csv(df):
    log_progress("Saving data to CSV")
    
    # Save DataFrame to CSV
    df.to_csv(CSV_OUTPUT_PATH, index=False)
    
    log_progress("Data saved to CSV")

# Task 5: Load to SQL Database
def load_to_db(df):
    log_progress("Saving data to database")
    
    # Connect to SQLite database
    conn = sqlite3.connect(DB_NAME)
    df.to_sql(TABLE_NAME, conn, if_exists='replace', index=False)
    
    # Commit and close connection
    conn.commit()
    conn.close()
    
    log_progress("Data saved to database")

# Task 6: Execute Queries (Example)
def run_queries():
    log_progress("Running database queries")
    
    # Connect to SQLite database
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    
    # Example query: Select all data
    query = f"SELECT * FROM {TABLE_NAME} LIMIT 10"
    cursor.execute(query)
    results = cursor.fetchall()
    
    # Output results to console
    for row in results:
        print(row)
    
    conn.close()
    log_progress("Database queries executed")

# Main function to execute all tasks
def main():
    start_time = time.time()

    try:
        # Task 2: Extract data
        df = extract()

        # Task 3: Transform data
        df_transformed = transform(df)

        # Task 4: Load data to CSV
        load_to_csv(df_transformed)

        # Task 5: Load data to database
        load_to_db(df_transformed)

        # Task 6: Run queries on the database
        run_queries()
    
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        print("Error during execution, check logs for details.")
    
    end_time = time.time()
    log_progress(f"Execution completed in {end_time - start_time:.2f} seconds")

# Run the main function
if __name__ == '__main__':
    main()
