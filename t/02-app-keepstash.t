use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/lib";

use Test::More;
use Catalyst::Test 'KeepStash';

my $content;

$content = get('/subrequest_keepstash_index');

# Because of the way SubRequest and Catalyst interact, the first level of the stash will get copied. On return to the root request,
# the first level of the stash will remain intact. Deep datastructures will be changed by subrequests, though
like($content, qr/-------ROOT------------\nShallow value: 5\nDeep Value: 9\n/, 'Got expected values in the stash');
like($content, qr/-------1st-------------\nShallow value: 6\nDeep Value: 10\nNew Value: \n/, 'Got expected values in the 1st call');
like($content, qr/-------2nd-------------\nShallow value: 6\nDeep Value: 11\nNew Value: \n/, 'Got expected values in the 2nd call');

$content = get('/visit_keepstash_index');
like($content, qr/-------ROOT------------\nShallow value: 5\nDeep Value: 9\n/, 'Got expected values in the stash');
like($content, qr/-------1st-------------\nShallow value: 6\nDeep Value: 10\nNew Value: \n/,    'Got expected values in the 1st call');
like($content, qr/-------2nd-------------\nShallow value: 7\nDeep Value: 11\nNew Value: new\n/, 'Got expected values in the 2nd call');

done_testing;
