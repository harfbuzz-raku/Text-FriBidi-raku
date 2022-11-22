use Test;
plan 8;

use Text::FriBidi::Line;
use Text::FriBidi::Defs :FriBidiType, :FriBidiPar;

my $text = "Hello 42";
my Text::FriBidi::Line $line .= new: :$text;

is $line.Str, 'Hello 42';
is-deeply $line.logical, utf32.new: $text.ords;
is $line.direction, +FRIBIDI_PAR_LTR, 'direction';

is-deeply $line.bidi-types.List, flat(+FRIBIDI_TYPE_LTR xx 5, +FRIBIDI_TYPE_WS, +FRIBIDI_TYPE_EN xx 2);

enum ( :Shin<ש>, :Resh<ר>, :He<ה> );
$text = "Sarah ({Shin~Resh~He})";
$line .= new: :$text;
is $line.elems, 11;
is $line[7], He;
my $visual = $line.Str;
is-deeply $visual, "Sarah ({He~Resh~Shin})";
is-deeply $line.bidi-types.List, flat(+FRIBIDI_TYPE_LTR xx 5, +FRIBIDI_TYPE_WS, +FRIBIDI_TYPE_ON, +FRIBIDI_TYPE_RTL xx 3, +FRIBIDI_TYPE_ON);
