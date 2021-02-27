unit module Text::FriBidi::Raw;

use Text::FriBidi::Raw::Defs :$FB, :types;
use NativeCall;

sub fribidi_get_bidi_types(utf32, FriBidiStrIndex $len, Blob[FriBidiCharType] $bidi-types) is export is native($FB) {...};

sub fribidi_get_bracket_types(utf32, FriBidiStrIndex $len, Blob[FriBidiCharType] $bidi-types, Blob[FriBidiBracketType] $bracket-types) is export is native($FB) {...};

sub fribidi_utf8_to_unicode(utf8 $in, FriBidiStrIndex $len, utf32 --> FriBidiStrIndex) is export is native($FB) {...};

sub fribidi_get_par_direction(Blob[FriBidiCharType] $bidi-types, FriBidiStrIndex $len --> FriBidiParType) is export is native($FB) {...};
