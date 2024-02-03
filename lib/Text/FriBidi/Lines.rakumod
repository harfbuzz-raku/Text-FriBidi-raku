unit class Text::FriBidi::Lines;

use Text::FriBidi;
also is Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Defs :types, :FriBidiFlag;

submethod TWEAK(:lines(@)!) {
    my FriBidiStrIndex $offset = 0;
    for self.text.lines(:!chomp) -> $line {
        my FriBidiStrIndex $line-len = $line.ords.elems;
        fribidi_reorder_line(self.flags, self.bidi-types, $line-len, $offset, self.direction, self.embedding-levels, self.visual, self.logical-map);
        $offset += $line-len;
    }
    self.remove-bidi-marks
        if self.flags +& FRIBIDI_FLAG_REMOVE_SPECIALS;
}
