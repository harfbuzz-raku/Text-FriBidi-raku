use Text::FriBidi;
unit class Text::FriBidi::Line
    is Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Defs :FriBidiFlag;

submethod TWEAK {
    fribidi_reorder_line(self.flags, self.bidi-types, self.elems, 0, self.direction, self.embedding-levels, self.visual, self.logical-map);
    if self.flags +& FRIBIDI_FLAG_REMOVE_SPECIALS {
        my $len := fribidi_remove_bidi_marks(self.visual, self.elems, self.logical-map, self.visual-map, self.embedding-levels);
        self.visual .= subbuf(0, $len)
            if $len ~~ 0 ..^ self.visual.elems;
    }
}
