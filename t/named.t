use Test::More tests => 17;
use strict;
use warnings;
no warnings qw(once);

use File::Spec::Functions;

use_ok('Config::Auto');

my $config=Config::Auto::parse('named.conf',path => catdir('t','config'));

is($Config::Auto::Format,'bind','Config file as bind style');
is(ref($config->{options}),'HASH','default options');
is(ref($config->{options}->{forwarders}), 'ARRAY', 'forwarders is a list');
ok(exists $config->{options}->{'statistics-file'},'sanity check on generic options');
ok(exists $config->{options}->{'dump-file'},'sanity check on generic options');
is($config->{options}->{'directory'},'"/var/named"', 'sanity check on generic options');

ok(exists $config->{'key "rndckey"'}, 'keys hash');
ok(exists $config->{'key "rndckey"'}->{algorithm}, 'algorithm option of key block');
is($config->{'key "rndckey"'}->{algorithm}, 'hmac-md5', 'algorithm option ok');

ok(exists $config->{zones}, 'zones "meta" configuration found');
ok(exists $config->{zones}->{q(domain.com)}, 'domain.com zone found');
is($config->{q(zone "domain.com")}->{type}, 'slave', 'domain.com zone sanity checks');
is(ref($config->{q(zone "domain.com")}->{masters}), 'ARRAY', 'domain.com zone sanity checks');
is($config->{q(zone "domain.com")}->{masters}->[0], '192.168.1.1', 'domain.com zone sanity checks');
is(ref($config->{zones}->{q(domain.com)}->{masters}), 'ARRAY', 'indirect lookup via "zones" data structure');
is($config->{zones}->{q(domain.com)}->{masters}->[0], '192.168.1.1', 'indirect lookup via "zones" data structure');

use Data::Dumper;
print Dumper($config);

