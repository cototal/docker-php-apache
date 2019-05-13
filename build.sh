export REV=`git rev-parse HEAD`
export IMG_NAME=$GLR/docker-php-apache:${REV:0:7}
docker build -t $IMG_NAME .
docker push $IMG_NAME
