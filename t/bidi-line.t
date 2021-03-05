use Test;
plan 1;

use Text::FriBidi;
use Text::FriBidi::Line;

constant $LRO = 0x202D.chr;
constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;

note "Running FriBidi version {Text::FriBidi.lib-version} (Text::FriBidi version {Text::FriBidi.^ver})";

my $str = "Left {$RLO}Right{$PDF} {$LRO}left{$PDF}";
my Text::FriBidi::Line $line .= new: :$str, :!brackets;
is-deeply $line.Str, 'Left thgiR left';
