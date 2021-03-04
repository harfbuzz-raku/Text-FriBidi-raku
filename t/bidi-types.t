use Test;
plan 4;

use Text::FriBidi::Line;
use Text::FriBidi::Raw::Defs :FriBidiType, :FriBidiPar;
my $str = "Hello 42";
my Text::FriBidi::Line $line .= new: :$str, :!brackets;

is $line.Str, 'Hello 42';
is-deeply $line.logical, utf32.new: $str.ords;
is $line.dir, +FRIBIDI_PAR_LTR, 'direction';

is-deeply $line.bidi-types.List, flat(+FRIBIDI_TYPE_LTR xx 5, +FRIBIDI_TYPE_WS, +FRIBIDI_TYPE_EN xx 2);
