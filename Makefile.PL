use inc::Module::Install;

all_from      ('lib/App/Addex/AddressBook/Apple.pm');

requires('App::Addex' => 0.007); # the EmailAddress class
requires('Encode'     => 0.000); # minimum unknown
requires('Mac::Glue'  => 0.000); # minimum unknown

extra_tests;

repository('http://github.com/rjbs/app-addex-addressbook-apple');
auto_manifest;

WriteAll();
