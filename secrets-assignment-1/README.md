# Deploy Stack + Secrets + External

First we need to create the secrets which will be provided by docker cli:

```
echo "my_db_user" | docker secret create psql_user -
echo "my_db_pass" | docker secret create psql_pass -
```

Than we can create the deploy using the secrets (check docker-compose.yml file).

```
docker stack deploy -c docker-compose.yml drupal_stack
```