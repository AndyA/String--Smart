#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib';
use String::Smart qw( add_rep as plain );
use Data::Dumper;
use HTML::Tiny;

$| = 1;

add_rep reversed => sub { reverse shift }, sub { reverse shift };

add_rep
  uri => sub { HTML::Tiny->new->url_encode( shift ) },
  sub { HTML::Tiny->new->url_decode( shift ) };

my $backward = as reversed => "Hello, World";

my $forward = plain $backward;

print Dumper( { backward => $backward, forward => $forward } );

my $u_backward = as uri => $backward;
my $u_forward  = as uri => $forward;

print Dumper( { u_backward => $u_backward, u_forward => $u_forward } );

my $ru_backward = as reversed_uri => $backward;
my $ru_forward  = as reversed_uri => $forward;

print Dumper( { ru_backward => $ru_backward, ru_forward => $ru_forward } );

print "$ru_backward\n$ru_forward\n";

print Dumper( [ plain $ru_backward, plain $ru_forward ] );
