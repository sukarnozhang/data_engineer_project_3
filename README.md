# Weatherstack
To provide meaningful insights to weather changes based on different parameters such as humidity, temperature, pressure, weather codes and wind speed.

# Workflow
Extraction of datasets
The datasets are extracted from https://weatherstack.com/documentation.

Airbyte is used to connect to API.
For Destination, the airbyte is destined to deliever the source dataset to Snowflake and Kafka(Confluent) through running of commands to access the Snowflake.

## Solution Architecture
![image](https://github.com/minneymickey2006/Weather_ELT_Snowflake_Airbyte_Airflow/assets/55056612/ea89dbbb-777e-4efc-8ffc-7399d42b93ed)

## Setup Steps
1. Set up Airbyte-specific entities in Snowflake
1. Set up Airbyte-specific entities in Snowflake
```sql
-- set variables (these need to be uppercase)
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';

-- set user password
set airbyte_password = 'password';

begin;

-- create Airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role SYSADMIN;

-- create Airbyte user
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;

grant role identifier($airbyte_role) to user identifier($airbyte_username);

-- change role to sysadmin for warehouse / database steps
use role sysadmin;

-- create Airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;

-- create Airbyte database
create database if not exists identifier($airbyte_database);

-- grant Airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);

-- grant Airbyte database access
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

commit;

begin;

USE DATABASE identifier($airbyte_database);

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($airbyte_schema);

commit;

begin;

-- grant Airbyte schema access
grant OWNERSHIP
on schema identifier($airbyte_schema)
to role identifier($airbyte_role);

commit;
```



2. To create user for the connection to Kafka
```sql
--create user and role
CREATE USER confluent2 RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1V+WROjik7v1oDRJxHa0Tl7ejtKm4SjuJ2qBiHKq06ja5mR977xmWorjeqNPLJ5Qkxwa+PDW6iXUTmZXyo/y7XCP/LXvYf1d4wphEU/PVLygnneqQAoVck09eiHSl/dgFNKbYlT3w+ko1Su+iZwYo7k2HonI4845hlUhe0MwoA3d2biwSMdWS5/WSOoxCUpYj/+kzKURLu4GmkJftpriYhNnLPnUrS6bUhfF8XJS0qa+AvVv/J96W5gIhXP3FFDGePjtrS+4bGAg/rpGu0w+X/7oVGNjo35cKO0R78mmk7c431pU3QHAvQZTgemSVaG6QFnRnC47uaulbWBIwjFT/QIDAQAB';
create role kafka_connector_role2;

--grant usage
grant usage on database AIRBYTE_DATABASE to role kafka_connector_role2;AIRBYTE_DATABASE.AIRBYTE_SCHEMA.WEATHERSTACK_CURRENT_WEATHER_CURRENT
grant usage on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create table on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create stage on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create pipe on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;

--grant role
grant role kafka_connector_role2 to user confluent2;
grant role kafka_connector_role2 to role ACCOUNTADMIN;

--alter user
alter user confluent2 set default_role=kafka_connector_role2;

```


2. Data Transformation
The datasets are extracted and loaded into the snowflake.The snowflake is loaded with adventure_works datasets with AIRBYTE_DATABASE as Database and AIRBYTE_SCHEMA as  Schema with tables.

##Data Build Tool(DBT):
The loaded datasets on Snowflake are made connection with DBT working environment through updation of profiles.yml

## Steps:
For connection with editor. Update the profiles.yml file in the dbt with credentials. airbyte_snowflake: outputs: dev: type: snowflake threads: 1 account:{{Snowflake user account specification}} user: AIRBYTE_USER password: password role: AIRBYTE_ROLE warehouse: AIRBYTE_WAREHOUSE database: AIRBYTE_DATABASE schema: AIRBYTE_SCHEMA target: dev

-- RUN the "dbt deps" command to initiate connection with Snowflake.

For transformation process, the aim of the project to get better insights into current and forecast weather table. The different transformations applied on the tables and join together to get better quality transformed data.

## Report generation through transformations applied:
# Airbyte_data
The dataset contains california weather dataset.
{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}

select
    country,
    lat,
    lon,
    name,
    region,
    _airbyte_california_current_weather_hashid
from
    {{ source("AIRBYTE_SCHEMA","CALIFORNIA_CURRENT_WEATHER_LOCATION") }}


with weather_current_forecast as(
    select
        Current_Humidity,
        Current_Pressure,
        Current_Temperature,
        Current_Wind_Speed,
        Country,
        Forecasted_Humidity,
        Forecasted_Pressure,
        Forecasted_Temperature,
        Forecasted_Wind_Speed,
        localtime
    from
        {{ref('cal_weather_current_forecast_location')}}
)

select
    distinct (Current_Humidity-Forecasted_Humidity) as Difference_Humidity,
    (Current_Pressure-Forecasted_Pressure) as Difference_Pressure,
    (Current_Temperature-Forecasted_Temperature) as Difference_Temperature,
    (Current_Wind_Speed-Forecasted_Wind_Speed) as Difference_Wind_Speed,
    localtime as localtime
from
    weather_current_forecast
    limit 50

-Joining current weather forecast with 

with weather_current as(
    select
        CloudCover,
        FeelsLike,
        Humidity,
        Observation_Time,
        Precip,
        Pressure,
        Temperature,
        UV_Index,
        Visibility,
        Weather_Code,
        Wind_Degree,
        Wind_Dir,
        Wind_Speed,
        _AIRBYTE_CURRENT_HASHID 
    from {{ref('stg_weather_current')}}
)
,weather_location as(
    select
        country,
        lat,
        Lon,
        Name,
        Region,
        localtime,
        _AIRBYTE_CALIFORNIA_CURRENT_WEATHER_HASHID
    from {{ref('stg_weather_current_location')}}
)

## Kafka Jakarta Dataset
select
    distinct c.Humidity,
    c.Pressure,
    c.Temperature,
    c.Wind_Speed,
    c.Wind_Dir,
    l.country,
    l.lat,
    l.lon,
    l.Name,
    l.Region,
    l.localtime
from weather_current as c
cross join weather_location as l

##with weather_code as (
    select
        weathercode as weather_code,
        condition as weather_condition
    from
        {{ref('weather_codes')}}
),

