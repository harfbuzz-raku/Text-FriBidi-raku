unit module Text::FriBidi::Raw::Defs;

our $FB is export(:FB) = 'fribidi';
our $CLIB is export(:CLIB) = Rakudo::Internals.IS-WIN ?? 'msvcrt' !! Str;

constant FriBidiStrIndex is export(:types) = int32;
constant FriBidiChar     is export(:types) = uint32;
constant FriBidiCharType is export(:types) = uint32;
constant FriBidiParType  is export(:types) = uint32;
constant FriBidiBracketType  is export(:types) = FriBidiCharType;

enum FriBidiMask is export(:FriBidiMask) (
    
    :FRIBIDI_MASK_RTL(0x1),             # Is right to left
    :FRIBIDI_MASK_ARABIC(0x2),          # Is arabic

    #  Each char can be only one of the three following
    :FRIBIDI_MASK_STRONG(0x10),		# Is strong
    :FRIBIDI_MASK_WEAK(0x20),		# Is weak
    :FRIBIDI_MASK_NEUTRAL(0x40),	# Is neutral
    :FRIBIDI_MASK_SENTINEL(0x80),	# Is sentinel
    # Sentinels are not valid chars, just identify the start/end of strings.

     # Each char can be only one of the six following. 
    :FRIBIDI_MASK_LETTER(0x100),	# Is letter: L, R, AL
    :FRIBIDI_MASK_NUMBER(0x200),	# Is number: EN, AN
    :FRIBIDI_MASK_NUMSEPTER(0x400),	# Is separator or terminator: ES, ET, CS
    :FRIBIDI_MASK_SPACE(0x800),		# Is space: BN, BS, SS, WS
    :FRIBIDI_MASK_EXPLICIT(0x1000),	# Is explicit mark: LRE, RLE, LRO, RLO, PDF
    :FRIBIDI_MASK_ISOLATE(0x8000),      # Is isolate mark: LRI, RLI, FSI, PDI

    # Can be set only if FRIBIDI_MASK_SPACE is also set.
    :FRIBIDI_MASK_SEPARATOR(0x2000),	# Is text separator: BS, SS
    # Can be set only if FRIBIDI_MASK_EXPLICIT is also set.
    :FRIBIDI_MASK_OVERRIDE(0x4000),	# Is explicit override: LRO, RLO
    :FRIBIDI_MASK_FIRST(0x2000000),     # Whether direction is determined by first strong

    # The following exist to make types pairwise different, some of them can
    # be removed but are here because of efficiency (make queries faster).

    :FRIBIDI_MASK_ES(0x10000),
    :FRIBIDI_MASK_ET(0x20000),
    :FRIBIDI_MASK_CS(0x40000),

    :FRIBIDI_MASK_NSM(0x80000),
    :FRIBIDI_MASK_BN(0x100000),

    :FRIBIDI_MASK_BS(0x200000),
    :FRIBIDI_MASK_SS(0x400000),
    :FRIBIDI_MASK_WS(0x800000),

    # We reserve a single bit for user's private use: we will never use it.
    :FRIBIDI_MASK_PRIVATE(0x1000000),

);

enum FriBidiType is export(:FriBidiType) (
    # Left-To-Right letter
    :FRIBIDI_TYPE_LTR(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_LETTER),
    # Right-To-Left letter
    :FRIBIDI_TYPE_RTL(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_LETTER +| FRIBIDI_MASK_RTL),
    # Arabic Letter
    :FRIBIDI_TYPE_AL(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_LETTER
		     +| FRIBIDI_MASK_RTL +| FRIBIDI_MASK_ARABIC),
    # European Numeral
    :FRIBIDI_TYPE_EN(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NUMBER),
    # Arabic Numeral
    :FRIBIDI_TYPE_AN(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NUMBER
                     +| FRIBIDI_MASK_ARABIC),
    # European number Separator.
    :FRIBIDI_TYPE_ES(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NUMSEPTER
		     +| FRIBIDI_MASK_ES),
    # European number Terminator.
    :FRIBIDI_TYPE_ET(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NUMSEPTER
		     +| FRIBIDI_MASK_ET),
    # Common Separator.
    :FRIBIDI_TYPE_CS(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NUMSEPTER
		     +| FRIBIDI_MASK_CS),
    # Non Spacing Mark.
    :FRIBIDI_TYPE_NSM(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_NSM),
    # Boundary Neutral.
    :FRIBIDI_TYPE_BN(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_SPACE
		     +| FRIBIDI_MASK_BN),
    # Block Separator.
    :FRIBIDI_TYPE_BS(FRIBIDI_MASK_NEUTRAL +| FRIBIDI_MASK_SPACE
		     +| FRIBIDI_MASK_SEPARATOR +| FRIBIDI_MASK_BS),
    # Segment Separator.
    :FRIBIDI_TYPE_SS(FRIBIDI_MASK_NEUTRAL +| FRIBIDI_MASK_SPACE
		     +| FRIBIDI_MASK_SEPARATOR +| FRIBIDI_MASK_SS),
    # WhiteSpace.
    :FRIBIDI_TYPE_WS(FRIBIDI_MASK_NEUTRAL +| FRIBIDI_MASK_SPACE
		     +| FRIBIDI_MASK_WS),
    # Other Neutral.
    :FRIBIDI_TYPE_ON(+FRIBIDI_MASK_NEUTRAL),
    # Left-to-Right Embedding.
    :FRIBIDI_TYPE_LRE(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_EXPLICIT),
    # Right-to-Left Embedding.
    :FRIBIDI_TYPE_RLE(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_EXPLICIT
		      +| FRIBIDI_MASK_RTL),
    # Left-to-Right Override.
    :FRIBIDI_TYPE_LRO(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_EXPLICIT
		      +| FRIBIDI_MASK_OVERRIDE),
    # Right-to-Left Override.
    :FRIBIDI_TYPE_RLO(FRIBIDI_MASK_STRONG +| FRIBIDI_MASK_EXPLICIT
		      +| FRIBIDI_MASK_RTL +| FRIBIDI_MASK_OVERRIDE),
    # Pop Directional Flag.
    :FRIBIDI_TYPE_PDF(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_EXPLICIT),
    # Weak Left-To-Right
    :FRIBIDI_TYPE_WLTR(+FRIBIDI_MASK_WEAK),
    # Weak Right-To-Left
    :FRIBIDI_TYPE_WRTL(FRIBIDI_MASK_WEAK +| FRIBIDI_MASK_RTL),
);

enum FriBidiPar is export(:FriBidiPar) (
    :FRIBIDI_PAR_LTR(FRIBIDI_TYPE_LTR),
    :FRIBIDI_PAR_RTL(FRIBIDI_TYPE_RTL),
    :FRIBIDI_PAR_ON(FRIBIDI_TYPE_ON),
    :FRIBIDI_PAR_WLTR(FRIBIDI_TYPE_WLTR),
    :FRIBIDI_PAR_WRTL(FRIBIDI_TYPE_WRTL),
);
