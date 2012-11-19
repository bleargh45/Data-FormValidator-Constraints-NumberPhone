#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7;
use Data::FormValidator;
use Data::FormValidator::Constraints::NumberPhone qw(FV_american_phone);

###############################################################################
test_american_phone: {
    my $results = Data::FormValidator->check( {
        valid_phone            => '604-555-1212',
        valid_w_prefix         => '+1-250-555-1212',
        also_valid             => '1-778-555-1212',
        valid_out_of_country   => '441-555-1212',
        invalid_out_of_country => '441-555-1212',
        not_a_phone            => 'not a phone number',
        invalid                => '000-000-0000',
    }, {
        optional => [ qw(
            valid_phone valid_w_prefix also_valid valid_out_of_country
            invalid_out_of_country not_a_phone invalid
        ) ],
        constraint_methods => {
            valid_phone            => FV_american_phone(),
            valid_w_prefix         => FV_american_phone(),
            also_valid             => FV_american_phone(),
            valid_out_of_country   => FV_american_phone(qw( BM )),
            invalid_out_of_country => FV_american_phone(),
            not_a_phone            => FV_american_phone(),
            invalid                => FV_american_phone(),
        },
    } );

    my $valid = $results->valid;
    ok $valid->{valid_phone},          'valid North American phone';
    ok $valid->{valid_w_prefix},       'valid North American phone, w/prefix';
    ok $valid->{also_valid},           'another valid North American phone';
    ok $valid->{valid_out_of_country}, 'valid number w/explicit country code';
    ok !$valid->{invalid_out_of_country}, 'invalid; not in default countries';
    ok !$valid->{not_a_phone},            'invalid; not a telephone number';
    ok !$valid->{invalid}, 'invalid; numbers, but not a telephone number';
}
