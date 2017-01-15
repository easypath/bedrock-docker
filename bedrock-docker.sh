#!/bin/bash
# Copyright The D. GmbH
# Usage bedrock-docker.sh <domain_name>

# Clone latest Bedrock Docker
git clone https://github.com/thedgmbh/bedrock-docker.git $1 && rm -rf $1/.git

# Clone latest Bedrock
git clone --depth=1 https://github.com/roots/bedrock.git $1/site && rm -rf $1/site/.git

# Read user wordpress connection input
echo "Enter your database name [ENTER]: "
read -r db_name
echo "Enter your database username [ENTER]: "
read -r db_user
echo "Enter your database password [ENTER]: "
read -r db_pass
echo "Enter your database prefix [ENTER]: "
read -r db_prefix

# WordPress database connection details
DB_FILE=.env
DB_NAME=$db_name
DB_USER=$db_user
DB_PASSWORD=$db_pass
DB_HOST=db:3306
DB_PREFIX=$db_prefix
WP_ENV=development
WP_HOME=http://localhost:8080

# Rename Bedrock sample database connection file
mv $1/site/.env.example $1/site/$DB_FILE

# Update connection details
sed -i -e "s,DB_NAME=database_name,DB_NAME=$DB_NAME,g" $1/site/$DB_FILE
sed -i -e "s,DB_USER=database_user,DB_USER=$DB_USER,g" $1/site/$DB_FILE
sed -i -e "s,DB_PASSWORD=database_password,DB_PASSWORD=$DB_PASSWORD,g" $1/site/$DB_FILE
sed -i -e "s,# DB_HOST=localhost,DB_HOST=$DB_HOST,g" $1/site/$DB_FILE
sed -i -e "s,# DB_PREFIX=wp_,DB_PREFIX=$DB_PREFIX,g" $1/site/$DB_FILE
sed -i -e "s,WP_ENV=development,WP_ENV=$WP_ENV,g" $1/site/$DB_FILE
sed -i -e "s,WP_HOME=http://example.com,WP_HOME=$WP_HOME,g" $1/site/$DB_FILE

# Delete backup file
rm $1/site/$DB_FILE-e

# Run Docker build
(cd $1 && docker-compose up --build -d)
