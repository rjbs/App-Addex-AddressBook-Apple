use strict;
use warnings;

use inc::Module::Install;

all_from      ('lib/App/Addex/AddressBook/Apple.pm');

requires('App::Addex' => 0.007); # the EmailAddress class
requires('Encode'     => 0.000); # minimum unknown
requires('Mac::Glue'  => 0.000); # minimum unknown

WriteAll();
