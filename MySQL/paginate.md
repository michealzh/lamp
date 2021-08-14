-- 分页优化
```sql
select id, content from table_name where status = 1 order by id asc limit 1328000, 1000


--
select a2.id, a2.content from (select id from table_name where status = 1 order by id asc limit 1328000, 1000) a1, table_name a2 where a1.id=a2.id;

--

select id from table_name where id>73575000 order by id asc limit 0, 5000

--
select a2.id,a2.keyword,a2.url from (select id from table_name where id>73575000 order by id asc limit 0, 5000) a1, table_name a2 where a1.id=a2.id

--
select id,keyword,url  from table_name where id>73575000 order by id asc limit 0, 5000

```

```
limit 大分页导致慢SQL的问题原因: 随着偏移量增加需要丢弃大量无效数据,非主键需要回表
查询到ID,再根据ID查询
```
