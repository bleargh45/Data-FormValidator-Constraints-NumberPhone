# NAME

Data::FormValidator::Constraints::NumberPhone - Data constraints, using Number::Phone

# SYNOPSIS

```perl
use Data::FormValidator::Constraints::NumberPhone qw(FV_american_phone);

constraint_methods => {
    phone        => FV_american_phone(),
    canada_phone => FV_american_phone(qw( CA )),
},
```

# DESCRIPTION

This module implements methods to help validate data using
`Data::FormValidator` and `Number::Phone`.

# METHODS

- FV\_american\_phone()

    Creates a constraint closure that returns true if the constrained value
    appears to be a valid North American telephone number (Canada, or US)

- FV\_telephone(@countries)

    Creates a constraint closure that returns true if the constrained value
    appears to be a valid telephone number.

    REQUIRES a list of Country Codes (e.g. "CA", "US", "UK"), to specify which
    countries should be considered valid. By default, \*NO\* countries are
    considered valid (and thus, no numbers are considered valid by default).

# AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

# COPYRIGHT

Copyright (C) 2012, Graham TerMarsch.  All Rights Reserved.

# SEE ALSO

[Data::FormValidator](https://metacpan.org/pod/Data%3A%3AFormValidator),
[Number::Phone](https://metacpan.org/pod/Number%3A%3APhone).
