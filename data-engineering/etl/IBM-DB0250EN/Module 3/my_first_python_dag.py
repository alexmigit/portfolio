# Begin importing libraries...
from datetime import timedelta
# DAG object --> instantiate DAG
from airflow.models import DAG
# Operators --> write tasks
from airflow.operators.python import PythonOperator
# Scheduling
from airflow.utils.dates import days_ago

# Define paths
input_file = '/etc/passwd'
extracted_file = 'extracted-data.txt'
transformed_file = 'transformed.txt'
output_file = 'data_for_analytics.csv'

def extract():
    global input_file
    print("Inside Extract")
    # Read the contents of file into string
    with open(input_file, 'r') as infile, \
            open(extracted_file, 'w') as outfile:
        for line in infile:
            fields = line.split(':')
            if len(fields) >= 6:
                field_1 = fields[0]
                field_3 = fields[2]
                field_6 = fields[5]
                outfile.write(field_1 + ":" + field_3 + ":" + "\n")

def transform():
    global extracted_file, transformed_file
    print("Inside Transform")
    with open(extracted_file, 'r') as infile, \
            open(transformed_file, 'w') as outfile:
        for line in infile:
            processed_line = line.replace(':', ',')
            outfile.write(processed_line + '\n')

def load():
    global transformed_file, output_file
    print("Inside Load")
    # Save array to CSV
    with open(transformed_file, 'r') as infile, \
            open(output_file, 'w') as outfile:
        for line in infile:
            outfile.write(line + '\n')

def check():
    global output_file
    print("Inside Check")
    # Save array to CSV
    with open(output_file, 'r') as infile:
        for line in infile:
            print(line)

# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'Your name',
    'start_date': days_ago(0),
    'email' : ['your email'],
    'retries': 1,
    'relay_delay': timedelta(minutes=5),
}
# Define the DAG
dag = DAG(
    'my-first-python-etl-dag',
    default_args=default_args,
    description='My first DAG',
    schedule_interval=timedelta(days=1),
)
# Call the `extract` f(x)
execute_extract = PythonOperator(
    task_id='extract',
    python_callable=extract,
    dag=dag,
)
# Call the `transform` f(x)
execute_transform = PythonOperator(
    task_id='transform',
    python_callable=transform,
    dag=dag,
)
# Call the `load` f(x)
execute_load = PythonOperator(
    task_id='load',
    python_callable=load,
    dag=dag,
)
# Call the `load` f(x)
execute_check = PythonOperator(
    task_id='check',
    python_callable=check,
    dag=dag,
)

# Task pipeline
execute_extract >> execute_transform >> execute_load >> execute_check
