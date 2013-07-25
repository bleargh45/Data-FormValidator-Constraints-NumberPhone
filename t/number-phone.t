#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 10;
use Data::FormValidator;
use Data::FormValidator::Constraints::NumberPhone qw(
    FV_american_phone
    FV_telephone
);

###############################################################################
test_telephone: {
    my $results = Data::FormValidator->check( {
        valid_ca   => '604-555-1212',
        invalid_ca => '917-555-1212',   # valid, but in New York, not Canada
        valid_uk   => '+442087712924',
        invalid_uk => '+1-604-555-1212',
        invalid    => '000-000-0000',
    }, {
        optional => [ qw(
            valid_ca valid_uk
            invalid
        ) ],
        constraint_methods => {
            valid_ca   => FV_telephone(qw( ca )),
            invalid_ca => FV_telephone(qw( ca)),
            valid_uk   => FV_telephone(qw( uk )),
            invalid_uk => FV_telephone(qw( uk )),
        },
    } );

    my $valid = $results->valid;
    ok $valid->{valid_ca}, 'valid Canadian phone';
    ok $valid->{valid_uk}, 'valid phone in the United Kingdom';
    ok !$valid->{invalid_ca}, 'invalid; not a Canadian phone number';
    ok !$valid->{invalid_uk}, 'invalid; not a phone in the United Kingdom';
}

###############################################################################
test_american_phone: {
    my $results = Data::FormValidator->check( {
        valid_phone            => '604-555-1212',
        valid_w_prefix         => '+1-250-555-1212',
        also_valid             => '1-778-555-1212',
        invalid_out_of_country => '441-555-1212',
        not_a_phone            => 'not a phone number',
        invalid                => '000-000-0000',
    }, {
        optional => [ qw(
            valid_phone valid_w_prefix also_valid
            invalid_out_of_country not_a_phone invalid
        ) ],
        constraint_methods => {
            valid_phone            => FV_american_phone(),
            valid_w_prefix         => FV_american_phone(),
            also_valid             => FV_american_phone(),
            invalid_out_of_country => FV_american_phone(),
            not_a_phone            => FV_american_phone(),
            invalid                => FV_american_phone(),
        },
    } );

    my $valid = $results->valid;
    ok $valid->{valid_phone},          'valid North American phone';
    ok $valid->{valid_w_prefix},       'valid North American phone, w/prefix';
    ok $valid->{also_valid},           'another valid North American phone';
    ok !$valid->{invalid_out_of_country}, 'invalid; not in default countries';
    ok !$valid->{not_a_phone},            'invalid; not a telephone number';
    ok !$valid->{invalid}, 'invalid; numbers, but not a telephone number';
}
