#!/bin/sh
set -e

# set env vars to defaults if not already set
if [ -z "$LOG_LEVEL" ]
  then
  export LOG_LEVEL=warn
fi

if [ -z "$LOG_FORMAT" ]
  then
  export LOG_FORMAT="%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\" %D"
fi

# validate required variables are set
if [ -z "$UspLicenseKey" ]
  then
  echo >&2 "Error: UspLicenseKey environment variable is required but not set."
  exit 1
fi

if [ -z "$REMOTE_PATH" ]
  then
  export REMOTE_PATH=remote
fi

# update configuration based on env vars
# log levels
/bin/sed "s@{{LOG_LEVEL}}@${LOG_LEVEL}@g; s@{{LOG_FORMAT}}@'${LOG_FORMAT}'@g;" /etc/apache2/conf.d/unified-origin.conf.in > /etc/apache2/conf.d/unified-origin.conf

# set up remote storage proxy config
if [ $S3_ACCESS_KEY ]
then
  REMIX_S3_ACCESS_KEY="--s3_access_key=${S3_ACCESS_KEY}"
  S3_ACCESS_KEY="S3AccessKey ${S3_ACCESS_KEY}"
fi
if [ $S3_SECRET_KEY ]
then
  REMIX_S3_SECRET_KEY="--s3_secret_key=${S3_SECRET_KEY}"
  S3_SECRET_KEY="S3SecretKey ${S3_SECRET_KEY}"
fi
if [ $S3_REGION ]
then
  REMIX_S3_REGION="--s3_region=${S3_REGION}"
  S3_REGION="S3Region ${S3_REGION}"
fi

REMIX_OPTS="${REMIX_S3_ACCESS_KEY} ${REMIX_S3_SECRET_KEY} ${REMIX_S3_REGION}"

# remote storage
if [ $REMOTE_STORAGE_URL ]
  then
  /bin/sed "s@{{REMOTE_PATH}}@${REMOTE_PATH}@g; s@{{REMOTE_STORAGE_URL}}@${REMOTE_STORAGE_URL}@g; s@{{S3_ACCESS_KEY}}@${S3_ACCESS_KEY}@g; s@{{S3_SECRET_KEY}}@${S3_SECRET_KEY}@g; s@{{S3_REGION}}@${S3_REGION}@g" /etc/apache2/conf.d/remote_storage.conf.in > /etc/apache2/conf.d/remote_storage.conf
fi


# USP license
echo $UspLicenseKey > /etc/usp-license.key

# nuke apache pidfile just in case this is an existing container that was improperly stopped and restarted
rm -f /run/apache2/httpd.pid

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  # prep all the vod2live schedules
  for smil in /var/www/unified-origin/smils/*smil
  do
    target=$(echo ${smil%.smil} | sed "s@smils/@@")
    # remix it
    unified_remix --license-key /etc/usp-license.key \
      -o ${target}.mp4 \
      ${REMIX_OPTS} \
      ${smil}
    # isml it
    mp4split --license-key /etc/usp-license.key \
      -o ${target}.isml \
      --vod2live \
      ${MP4SPLIT_OPTS} \
      ${target}.mp4
  done
  set -- httpd "$@"
fi

exec "$@"