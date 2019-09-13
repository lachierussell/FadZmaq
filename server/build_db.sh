echo "SELECT 'CREATE DATABASE fadzmaq' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'fadzmaq')\gexec" | psql -U postgres
psql -U postgres -d fadzmaq -f fadzmaq/database/init.sql