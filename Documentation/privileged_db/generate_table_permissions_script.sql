SELECT   CONCAT('GRANT ALL ON ', 'tabemr.',TABLE_NAME, ' to ''tabemr''@''localhost'';')
FROM     INFORMATION_SCHEMA.TABLES
WHERE    TABLE_SCHEMA = 'tabemr' and NOT TABLE_NAME='users_secure';
