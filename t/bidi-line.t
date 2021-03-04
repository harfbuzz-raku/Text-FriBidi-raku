use Test;
plan 1;

constant $LRO = 0x202D.chr;
constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;

use Text::FriBidi::Line;
my Text::FriBidi::Line() $line = "Left {$RLO}Right{$PDF} {$LRO}left{$PDF}";
use Text::FriBidi::Raw::Defs :types, :FriBidiFlag, :FriBidiMask;
is-deeply $line.Str, 'Left thgiR left';
