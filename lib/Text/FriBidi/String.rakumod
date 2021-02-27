unit class Text::FriBidi::String;

use Text::FriBidi::Raw;
use Text::FriBidi::Raw::Defs :types;

has Str:D $.str is required;
has utf32 $.buf is built handles<elems> = self!build-buf();
has FriBidiParType $.dir = fribidi_get_par_direction(self!bidi-types, $!buf.elems);

method !build-buf {
    my utf32 $buf .= allocate: $!str.chars;
    my utf8 $in = $!str.encode;
    my $out-len = fribidi_utf8_to_unicode($in, $in.elems, $buf);
    given $out-len <=> $buf.elems {
        when Less {
            $buf.reallocate: $_;
        }
        when More {
            # shouldn't happen
            die "buffer overrun $out-len > {$buf.elems}";
        }
    }
    $buf
}

method Str { $!str }

multi method COERCE(Str:D $str) {
    self.new: :$str;
}

has Blob[FriBidiCharType] $!bidi-types;
method !bidi-types {
    without $!bidi-types {
        $_  .= allocate: $.elems;
        fribidi_get_bidi_types($!buf, $.elems, $!bidi-types);
    }
    $!bidi-types;
}

method bidi-types returns Seq {
    self!bidi-types().Seq;
}

method !bracket-types($bidi-types =  self!bidi-types()) {
    my Blob[FriBidiCharType] $bracket-types .= allocate: $.elems;
    fribidi_get_bracket_types($!buf, $.elems, $bidi-types, $bracket-types);
    $bracket-types;
}

method embedding-levels {
    my $bidi-types =  self!bidi-types();
    my $bracket-types =  self!bracket-types($bidi-types);
    ...;
}

