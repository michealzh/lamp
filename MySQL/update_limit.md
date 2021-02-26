### MySQL update with limit
```
To answer your questions in order: 1) yes, if there is no index on name. The query will end as soon as it finds the first record. take off the limit and it has to do a full table scan every time. 2) no. primary/unique keys are guaranteed to be unique. The query should stop running as soon as it finds the row.
```

- 更新where条件非主键的情况下,会全表扫描
- 更新where为主键的条件下,本身主键是唯一的,查询条件找到后会停止执行
