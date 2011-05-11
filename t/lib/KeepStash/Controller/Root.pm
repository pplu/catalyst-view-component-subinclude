package KeepStash::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub subrequest_keepstash_index : Path('subrequest_keepstash_index') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{'stash_value'} = 5;
    $c->stash->{'deep'}->{'stash_value'} = 9;
}

sub visit_keepstash_index : Path('visit_keepstash_index') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{'stash_value'} = 5;
    $c->stash->{'deep'}->{'stash_value'} = 9;
}

sub keepstash_call : Path('keepstash_call') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{'stash_value'}++;
    $c->stash->{'deep'}->{'stash_value'}++;
}

sub end : ActionClass('RenderView') {}

1;
