use Test;
plan 10;

use Text::FriBidi;
use Text::FriBidi::Defs :FriBidiFlag;
use Text::FriBidi::Line;

constant $RLO = 0x202E.chr;
constant $PDF = 0x202C.chr;
constant $LAM   = "\c[ARABIC LETTER LAM]";
constant $LAM_I = "\c[ARABIC LETTER LAM INITIAL FORM]";
constant $HAH   = "\c[ARABIC LETTER HAH]";
constant $HAH_F = "\c[ARABIC LETTER HAH FINAL FORM]";

note "Running FriBidi version {Text::FriBidi.lib-version} (Text::FriBidi version {Text::FriBidi.^ver})";

my $text = "Left {$RLO}(Right){$PDF} {$LAM~$HAH}";

for (
    0 => "Left {$RLO}{$HAH~$LAM} {$PDF})thgiR(",
    (FRIBIDI_FLAG_SHAPE_MIRRORING) => "Left {$RLO}{$HAH~$LAM} {$PDF}(thgiR)",
    (FRIBIDI_FLAG_SHAPE_MIRRORING +| FRIBIDI_FLAG_REMOVE_SPECIALS) => "Left {$HAH~$LAM} (thgiR)",
    (FRIBIDI_FLAG_SHAPE_MIRRORING +| FRIBIDI_FLAG_REMOVE_SPECIALS) => "Left {$HAH~$LAM} (thgiR)",
    (FRIBIDI_FLAG_SHAPE_MIRRORING +| FRIBIDI_FLAG_REMOVE_SPECIALS +| FRIBIDI_FLAG_SHAPE_ARAB_PRES) => "Left {$HAH_F~$LAM_I} (thgiR)",
     ) {
    my $flags = .key;
    my Text::FriBidi::Line $line .= new: :$text, :$flags;
    is $line.flags, +$flags;
    is-deeply $line.Str, .value;
}

