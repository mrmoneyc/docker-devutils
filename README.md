DevUtils in Docker
==============

Usage
----------
```
$ cd my_project
$ docker run -it --rm -v ${PWD}:/my_project mrmoneyc/docker-devutils bash -c "cd /my_project; <UTILITY_COMMAND>"
$ docker run -it --rm -v ${PWD}:/my_project -w /my_project mrmoneyc/docker-devutils <UTILITY_COMMAND>
```

Utility List
----------
- [Composer](https://getcomposer.org/)
- [PHPUnit](https://phpunit.de/)
- [PHP CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- [ESLint](https://github.com/eslint/eslint)
- [Airbnb ESLint Config](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb)
- [Yarn](https://github.com/yarnpkg/yarn)
