use strict;
use warnings;

use inc::Module::Install;

name          ('App-Addex-AddressBook-Apple');
author        ('Ricardo Signes <rjbs@cpan.org>');
license       ('perl');
version_from  ('lib/App/Addex/AddressBook/Apple.pm');

requires('App::Addex'                => 0.007); # the EmailAddress class
requires('Mac::Glue'                 => 0.000); # minimum unknown

WriteAll();
