package KeepStash::View::TT;
use Moose;

extends 'Catalyst::View::TT';
with 'Catalyst::View::Component::SubInclude';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    subinclude_plugin => 'SubRequest',
    subinclude_plugin => 'Visit',
    subinclude => {
        'SubRequest' => {
            keep_stash => 1
        },
        'Visit' => {
            keep_stash => 1
        }
    },
);

1;
