unit class Text::FriBidi::Line;

use Text::FriBidi;
also is Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Defs :FriBidiFlag;

submethod TWEAK(:text($)!) {
    fribidi_reorder_line(self.flags, self.bidi-types, self.elems, 0, self.direction, self.embedding-levels, self.visual, self.logical-map);
    self.remove-bidi-marks
        if self.flags +& FRIBIDI_FLAG_REMOVE_SPECIALS;
}
