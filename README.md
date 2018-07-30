# cakephp3-php7-composer-xdebug
Minimalist deployment for a suitable environment for cakephp 3.x based on :
- Apache
- PHP 7.1.5
- composer (accessible globally)
- needed PHP extensions : intl, mbstring...
- xdebug-2.6.0

To run full tests, you must add dev-dependencies to your composer.json as they're zare not included in the docker image.

For instance :
```
"require-dev": {
    "phpunit/phpunit": "^5.7.14|^6.0",
    "phpunit/php-code-coverage": "5.3",
    "phpstan/phpstan": "^0.10.1",
    "cakephp/cakephp-codesniffer": "^3.0"
}
```
Please note that no Mysql server is deployed. You must add one in your CI environment if you need it.
