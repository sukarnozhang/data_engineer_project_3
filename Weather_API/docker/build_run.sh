docker build -t extended_airflow .

docker run -p 8080:8080 -v C:\Users\ranis\Weather_ELT_Snowflake_Airbyte_Airflow\Weather_API\airflow:/opt/airflow extended_airflow:latest standalone