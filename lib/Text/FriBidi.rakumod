unit class Text::FriBidi:ver<0.0.1>;

use Text::FriBidi::Raw;
use Text::FriBidi::Raw::Defs :types, :FriBidiFlag;

has Str:D $.str is required;
has FriBidiParType $.dir is rw;
has FriBidiFlags $.flags = FRIBIDI_FLAGS_DEFAULT +| FRIBIDI_FLAGS_ARABIC;
has utf32 $.logical is built handles<elems>;
has Buf[uint32] $.visual is built;
has uint8 $.max-level is built;
has Buf[FriBidiCharType] $.bidi-types is built;
has Buf[FriBidiCharType] $.bracket-types is built;
has Buf[FriBidiLevel]    $.embedding-levels is built;
has Buf[FriBidiStrIndex] $.logical-map is built;
has Buf[FriBidiStrIndex] $.visual-map is built;
has Bool $.shape = True;
has UInt $.api = self.lib-version >= v1.0.0 ?? 1 !! 0;

submethod TWEAK(Bool :$brackets = True) {
    self!build-logical;
    self!build-bidi-types;
    $!dir ||= fribidi_get_par_direction($!bidi-types, self.elems);
    if $!api >= 1 {
        self!build-bracket-types;
        self!build-embedding-levels-ex;
    }
    else {
        self!build-embedding-levels;
    }
    $!visual .= new: $!logical;
    self!shape if $!shape;
}

multi method COERCE(Str:D $str) {
    self.new: :$str;
}

method !build-logical {
    $!logical .= new: $!str.ords;
    $!logical-map .= new: 0 ..^ $!logical.elems;
}

method !build-bidi-types {
    $!bidi-types .= allocate: self.elems;
    fribidi_get_bidi_types($!logical, $.elems, $!bidi-types);
}

method !build-bracket-types {
    $!bracket-types .= allocate: self.elems;
    fribidi_get_bracket_types($!logical, $.elems, $!bidi-types, $!bracket-types);
}

method !build-embedding-levels {
    $!embedding-levels .= allocate: self.elems;
    $!max-level = fribidi_get_par_embedding_levels($!bidi-types, self.elems, $!dir, $!embedding-levels);
    $!max-level--;
}

method !build-embedding-levels-ex {
    $!embedding-levels .= allocate: self.elems;
    $!max-level = fribidi_get_par_embedding_levels_ex($!bidi-types, $!bracket-types, self.elems, $!dir, $!embedding-levels);
    $!max-level--;
}

method !shape {
    my $len := self.elems;
    my Blob[FriBidiArabicProp] $ar-props .= allocate: $len;
    fribidi_get_joining_types($!visual, $len, $ar-props);
    fribidi_join_arabic($!bidi-types, $len, $!embedding-levels, $ar-props);
    fribidi_shape($!flags, $!embedding-levels, $len, $ar-props, $!visual);
}

method visual-map {
    without $!visual-map {
        $_ .= new;
        for $!logical-map.pairs -> $l {
            .[$l.value] = $l.key
               if $l.value >= 0;
        }
    }
    $!visual-map;
}

method version-info {
    fribidi_version_info();
}

method lib-version {
    state Version $version;
    without $version {
        if fribidi_version_info() ~~ m/') '(<[0..9 .]>+)/ {
            $_ .= new: ~$0
        }
    }
    $version;
}

method Str {
    self.visual.map(*.chr).join;
}
