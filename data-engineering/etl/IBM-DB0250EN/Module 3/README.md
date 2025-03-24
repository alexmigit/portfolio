Terminal commands...

Set AIRFLOW_HOME directory.
$ export AIRFLOW_HOME=/home/project/airflow
$ echo $AIRFLOW_HOME

Submit the DAG
$ cp my_first_dag.py $AIRFLOW_HOME/dags

List out all the existing DAGs
$ airflow dags list

Verify that my-first-python-etl-dag is a part of the output.
$ airflow dags list|grep "my-first-python-etl-dag"

Run the command below to list out all the tasks in my-first-python-etl-dag.
$ airflow tasks list my-first-python-etl-dag

Copy the DAG file into the dags directory.
$ cp ETL_Server_Access_Log_Processing.py $AIRFLOW_HOME/dags

Verify if the DAG is submitted by running the following command.
$ airflow dags list | grep etl-server-logs-dag

If the DAG didn't get imported properly, you can check the error using the following command.
$ airflow dags list-import-errors

