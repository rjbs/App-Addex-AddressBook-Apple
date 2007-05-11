#!/usr/bin/perl
use strict;
use warnings;

package App::Addex::AddressBook::Apple;
use base qw(App::Addex::AddressBook);

use App::Addex::Entry::EmailAddress;

use Mac::Glue qw(:glue);

=head1 NAME

App::Addex::AddressBook::Apple - use Apple Address Book as the addex source

=head1 VERSION

version 0.005

  $Id$

=cut

our $VERSION = '0.005';

=head1 SYNOPSIS

This module implements the L<App::Addex::AddressBook> interface for Mac OS X's
Address Book application, using L<Mac::Glue> to get entries from the address
book.

=cut

sub _glue {
  return $_[0]->{_abook_glue} ||= Mac::Glue->new("Address_Book");
}

sub _demsng {
  return if ! $_[1] or $_[1] eq 'msng';
  return $_[1];
}

sub _entrify {
  my ($self, $person) = @_;

  return unless my @emails = map {
    App::Addex::Entry::EmailAddress->new({
      address => $self->_demsng($_->prop('value')->get),
      label   => $self->_demsng($_->prop('label')->get),
    });
  } $person->prop("email")->get;

  my %fields;
  if (my $note = scalar $self->_demsng($person->prop('note')->get)) {
    ($fields{folder}) = $note =~ /^folder:\s*(\S+)$/sm;
    ($fields{sig})    = $note =~ /^sig:\s*(\S+)$/sm;
  }

  my $name;

  if (my $fname = $self->_demsng($person->prop('first name')->get)) {
    my $mname  = $self->_demsng($person->prop('middle name')->get) || '';
    my $lname  = $self->_demsng($person->prop('last name')->get)   || '';
    my $suffix = $self->_demsng($person->prop('suffix')->get)      || '';

    $name = $fname
          . (length $mname  ? " $mname"  : '')
          . (length $lname  ? " $lname"  : '')
          . (length $suffix ? " $suffix" : '');
  } else {
    $name  = $self->_demsng($person->prop('name')->get);
  }

  return App::Addex::Entry->new({
    name   => $name,
    nick   => scalar $self->_demsng($person->prop('nickname')->get),
    emails => \@emails,
    fields => \%fields,
  });
}

sub entries {
  my ($self) = @_;

  my @entries = map { $self->_entrify($_) } $self->_glue->prop("people")->get;
}

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2006-2007 Ricardo Signes, all rights reserved.

This program is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
