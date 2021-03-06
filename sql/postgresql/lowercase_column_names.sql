-- As David Fetter kindly pointed out, this looks cleaner, returns one record per ddl and is more psql friendly
SELECT  'ALTER TABLE ' || quote_ident(c.table_schema) || '.'
  || quote_ident(c.table_name) || ' RENAME "' || c.column_name || '" TO ' || quote_ident(lower(c.column_name)) || ';' As ddlsql
  FROM information_schema.columns As c
  WHERE c.table_schema NOT IN('information_schema', 'pg_catalog') 
      AND c.column_name <> lower(c.column_name) 
  ORDER BY c.table_schema, c.table_name, c.column_name;