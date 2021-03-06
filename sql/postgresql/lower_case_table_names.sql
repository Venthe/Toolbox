-- lower case table names -- the psql friendly and more reader-friendly way
SELECT 'ALTER TABLE ' || quote_ident(t.table_schema) || '.'
  || quote_ident(t.table_name) || ' RENAME TO ' || quote_ident(lower(t.table_name)) || ';' As ddlsql
  FROM information_schema.tables As t
  WHERE t.table_schema NOT IN('information_schema', 'pg_catalog') 
      AND t.table_name <> lower(t.table_name) 
  ORDER BY t.table_schema, t.table_name;
--generates something like this