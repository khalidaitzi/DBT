WITH CTE AS (
select
TO_TIMESTAMP(STARTED_AT) AS STARTED_AT,
DATE(TO_TIMESTAMP(STARTED_AT)) AS DATE_STARTED_AT,
HOUR(TO_TIMESTAMP(STARTED_AT)) AS HOUR_STARTED_AT,
{{day_type('STARTED_AT')}} AS DT,

{{get_season('STARTED_AT')}} AS ST
from
{{ source('demo', 'bike') }}
where STARTED_AT != 'started_at' and STARTED_AT != '"started_at"'
)
select 
*
from CTE