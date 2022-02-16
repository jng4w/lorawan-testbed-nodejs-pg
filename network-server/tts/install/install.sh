sudo docker-compose pull
sudo docker-compose run --rm stack is-db init
sudo docker-compose run --rm stack is-db create-admin-user --id root --email root@root.com
sudo docker-compose run --rm stack is-db create-oauth-client --id cli --name "Command Line Interface" --owner root --no-secret --redirect-uri "local-callback" --redirect-uri "code"
sudo docker-compose run --rm stack is-db create-oauth-client --id console --name "Console" --owner root --secret "secret" --redirect-uri "168.199.105.69/console/oauth/callback" --redirect-uri "/console/oauth/callback" --logout-redirect-uri "168.199.105.69/console" --logout-redirect-uri "/console"
