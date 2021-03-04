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
    my ($str, $vis) = .value;
    my Text::FriBidi::Line $line .= new: :$str, :!brackets;
    is $line.Str, $vis, "$test: $str -> $vis";
}
