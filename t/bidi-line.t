use Test;
plan 4;

use Text::FriBidi::Line;

constant $LRO = 0x202D.chr;
constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;

my $text = "Left {$RLO}Right{$PDF} {$LRO}left{$PDF}";
my Text::FriBidi::Line $line .= new: :$text;
is-deeply $line.Str, 'Left thgiR left';

$text = "{$RLO}Right{$PDF}\n";
$line .= new: :$text;
is-deeply $line.Str, "thgiR\n";

enum ( :Shin<ש>, :Resh<ר>, :He<ה> );
$text = "Sarah ({Shin~Resh~He})";
$line .= new: :$text;
is-deeply $line.Str, "Sarah ({He~Resh~Shin})";

$text = "Sarah\n({Shin~Resh~He})";
$line .= new: :$text;
is-deeply $line.lines, ("Sarah", "({He~Resh~Shin})");
