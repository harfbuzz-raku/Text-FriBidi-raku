unit class Text::FriBidi;

use Text::FriBidi::Raw;
use Text::FriBidi::Raw::Defs :types, :FriBidiFlag;

has Str:D $.str is required;
has FriBidiParType $.dir is rw;
has FriBidiFlags $.flags = FRIBIDI_FLAGS_DEFAULT +| FRIBIDI_FLAGS_ARABIC;
has utf32 $.buf is built handles<elems>;
has utf32 $.visual;
has uint8 $.max-level is built;
has Blob[FriBidiCharType] $.bidi-types is built;
has Blob[FriBidiCharType] $.bracket-types is built;
has Blob[FriBidiLevel]    $.embedding-levels is built;
has Bool $.shape = True;

submethod TWEAK {
    self!build-buf;
    self!build-bidi-types;
    my $len := $!buf.elems;
    $!dir ||= fribidi_get_par_direction($!bidi-types, $len);
    self!build-bracket-types;
    self!build-embedding-levels;
    $!visual = $!buf.clone;
    if $!shape {
        my Blob[FriBidiArabicProp] $ar-props .= allocate: $len;
        fribidi_get_joining_types($!buf, $!buf.elems, $ar-props);
        fribidi_join_arabic($!bidi-types, $len, $!embedding-levels, $ar-props);
        fribidi_shape($!flags, $!embedding-levels, $len, $ar-props, $!visual);
    }
}

method !build-buf {
    $!buf .= allocate: $!str.chars;
    my utf8 $in = $!str.encode;
    my $out-len = fribidi_utf8_to_unicode($in, $in.elems, $!buf);
    given $out-len <=> $!buf.elems {
        when Less {
            $!buf.reallocate: $_;
        }
        when More {
            # shouldn't happen
            die "buffer overrun $out-len > {$!buf.elems}";
        }
    }
}

method !build-bidi-types {
    $!bidi-types .= allocate: self.elems;
    fribidi_get_bidi_types($!buf, $.elems, $!bidi-types);
}

method !build-bracket-types {
    $!bracket-types .= allocate: self.elems;
    fribidi_get_bracket_types($!buf, $.elems, $!bidi-types, $!bracket-types);
}

method !build-embedding-levels {
    $!embedding-levels .= allocate: self.elems;
    $!max-level = fribidi_get_par_embedding_levels_ex($!bidi-types, $!bracket-types, self.elems, $!dir, $!embedding-levels);
    $!max-level--;
}

