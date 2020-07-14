# Docker Image for PHP Development

Uses `php:7.x-apache` as the base. Available build tags:

* `PHP_ENV` - Default: production. Use `development` to load development php.ini file.

    ```
    docker build --build-arg PHP_ENV=development -t cototal/php-apache:7.3-dev .
    ```

* `ML` - Default: 512M. Use `-1` for no memory limit
* `TZ` - Default: America/Chicago
