#!/usr/bin/env sh

# from https://github.com/Drivetech/mongodump-s3
# Environment variables to set
# MONGO_USER
# MONDO_PASSWORD
# MONGO_SERVER
# MONGO_SERVER_PORT
# MONGO_DB_NAME
# S3_BUCKET
# S3_PATH

BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"
CERT_FILE="/usr/local/bin/rds-combined-ca-bundle.pem"

rm -rf "/backup/${MONGO_DB_NAME}"

# Run backup
mongodump --archive \
  --ssl \
  --uri "mongodb://${MONGO_USER}:${MONDO_PASSWORD}@${MONGO_SERVER}:${MONGO_SERVER_PORT}/?tls=true&tlsCAFile=${CERT_FILE}&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false" \
	--out="/backup/dump/${MONGO_DB_NAME}" \
	--db="${MONGO_DB_NAME}"

# Compress backup
cd "/backup/${MONGO_DB_NAME}" && tar -cvzf "${BACKUP_NAME}" dump
# Upload backup
aws s3 cp "/backup/${MONGO_DB_NAME}/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
# Delete temp files
rm -rf "/backup/${MONGO_DB_NAME}/dump"
