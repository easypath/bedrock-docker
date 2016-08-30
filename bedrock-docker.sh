#!/bin/bash
# Copyright EasyPath IT Solutions Inc.
# Usage bedrock-docker.sh <domain_name>

# Clone latest Bedrock Docker
git clone https://github.com/easypath/bedrock-docker.git $1 && rm -rf $1/.git

# Clone latest Bedrock
git clone --depth=1 https://github.com/roots/bedrock.git $1/site && rm -rf $1/site/.git

# WordPress database connection details
DB_FILE=.env
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=password
DB_HOST=db:3306
WP_ENV=development
WP_HOME=http://localhost:8080

# Rename Bedrock sample database connection file
mv $1/site/.env.example $1/site/$DB_FILE

# Update connection details
sed -i -e "s,DB_NAME=database_name,DB_NAME=$DB_NAME,g" $1/site/$DB_FILE
sed -i -e "s,DB_USER=database_user,DB_USER=$DB_USER,g" $1/site/$DB_FILE
sed -i -e "s,DB_PASSWORD=database_password,DB_PASSWORD=$DB_PASSWORD,g" $1/site/$DB_FILE
sed -i -e "s,DB_HOST=database_host,DB_HOST=$DB_HOST,g" $1/site/$DB_FILE
sed -i -e "s,WP_ENV=development,WP_ENV=$WP_ENV,g" $1/site/$DB_FILE
sed -i -e "s,WP_HOME=http://example.com,WP_HOME=$WP_HOME,g" $1/site/$DB_FILE

# Delete backup file
rm $1/site/$DB_FILE-e

# Run Docker build
(cd $1 && docker-compose up --build -d)
