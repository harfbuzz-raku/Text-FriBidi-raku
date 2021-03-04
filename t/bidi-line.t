use Test;
plan 1;

constant $LRO = 0x202D.chr;
constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;

use Text::FriBidi::Line;
my $str = "Left {$RLO}Right{$PDF} {$LRO}left{$PDF}";
my Text::FriBidi::Line $line .= new: :$str, :!brackets;
is-deeply $line.Str, 'Left thgiR left';
