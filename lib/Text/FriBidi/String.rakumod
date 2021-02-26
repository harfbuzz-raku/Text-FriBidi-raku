unit class Text::FriBidi::String;

use Text::FriBidi::Raw;
use Text::FriBidi::Raw::Defs :types;

has Str:D $.str is required;
has utf32 $.buf is built handles<elems>;

submethod TWEAK {
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

method Str { $!str }

multi method COERCE(Str:D $str) {
    self.new: :$str;
}

method bidi-types returns Seq {
    my Blob[FriBidiCharType] $types .= allocate: $.elems;
    fribidi_get_bidi_types($!buf, $.elems, $types);
    $types.Seq;
}

