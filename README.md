Name
----

Text::FriBidi

Synopsis
-----

```raku
use Text::FriBidi::Line;
use Test;
plan 1;

enum ( :Shin<ש>, :Resh<ר>, :He<ה> );

my $text = "Sarah ({Shin~Resh~He})";
my Text::FriBidi::Line $line .= new: :$text;
my $visual = $line.Str;
is-deeply $visual, "Sarah ({He~Resh~Shin})";
is $line[7], He;
```

Description
------
The Unicode standard calls for characters to be ordered 'logically', i.e. in the sequence they are intended to be interpreted, as opposed to 'visually', the sequence they appear.

The Unicode® Bidirectional Algorithm (BiDi Algorithm) is then used to reorder for visual display.

This algorithm primarily based on character detection, but also uses special BiDi control characters available for manual control.

FriBidi is a library that implements the Unicode BiDi algorithm to reorder text for visual display. This module provides Raku
bindings to FriBidi.


Text::FriBidi::Line Methods
-----

### new()
```raku
use Text::FriBidi::Defs :FriBidiType, :FriBidiFlag;
method new(
    Str:D :$text!,      # text, in logical order
    UInt:D :$direction = FRIBIDI_TYPE_LTR, # default direction
    UInt:D :$flags = FRIBIDI_FLAGS_DEFAULT +| FRIBIDI_FLAGS_ARABIC,
)
```

#### `:$text` option
Input text, in logical reading/processing order. Possibly including [Unicode BiDi control characters](https://www.w3.org/International/questions/qa-bidi-unicode-controls.en).

#### `:$flags` option
A set of 'ored` flag, including:
- `FRIBIDI_FLAG_SHAPE_MIRRORING`: Do mirroring.
- `FRIBIDI_FLAG_SHAPE_ARAB_PRES`: Shape Arabic characters to their presentation form glyphs.
- `FRIBIDI_FLAG_SHAPE_ARAB_LIGA`: Form mandatory Arabic ligatures.
- `FRIBIDI_FLAG_REMOVE_SPECIALS`: Remove Bidi marks from output

#### `:$direction` option
Base text direction; one of:
- `FRIBIDI_TYPE_LTR`: Left to right
- `FRIBIDI_TYPE_RTL`: Right to left
- `FRIBIDI_TYPE_WLTR`: Weak left to right
- `FRIBIDI_TYPE_WRTL`: Weak right to left
- `FRIBIDI_TYPE_LTR`: Left to right
- `FRIBIDI_TYPE_RTL`: Right to left

### Str()

The string, after applying any mirroring, shaping and directional ordering and with BiDi control characters removed (by default).

### AT-POS, List, Array

Methods for obtaining individual visual characters.

Note that Raku may perform its own Unicode normalizations on strings. These
methods can be used to get corresponding characters and properties.

```raku
use Text::FriBidi::Line;
my Text::FriBidi::Line $line .= new(:text("A\r\nB"));
say $line.Str.comb.raku; # "A", "\r\n", "B"
say $line.List.raku; # "A" "\r" "\n" "B"
say $line[3] ~ ' has type ' ~ $line.bidi-types[3];

```

Installation
----

### Debian/Ubuntu Linux

```shell
sudo apt-get install libfribidi-dev
```

### Mac OS X

```shell
brew update
brew install fribidi
```
See Also
----
- [UAX #9: Unicode Bidirectional Algorithm](https://unicode.org/reports/tr9/)
- [fribidi](https://github.com/fribidi/fribidi)  GitHub repository
- [Text::Bidi](https://metacpan.org/pod/Text::Bidi) Perl Module

