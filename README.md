# LAMPP Platform Cookbook

[![License](https://img.shields.io/github/license/ualaska-it/lamp_platform.svg)](https://github.com/ualaska-it/lampp_platform)
[![GitHub Tag](https://img.shields.io/github/tag/ualaska-it/lamp_platform.svg)](https://github.com/ualaska-it/lampp_platform)
[![Build status](https://ci.appveyor.com/api/projects/status/03muohyy9hlfuu5w/branch/master?svg=true)](https://ci.appveyor.com/project/UAlaska/lampp-platform/branch/master)

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

This cookbook configures a stack consisting of Linux, Apache, MariaDB and PostgreSQL (LAMPP).
Apache is configured using the [http_platform cookbook](https://github.com/ualaska-it/http_platform).
The databases are configured using the [database_application cookbook](https://github.com/ualaska-it/database_application).

A PHP application is deployed from an archive.

## Requirements

### Chef

This cookbook requires Chef 14+.

### Platforms

Supported Platform Families:

* Debian
  * Ubuntu, Mint
* Red Hat Enterprise Linux
  * Amazon, CentOS, Oracle
* Fedora

Platforms validated via Test Kitchen:

* Ubuntu
* Debian
* CentOS
* Fedora

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

* `node['lampp_platform']['database_host']`.
Defaults to `'localhost'`.
The host at which the database is located.
If equal to `'localhost'`, servers and databases are installed per attributes of the [database_application cookbook](https://github.com/ualaska-it/database_application).
Otherwise, only database clients are installed.

* `node['lampp_platform']['base_name']`.
Defaults to `nil`.
The name used for scoping the application and name directories.
Must be set or an exception is raised.

Note that `node['http_platform']['apache']['mpm_module']` is set to `'prefork'` to support PHP.

### app

* `node['lampp_platform']['app']['archive']['download_base_url']`.
Defaults to `nil`.
The URL of the directory from which to fetch the application archive.
Must be set or an exception is raised.

* `node['lampp_platform']['app']['archive']['download_file_link']`.
Defaults to `nil`.
The URL slug of the download.
If nil, defaults to download_file_name.

* `node['lampp_platform']['app']['archive']['download_file_name']`.
Defaults to `nil`.
The archive file to be downloaded.
Must be set or an exception is raised.

* `node['lampp_platform']['app']['archive']['extract_root_directory']`.
Defaults to `nil`.
The name of the directory created by extracting the archive. 
Must be set or an exception is raised.

* `node['lampp_platform']['app']['archive']['extract_creates_file']`.
Defaults to `nil`.
The relative path to a file that is created by extraction.
Used for idempotence.
Must be set or an exception is raised.

* `node['lampp_platform']['app']['sync']['exclude_paths']`.
Defaults to `[]`.
Set of paths to exclude when the application code is synced from the download to the library location.
Commonly used to avoid clobbering in-source configuration files.

* `node['lampp_platform']['app']['serve_path']`.
Defaults to `nil`.
The path at which the application is served.
For example, 'wiki' or 'app'.
The URL of the application will then be 'https://host.domain/serve_path'.
See the [mediawiki_application cookbook](https://github.com/calsev/mediawiki_application) for an example of configuring redirects, rewrites, and pretty URLs.
Must be set or an exception is raised.

* `node['lampp_platform']['app_updated']`.
Defaults to `false`.
Set to true in a recipe if the application repo changed.
Can be used to gate non-idempotent configuration code.

### install

For some operations, like installing mod_php, the version of PHP on the system must be known.
This will be the version in the standard repos for Debian- and Fedora-based systems, and the version provided by EPEL+IUS on RHEL-based distros.
The defaults match the latest repos when this cookbook was updated, but will need to be set for older or newer distros.

* `node['lampp_platform']['install']['debian_php_version']`.
Defaults to `'7.2'`.
The version of PHP installed on Debian-based distros.

* `node['lampp_platform']['install']['rhel_php_version']`.
Defaults to `'7.3'`.
The version of PHP to install on RHEL- or Fedora-based distros.

## Examples

This is an application cookbook; no custom resources are provided.
See recipes and attributes for details of what this cookbook does.

See test/cookbooks/test_harness for example usage of this cookbook.
See the [mediawiki_application cookbook](https://github.com/calsev/mediawiki_application) for a more full-fledged example.

## Development

See CONTRIBUTING.md and TESTING.md.
