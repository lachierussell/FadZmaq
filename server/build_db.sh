psql -U postgres -c "CREATE DATABASE fadzmaq"
psql -U postgres -d fadzmaq -f fadzmaq/database/init.sql