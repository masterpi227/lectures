  #mkdir metabase-data
  docker run -d -p 3000:3000 \
  -v ${PWD}/metabase-data:/metabase-data \
  -e "MB_DB_FILE=/metabase-data/metabase.db" \
  --name metabase metabase/metabase