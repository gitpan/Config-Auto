use Test::More tests => 10;
use strict;
use warnings;
no warnings qw(once);

use File::Spec::Functions;

use_ok('Config::Auto');

my $config=Config::Auto::parse('vtund.conf',path => catdir('t','config'));

is($Config::Auto::Format,'bind','Config file as bind style');
is(ref($config->{default}),'HASH','Default options');
is($config->{default}->{compress}, 'zlib:2', 'Default compression');

is(ref($config->{myclientvpn}),'HASH','Client config data structure');
is($config->{myclientvpn}->{pass},'myclientpassword','Client password');
is($config->{myclientvpn}->{compress}, 'zlib:3', 'Client compression');

# Parsing of sub blocks
is(ref($config->{myclientvpn}->{up}),   'HASH', 'Sub blocks 1');
is(ref($config->{myclientvpn}->{down}), 'HASH', 'Sub blocks 2');
ok($config->{myclientvpn}->{up}->{ifconfig}, 'Sub block option');

use Data::Dumper;
print Dumper($config);

