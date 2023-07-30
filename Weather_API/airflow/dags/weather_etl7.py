import datetime
import pendulum
from textwrap import dedent

from airflow import DAG
from airflow.operators.bash import BashOperator



with DAG(
        dag_id='weather_etl7',
        schedule_interval='0 0 * * *',
        start_date=pendulum.datetime(2022, 1, 1, tz="UTC"),
        catchup=False,
        render_template_as_native_obj=True,
        dagrun_timeout=datetime.timedelta(minutes=5),
        tags=['weather'],
) as dag:
        dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="cp -R /opt/airflow/dags/dbt /tmp;\
    cd /tmp/dbt/AIRBYTE_SNOWFLAKE;\
    /usr/local/airflow/dbt_env/bin/dbt deps;\
    /usr/local/airflow/dbt_env/bin/dbt build --project-dir /tmp/dbt/AIRBYTE_SNOWFLAKE/ --profiles-dir . --target dev;\
    cat /tmp/dbt_logs/dbt.log",
    )

