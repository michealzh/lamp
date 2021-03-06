- 在MySQL模糊查询like查询条件中 下划线'_' 的含义是任意一个字符,查询包含下划线的行需要转义
  - %：表示任意 0 个或多个字符。可匹配任意类型和长度的字符，有些情况下若是中文，请使用两个百分号（%%）表示。
  - _：表示任意单个字符。匹配单个任意字符，它常用来限制表达式的字符长度语句。
  - []：表示括号内所列字符中的一个（类似正则表达式）。指定一个字符、字符串或范围，要求所匹配对象为它们中的任一个。
  - [^] ：表示不在括号所列之内的单个字符。其取值和 [] 相同，但它要求所匹配对象为指定字符以外的任一个字符。
  - 查询内容包含通配符时,由于通配符的缘故，导致我们查询特殊字符 “%”、“_”、“[” 的语句无法正常实现，而把特殊字符用 “[ ]” 括起便可正常查询。
  
- 防止MySQL重复插入数据
  - insert ignore 会自动忽略数据库已经存在的数据（根据主键或者唯一索引判断），如果没有数据就插入数据，如果有数据就跳过插入这条数据。
  - replace into 首先尝试插入数据到表中， 1. 如果发现表中已经有此行数据（根据主键或者唯一索引判断）则先删除此行数据，然后插入新的数据。 2. 否则，直接插入新数据。
  - insert on duplicate key update 如果在insert into语句的末尾指定了on duplicate key update + 字段更新，则会在出现重复数据（根据主键或者唯一索引判断）的时候按照后面字段更新的描述对该信息进行更新操作。
