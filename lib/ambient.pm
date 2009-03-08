package ambient;

use strict;
use warnings;
use String::Smart;

=head2 C<import>

=cut

sub import {
  my $class = shift;
  $^H{ambient} = join '_', @_;
  overload::constant( q => \&_string_constant );
}

=head2 C<unimport>

=cut

sub unimport {
  my $class = shift;
  $^H{ambient} = '';
}

sub _string_constant {
  my ( $lit, $val, $ctx ) = @_;
  my $rep = ( caller( 1 ) )[10];
  if ( my $ambient = $rep->{ambient} ) {
    return bless { rep => [ split( /_/, $ambient ) ], val => $val },
     'String::Smart';
  }
  return $val;
}

=head2 C<in_effect>

=cut

sub in_effect {
  my $level = shift // 0;
  my $hinthash = ( caller( $level ) )[10];
  return $hinthash->{ambient};
}

1;

