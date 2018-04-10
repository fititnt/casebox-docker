# casebox-docker "All in One" Dockerfile version

- `docker-compose up --build`
- <http://127.0.0.1:80>
- <http://127.0.0.1/?uri=login>
- `docker exec -it allinone_casebox-allinone_1 bash`
- `tail -f /var/www/casebox/logs/cb_error_log`
- `tail -f  /var/log/nginx/http_casebox-access.log`
- `tail -f  /var/log/nginx/http_casebox-error.log`
<!-- - `sudo rm -rf ./data/mysql/* # THIS WILL DELETE MYSQL DATA, DO NOT DO IT IF YOU ARE NOT SURE` -->
