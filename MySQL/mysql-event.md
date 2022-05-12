- add events

```mysql
-- ref:https://stackoverflow.com/questions/21196613/run-a-mysql-query-as-a-cron-job
SET GLOBAL event_scheduler = ON;

CREATE EVENT name_of_event
ON SCHEDULE EVERY 1 DAY
STARTS '2014-01-18 00:00:00'
DO
DELETE FROM tbl_message WHERE DATEDIFF( NOW( ) ,  timestamp ) >=7;
```

- show events

```mysql
-- ref:https://stackoverflow.com/questions/9057525/how-do-i-see-all-mysql-events-that-are-running-on-my-database
SHOW EVENTS FROM test;

```
