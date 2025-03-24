# import libraries
from datetime import timedelta
# DAG object for initiation
from airflow import DAG
# Task operators
from airflow.operators.bash_operator import BashOperator
# Scheduling
from airflow.utils.dates import days_ago

# defining DAG arguments
default_args = {
    'owner': 'your name',
    'start_date': days_ago(0),
    'email': [ 'your email' ],
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

# defining the DAG
dag = DAG(
    'dummy_dag',
    default_args=default_args,
    description='My first DAG',
    schedule_interval=timedelta(minutes=1),
)

# define tasks
task1 = BashOperator(
    task_id='task1',
    bash_command='sleep 1',
    dag=dag,
)
task2 = BashOperator(
    task_id='task2',
    bash_command='sleep 2',
    dag=dag,
)
task3 = BashOperator(
    task_id='task3',
    bash_command='sleep 3',
    dag=dag,
)

# task pipeline
task1 >> task2 >> task3