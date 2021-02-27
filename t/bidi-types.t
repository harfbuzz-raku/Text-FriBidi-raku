use Test;
plan 4;

use Text::FriBidi::String;
use Text::FriBidi::Raw::Defs :FriBidiType, :FriBidiPar;
my Text::FriBidi::String() $bidi-str = "Hello 42";

is $bidi-str.Str, 'Hello 42';
is-deeply $bidi-str.buf, utf32.new: "Hello 42".ords;
is $bidi-str.dir, +FRIBIDI_PAR_LTR, 'direction';

is-deeply $bidi-str.bidi-types, flat(+FRIBIDI_TYPE_LTR xx 5, +FRIBIDI_TYPE_WS, +FRIBIDI_TYPE_EN xx 2).Seq;
