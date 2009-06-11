package Email::MIME::Kit::Renderer::MicroMason;

=head1 NAME

Email::MIME::Kit::Renderer::MicroMason - Render parts of your mail with Text::MicroMason

=cut

use Moose;
with 'Email::MIME::Kit::Role::Renderer';
use Text::MicroMason;

our $VERSION = '1.000';

=head1 SYNOPSIS

To use MicroMason in your mkit use something like:

    {
      "renderer": "MicroMason",
      "header": [
        { "From": "WY Corp <noreplies@wy.example.com" },
        { "To": "<% $ARGS{recruit}->email %>" },
        { "Subject": "Welcome aboard, <% ARGS{recruit}->name %>" }
      ],
      "alternatives": [
        { "type": "text/plain", "path": "body.txt" },
         {
          "type": "text/html",
          "path": "body.html",
          "container_type": "multipart/related",
          "attachments": [ { "type": "image/jpeg", "path": "logo.jpg" } ]
        }
      ]
    }

Then in your email templates (body.txt and body.html) you can do:

    <%args>
    $recruit
    $cid_for
    </%args>

    <& "root/emails/includes/header.msn", %ARGS &>

    <p>
    Dear <% $recruit->name %>,
    </p>

    <p>
    Welcome to WY Corp.
    </p>

    <& "root/emails/includes/footer.msn", %ARGS &>

Any components included with <& ... &> will be relative to the applications
current directory (not the template file, which would be nice but difficult
given how EMK passes the template as strings rather than references to files).

=head1 DESCRIPTION

This renderer for L<Email::MIME::Kit> uses L<Text::MicroMason> to enable
you to write your mkits using basic Mason syntax. See
L<Text::MicroMason::HTMLMason> for details on the syntax.

This is based on L<Text::MicroMason> rather than the full blown L<HTML::Mason>
because L<HTML::Mason> is focused on directories and files and 
L<Email::MIME::Kit> prefers to work with strings. L<Text::MicroMason> 
accommodates this and is a bit smaller than it's big brother.

=head2 METHODS

=over 4

=item render()

    render( $content_ref, $stash )

Called by L<Email::MIME::Kit::Renderer> to parse template strings
($content_ref) with L<Text::MicroMason> and return a plain text string.

=back

=cut

sub render {
    my ( $self, $content_ref, $stash ) = @_;
    $stash ||= {};

    # require Data::Dump; import Data::Dump; dd @_;

    ## It would be nice to make any <& &> relative paths, relative to
    ## the *.mkit dir rather than where the script was run

    my $outbuf = $self->mason->execute( text => $$content_ref, %$stash );

    # ddx $outbuf;
    return \$outbuf;
}

has mason => (
    is       => 'ro',
    ## isa      => 'Text::MicroMason',
    lazy     => 1,
    init_arg => undef,
    default  => sub {
        Text::MicroMason->new();
    },
);

no Moose;
1;

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Mark V. Grimes, E<lt>E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Mark Grimes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

This is basically just Ricardo SIGNES' L<EMK::Renderer::TestRenderer> with
basic integration of L<Text::MicroMason>. Thanks to Ricardo for the
excellent EMK package.

=cut
