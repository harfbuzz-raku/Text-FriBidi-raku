use Test;
plan 2;

use Text::FriBidi::String;
my $str = "Hello";
my Text::FriBidi::String() $bidi-str = "Hello";

is $bidi-str.Str, 'Hello';
is-deeply $bidi-str.buf, utf32.new: "Hello".ords;