avg_weather as (
    select
        average_cloudcover,
        average_precipitation,
        average_pressure,
        average_temperature,
        average_wind_speed,
        average_feelslike,
        average_humidity,
        average_visibility,
        average_weather_code
    from
        {{ref('jakarta_kafka_average')}}
)

select
    average_cloudcover,
    average_precipitation,
    average_pressure,
    average_temperature,
    average_wind_speed,
    average_feelslike,
    average_humidity,
    average_visibility,
    weather_code.weather_code,
    weather_code.weather_condition
from
    avg_weather
inner join weather_code
    on avg_weather.average_weather_code = weather_code.weather_code

-- Joining max_weather with averagw weather
with weather_code as (
    select
        weathercode as weather_code,
        condition as weather_condition
    from
        {{ref('weather_codes')}}
),

max_weather as (
    select
        max_cloudcover,
        max_precipitation,
        max_pressure,
        max_temperature,
        max_wind_speed,
        max_feelslike,
        max_humidity,
        max_visibility,
        max_weather_code
    from
        {{ref('jakarta_kafka_max')}}
)

select
    max_cloudcover,
    max_precipitation,
    max_pressure,
    max_temperature,
    max_wind_speed,
    max_feelslike,
    max_humidity,
    max_visibility,
    weather_code.weather_code,
    weather_code.weather_condition
from
    max_weather
inner join weather_code
    on max_weather.max_weather_code = weather_code.weather_code
The various transformations applied are:
(a) count
(b) alias
(c) cross join operation
(d) group by
(e) sum
(f) where
(f) Macro definition

## DBT Seeds
In the seeds, weather_codes.csv is added to interpret the weather codes are interpreted with weather descriptions of type of weather, so the different transformed models of 'california' and 'jakarta' are joined for better interpretation.

## DBT Snapshots
{% snapshot snp_weather_current %}

{{
    config(
        target_schema='AIRBYTE_SCHEMA',
        strategy='check',
        unique_key='_AIRBYTE_CURRENT_HASHID',
        check_cols='all'
    )
}}

    select * from {{ ref('stg_weather_current') }}

{% endsnapshot %}

## DBT tests

Singular and Generic both tests are performed along with built in functions for tests as Null and Unique.

## DockerFile
To deploy work on the cloud platform, Docker File is defined outside the Dbt folder as:
FROM ghcr.io/dbt-labs/dbt-snowflake:1.2.0

COPY AIRBYTE_SNOWFLAKE/ .

COPY docker/run_commands.sh .

ENTRYPOINT ["/bin/bash", "run_commands.sh"]

## Secrets configuration
.env file is defined to hold the secret credential.


## Deployment on Cloud Platform
Installation of Airbyte, Setup Environment
1.	To connect to your instance, run the following command on your local terminal:
SSH_KEY=/Users/sukarno.zhanggmail.com/Desktop/group1_project3_v4/airbyte.pem
chmod 400 $SSH_KEY 
ssh -i $SSH_KEY ec2-user@13.251.241.228

2.	To install Docker, run the following command in your SSH session on the instance terminal:
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker $USER

3.	To install docker-compose, run the following command in your ssh session on the instance terminal:
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir airbyte && cd airbyte
wget https://raw.githubusercontent.com/airbytehq/airbyte-platform/main/{.env,flags.yml,docker-compose.yaml}
docker-compose up -d

Download Airbyte
1.	Connect to your instance:
ssh -i /Users/sukarno.zhanggmail.com/Desktop/group1_project3_v4/airbyte.pem ec2-ec2-ec2-user@13.251.241.228
2.	Install Airbyte:
mkdir airbyte && cd airbyte
wget https://raw.githubusercontent.com/airbytehq/airbyte-platform/main/{.env,flags.yml,docker-compose.yaml}
docker compose up -d

Connect to Airbyte
1.	Create an SSH tunnel for port 8000:
SSH_KEY=/Users/sukarno.zhanggmail.com/Desktop/group1_project3_v4/airbyte.pem
ssh -i $SSH_KEY -L 8000:localhost:8000 -N -f ec2-user@13.251.241.228
2.	Visit http://localhost:8000 to verify the deployment.

## Continuous Integration using Github Actions
Inside the .github contains the integration.yml file to trigger the integration of the steps through Actions and running the workflow.
-- sqlfluff , sqllint are used to debug the code and fix it.

## Running Airflow Locally (PATH="Weather_API\airflow")
1. Inside the docker folder, build_run.sh contains 
(a) docker build -t extended_airflow .

(b) docker run -p 8080:8080 -v /$(pwd):/opt/airflow extended_airflow:latest standalone

Run the airflow locally using, localohost:8080 on web browser and signing using 'admin' as user and password inside the 'pwd' directory in file as standalone_admin_password.txt.

Inside, the present working directory 'dags/dbt' folder is created with inside the 'AIRBYTE_SNOWFLAKE' dbt folder.
The airflow weather_etl7 for running the dags are in same level as dbt to trigger the dbt dag working.

## Semantic Analysis through Power BI

Different visualisations are prepared by Power BI to make better insights into the models generated through DBT.


