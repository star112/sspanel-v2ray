# export DB_PASS="P@55w0rD" # 数据库密码
read -p "输入 数据库密码: " DB_PASS

curl -sSL get.docker.com | bash
systemctl enable --now docker
docker volume create mariadb
docker run \
    --name database -d \
    -e MYSQL_ROOT_PASSWORD=$DB_PASS \
    -v mariadb:/var/lib/mysql \
mariadb:10.5.1
wget https://github.com/Anankke/SSPanel-Uim/raw/dev/sql/glzjin_all.sql

docker exec -i database sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' <<EOF
CREATE DATABASE IF NOT EXISTS sspanel CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF

docker exec -i database sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" sspanel' < glzjin_all.sql

docker run --name sspanel -d \
    --link database:db \
    -e UIM_ENV_REPLACE_ENABLE=1 \
    -e UIM_DB_HOST=db \
    -e UIM_DB_DATABASE=sspanel \
    -e UIM_DB_USERNAME=root \
    -e UIM_DB_PASSWORD=$DB_PASS \
    -p 80:80 \
    sspaneluim/panel

docker exec -i sspanel sh -c 'php xcat initQQWry'
docker exec -i sspanel sh -c 'php xcat resetTraffic'
docker exec -i sspanel sh -c 'php xcat initdownload'

docker exec -i sspanel sh -c 'php xcat createAdmin'

IP=$(curl ip.sb)
echo "通过 http://$IP 访问你的 SSPanel"