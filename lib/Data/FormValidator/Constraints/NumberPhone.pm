package Data::FormValidator::Constraints::NumberPhone;

###############################################################################
# Required inclusions;
use strict;
use warnings;
use Number::Phone;

###############################################################################
# Version number.
our $VERSION = '0.02';

###############################################################################
# Allow our methods to be exported.
use base qw(Exporter);
use vars qw(@EXPORT_OK);
our @EXPORT_OK = qw(
    FV_american_phone
);

###############################################################################
# Subroutine:   FV_american_phone()
###############################################################################
# Creates a constraint closure that returns true if the constrained value
# appears to be a valid North American telephone number.
#
# Accepts an optional list of Country Codes, specifying which countries that
# participate in the North American Numbering Plan (NANP) should be considered
# valid.  By default, only Canada and the United States are considered valid.
sub FV_american_phone {
    my @countries = @_;

    # Default set of countries to be considered "North America"; Canada, US.
    unless (@countries) {
        @countries = qw( CA US );
    }

    # Return closure.
    return sub {
        my $dfv = shift;
        my $val = $dfv->get_current_constraint_value;

        # Add leading "+" if it looks like we've got a long distance prefix
        $val = "+$val" if ($val =~ /^\s*1/);

        # Try to instantiate this as a North American phone number; if it
        # doesn't come back, its not a valid number.
        my $phone = Number::Phone->new(US => $val);
        return 0 unless (defined $phone);

        # Verify that its a North American number; Canada, US only.
        return 1 if (grep { $_ eq $phone->country } @countries);
        return 0;
    }
}

1;

=head1 NAME

Data::FormValidator::Constraints::NumberPhone - Data constraints, using Number::Phone

=head1 SYNOPSIS

  use Data::FormValidator::Constraints::NumberPhone qw(FV_american_phone);

  constraint_methods => {
      phone        => FV_american_phone(),
      canada_phone => FV_american_phone(qw( CA )),
  },

=head1 DESCRIPTION

This module implements methods to help validate data using
C<Data::FormValidator> and C<Number::Phone>.

=head1 METHODS

=over

=item B<FV_american_phone()>

Creates a constraint closure that returns true if the constrained value
appears to be a valid North American telephone number.

Accepts an optional list of Country Codes, specifying which countries that
participate in the North American Numbering Plan (NANP) should be
considered valid. By default, only Canada and the United States are
considered valid.

=back

=head1 AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

=head1 COPYRIGHT

Copyright (C) 2012, Graham TerMarsch.  All Rights Reserved.

=head1 SEE ALSO

L<Data::FormValidator>,
L<Number::Phone>.

=cut
