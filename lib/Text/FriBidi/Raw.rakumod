unit module Text::FriBidi::Raw;

use Text::FriBidi::Raw::Defs :$FB, :types;
use NativeCall;

sub fribidi_get_bidi_types(Blob[FriBidiChar], FriBidiStrIndex $len, Blob[FriBidiCharType] $types) is export is native($FB) {...};

sub fribidi_utf8_to_unicode(utf8 $in, FriBidiStrIndex $len, utf32 --> FriBidiStrIndex) is export is native($FB) {...};

