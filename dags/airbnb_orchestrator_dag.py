from datetime import datetime, timedelta
from airflow import DAG
try:
    from airflow.providers.standard.operators.bash import BashOperator
except ImportError:
    from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

DBT_PROJECT_DIR = "/workspaces/Airbnb-lakehouse/dbt_proptech"

with DAG(
    dag_id='airbnb_lakehouse_orchestrator',
    default_args=default_args,
    description='Automated pipeline for Airbnb Lakehouse (Bronze -> Silver -> Gold)',
    schedule='@daily',
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=['dbt', 'snowflake', 'lakehouse'],
) as dag:

    dbt_run_task = BashOperator(
        task_id='dbt_run_pipeline',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --profiles-dir .',
    )

    dbt_test_task = BashOperator(
        task_id='dbt_test_quality',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --profiles-dir .',
    )

    dbt_run_task >> dbt_test_task
