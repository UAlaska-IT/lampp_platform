# LAMPP Platform Cookbook

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

This cookbook configures a stack consisting of Linux, Apache, MariaDB and PostgreSQL (LAMPP).
Apache is configured using the [http_platform cookbook](https://github.com/ualaska-it/http_platform).

## Requirements

### Chef

This cookbook requires Chef 14+

### Platforms

Supported Platform Families:

* Debian
  * Ubuntu, Mint
* Red Hat Enterprise Linux
  * Amazon, CentOS, Oracle

Platforms validated via Test Kitchen:

* Ubuntu
* CentOS

### Dependencies

This cookbook does not constrain its dependencies because it is intended as a utility library.
It should ultimately be used within a wrapper cookbook.

## Resources

This cookbook provides no custom resources.

## Recipes

### lampp_platform::default

This recipe configures a webserver and database.

### lampp_platform::restore

If a both a local database is configured and backups are configured,
this recipe will restore the database from the latest snapshot.
Otherwise does nothing.

## Attributes

### default

### app

### database

### install

## Examples

This is an application cookbook; no custom resources are provided.
See recipes and attributes for details of what this cookbook does.

## Development

See CONTRIBUTING.md and TESTING.md.
