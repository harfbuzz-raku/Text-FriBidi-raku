use Text::FriBidi;
unit class Text::FriBidi::Line
    is Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Raw::Defs :types;

has Blob[FriBidiStrIndex] $.map is built;

multi method COERCE(Str:D $str) {
    self.new: :$str;
}

submethod TWEAK {
    $!map .= new: 1 .. self.elems;
    fribidi_reorder_line(self.flags, self.bidi-types, self.elems, 0, self.dir, self.embedding-levels, self.visual, $!map);
}

method Str {
    self.visual.map(*.chr).join;
}
