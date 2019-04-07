# Docker Image for PHP Development

Uses `php:7.x-apache` as the base. Available build tags:

* `PHP_ENV` - Default: production. Use `development` to load development php.ini file.

    ```
    docker build --build-arg PHP_ENV=development -t stmuwsurgery/aphp:7.3-dev .
    ```

## Supported tags

* `7.3-4-prod`, `latest`
* `7.3-4-dev`
* `7.1-4-prod`
* `7.1-4-dev`
