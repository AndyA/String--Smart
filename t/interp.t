use strict;
use warnings;
use Test::More tests => 6;
use String::Smart qw( :all );

{
    my %ENT_MAP = (
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
        '"' => '&quot;',
        "'" => '&apos;',
    );

    sub entity_encode {
        my $str = shift;
        $str =~ s/([<>&'"])/$ENT_MAP{$1}/eg;
        return $str;
    }
}

add_rep html => \&entity_encode, undef;
add_rep reversed => sub { reverse shift }, sub { reverse shift };

{
    my $html = already html => "<html>";
    is "$html", '<html>', 'stringify';
    my $amp = $html . '&';
    is "$amp", '<html>&amp;', 'concat ok';
    my $doc = $amp . ( already html => '</html>' );
    isa_ok $doc, 'String::Smart';
    is "$doc", '<html>&amp;</html>', 'concat 2 ok';
}

{
    my $html = already html => '';
    my $doc = "$html&<>";
    is "$doc", '&amp;&lt;&gt;', 'interp ok';
}

{
    my $doc  = '';
    my $doc2 = '';

    {
        use ambient qw(html);
        my $amp = amp();
        my $br  = '<br />';
        $doc  = "<html>$amp$br</html>";
        $doc2 = "$doc$amp";
    }

    # isa_ok $doc,  'String::Smart';
    # isa_ok $doc2, 'String::Smart';

    is "$doc", '<html>&amp;<br /></html>', 'ambient ok';
    # is "$doc2", '<html>&amp;<br /></html>&amp;', 'ambient ok 2';
}

sub amp { '&' }
