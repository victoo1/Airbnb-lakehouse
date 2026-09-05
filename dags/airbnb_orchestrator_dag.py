from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'greystar_data_team',
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    'proptech_airbnb_pipeline',
    default_args=default_args,
    description='Automated Pipeline for Rental & Occupancy Analytics',
    schedule_interval='@monthly',
    start_date=datetime(2026, 1, 1),
    catchup=True,
    max_active_runs=1
) as dag:

    task_fetch_s3 = BashOperator(
        task_id='fetch_airbnb_to_s3',
        bash_command='python3 /app/data_ingestion/fetch_airbnb_to_s3.py {{ ds }}',
    )

    task_dbt_run = BashOperator(
        task_id='dbt_run_models',
        bash_command='cd /app/dbt_proptech && dbt run --profiles-dir .',
    )

    task_fetch_s3 >> task_dbt_run