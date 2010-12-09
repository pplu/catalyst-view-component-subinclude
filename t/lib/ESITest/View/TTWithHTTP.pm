package ESITest::View::TTWithHTTP;
use Moose;

extends 'Catalyst::View::TT';
with 'Catalyst::View::Component::SubInclude';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    subinclude_plugin => 'HTTP::GET',
    subinclude => {
        'HTTP::GET' => {
            class => 'HTTP',
            http_method => 'GET',
            uri_map => {
                '/cpan/' => 'http://search.cpan.org/~',
                '/github/' => 'http://github.com/',
            },
        },
    },
);

1;
