unit class Text::FriBidi::Line;

use Text::FriBidi;
also is Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Defs :types, :FriBidiFlag;

submethod TWEAK(:text($)!, FriBidiFlags :$flags = FRIBIDI_FLAGS_DEFAULT +| FRIBIDI_FLAGS_ARABIC) {
    my FriBidiStrIndex $offset = 0;
    fribidi_reorder_line(
        $flags,
        self.bidi-types,
        self.elems,
        $offset,
        self.direction,
        self.embedding-levels,
        self.visual,
        self.logical-map);
    self.remove-bidi-marks
        if $flags +& FRIBIDI_FLAG_REMOVE_SPECIALS;
}
