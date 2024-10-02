use Test;
plan 4;

use Text::FriBidi::Lines;

constant $LRO = "\c[LEFT-TO-RIGHT OVERRIDE]";
constant $RLO = "\c[RIGHT-TO-LEFT OVERRIDE]";
constant $PDF = "\c[POP DIRECTIONAL FORMATTING]";

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


