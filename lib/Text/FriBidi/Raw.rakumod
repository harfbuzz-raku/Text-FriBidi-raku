unit module Text::FriBidi::Raw;

use Text::FriBidi::Raw::Defs :$FB, :types;
use NativeCall;

sub fribidi_get_bidi_types(utf32, FriBidiStrIndex $len, Buf[FriBidiCharType] $bidi-types) is export is native($FB) {...};

sub fribidi_get_bracket_types(utf32, FriBidiStrIndex $len, Blob[FriBidiCharType] $bidi-types, Buf[FriBidiBracketType] $bracket-types) is export is native($FB) {...};

sub fribidi_utf8_to_unicode(utf8 $in, FriBidiStrIndex $len, utf32 --> FriBidiStrIndex) is export is native($FB) {...};

sub fribidi_get_par_direction(Blob[FriBidiCharType] $bidi-types, FriBidiStrIndex $len --> FriBidiParType) is export is native($FB) {...};

sub fribidi_get_par_embedding_levels(Blob[FriBidiCharType] $bidi-types, FriBidiStrIndex $len, FriBidiParType $base-dir is rw, Buf[FriBidiLevel] $levels --> FriBidiLevel) is export is native($FB) {...};

sub fribidi_get_par_embedding_levels_ex(Blob[FriBidiCharType] $bidi-types, Blob[FriBidiCharType] $bracket-types, FriBidiStrIndex $len, FriBidiParType $base-dir is rw, Buf[FriBidiLevel] $levels --> FriBidiLevel) is export is native($FB) {...};

sub fribidi_reorder_line(FriBidiFlags $flags, Blob[FriBidiCharType] $bidi-types, FriBidiStrIndex $len, FriBidiStrIndex $offset, FriBidiParType $base-dir is rw, Blob[FriBidiLevel] $levels, Buf[FriBidiChar] $str, Buf[FriBidiStrIndex] --> FriBidiLevel) is export is native($FB) {...};

sub fribidi_get_joining_types(Blob[FriBidiChar] $str, FriBidiStrIndex $len, Buf[FriBidiJoiningType] $jtype) is export is native($FB) {...};

sub fribidi_join_arabic(Blob[FriBidiCharType] $bidi-types, FriBidiStrIndex $len, Blob[FriBidiLevel] $levels, Buf[FriBidiArabicProp] $ar-props) is export is native($FB) {...};

sub fribidi_shape(FriBidiFlags $flags, Blob[FriBidiLevel] $levels, FriBidiStrIndex $len, Blob[FriBidiArabicProp] $ar-props,  Buf[FriBidiChar] $str, ) is export is native($FB) {...};

sub fribidi_remove_bidi_marks(Buf[uint32] $str, FriBidiStrIndex $len, Buf[FriBidiStrIndex], Buf[FriBidiStrIndex], Buf[FriBidiLevel] $levels --> FriBidiStrIndex) is export is native($FB) {...};

sub fribidi_version_info is rw is export {
    cglobal($FB, 'fribidi_version_info', str);
}
