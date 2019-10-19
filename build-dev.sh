export REV=`git rev-parse HEAD`
export IMG_NAME=cototal/php-apache:${REV:0:7}-dev
docker build --build-arg PHP_ENV=development -t $IMG_NAME .
docker push $IMG_NAME
