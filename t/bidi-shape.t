use Test;
plan 3;

use Text::FriBidi::Line;

for (
    "default join"   => (
	"\c[ARABIC LETTER LAM]\c[ARABIC LETTER HAH]",
	"\c[ARABIC LETTER HAH FINAL FORM]\c[ARABIC LETTER LAM INITIAL FORM]"),
    "force non-join" => (
	"\c[ARABIC LETTER LAM]\c[ZERO WIDTH NON-JOINER]\c[ARABIC LETTER HAH]",
	"\c[ARABIC LETTER HAH ISOLATED FORM]\c[ARABIC LETTER LAM ISOLATED FORM]"),
    "force join"     => (
	"\c[ARABIC LETTER LAM]\c[ZERO WIDTH JOINER]\c[ARABIC LETTER HAH]",
	"\c[ARABIC LETTER HAH FINAL FORM]\c[ARABIC LETTER LAM INITIAL FORM]"),
    ) {
    my $test = .key;
    my ($text, $vis) = .value;
    my Text::FriBidi::Line $line .= new: :$text;
    is $line.Str, $vis, "$test: $text -> $vis";
}
