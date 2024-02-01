use Test;
plan 4;

use Text::FriBidi::Lines;

constant $LRO = 0x202D.chr;
constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;

my @lines = "Left", "Right", "left";
my Text::FriBidi::Lines $bidi .= new: :@lines;
is-deeply $bidi.lines, ('Left', 'Right', 'left');

@lines = "Left", "{$RLO}Right{$PDF}", "{$LRO}left{$PDF}";
$bidi .= new: :@lines;
is-deeply $bidi.lines, ('Left', 'thgiR', 'left');

@lines = "{$RLO}Right{$PDF}";
$bidi .= new: :@lines;
is-deeply $bidi.lines, ('thgiR',);

enum ( :Shin<ש>, :Resh<ר>, :He<ה> );
@lines = "Sarah", "({Shin~Resh~He})";
$bidi .= new: :@lines;
is-deeply $bidi.lines, ("Sarah", "({He~Resh~Shin})");


