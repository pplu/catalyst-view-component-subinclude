package Catalyst::View::Component::SubInclude::HTTP;

use Moose;
use namespace::clean -except => 'meta';
use LWP::UserAgent;
use List::MoreUtils 'firstval';
use URI;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

has ua_timeout => (
    isa => 'Int', is => 'ro', default => 60,
);

has http_method => (
    isa => 'Str', is => 'ro', required => 1,
);

has base_uri => (
    isa => 'Str', is => 'ro', required => 0,
);

has uri_map => (
    isa => 'HashRef', is => 'ro', required => 0,
);

has user_agent => (
    is => 'ro', lazy => 1, builder => '_build_user_agent',
);

sub _build_user_agent {
    my $self = shift;
    return LWP::UserAgent->new(
        agent => ref($self),
        timeout => $self->ua_timeout,
    );
}

sub generate_subinclude {
    my ($self, $c, $path, $args) = @_;
    my $error_msg_prefix = "SubInclude for $path failed: ";
    my $base_uri = $self->base_uri || $c->req->base;
    my $uri_map = $self->uri_map || { q{/} => $base_uri };
    $base_uri = $uri_map->{ firstval { $path =~ s/^$_// } keys %$uri_map };
    $base_uri =~ s{/$}{};
    my $uri = URI->new(join(q{/}, $base_uri, $path));
    my $req_method = q{_} . lc $self->http_method . '_request';

    my $response;
    if ( $self->can($req_method) ) {
        $response = $self->$req_method($uri, $args);
    }
    else {
        confess $self->http_method . ' not supported';
    }
    if ($response->is_success) {
        return $response->content;
    }
    else {
        $c->log->info($error_msg_prefix . $response->status_line);
        return undef;
    }
}

sub _get_request {
    my ( $self, $uri, $args) = @_;
    $uri->query_form($args);
    return $self->user_agent->get($uri);
}

sub _post_request {
    my ( $self, $uri, $args ) = @_;
    return $self->user_agent->post($uri, $args);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Catalyst::View::Component::SubInclude::HTTP - HTTP plugin for C::V::Component::SubInclude

=head1 SYNOPSIS

In your view class:

    package MyApp::View::TT;
    use Moose;

    extends 'Catalyst::View::TT';
    with 'Catalyst::View::Component::SubInclude';

    __PACKAGE__->config(
        subinclude_plugin => 'HTTP',
        subinclude => {
            HTTP => {
                base_uri => 'http://www.foo.com/bar',
            },
        },
    );

Then, somewhere in your templates:

    [% subinclude('/my/widget') %]

=head1 DESCRIPTION

=head1 METHODS

=head2 C<generate_subinclude( $c, $path, @params )>

=head1 SEE ALSO

L<Catalyst::View::Component::SubInclude|Catalyst::View::Component::SubInclude>

=head1 AUTHOR

Wallace Reis C<< <wreis@cpan.org> >>

=head1 SPONSORSHIP

Development sponsored by Ionzero LLC L<http://www.ionzero.com/>.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2010 Wallace Reis.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
