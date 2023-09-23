#!/bin/zsh
set -euC

IFS=$'\n'
groups=(cat:Lu cat:Ll cat:Lt cat:Lm cat:Lo cat:Nd Other_Alphabetic)
typeset -A names=(
	cat:Lu           'Uppercase_Letter (Lu)'
	cat:Ll           'Lowercase_Letter (Ll)'
	cat:Lt           'Titlecase_Letter (Lt)'
	cat:Lm           'Modifier_Letter (Lm)'
	cat:Lo           'Other_Letter (Lo)'
	cat:Nd           'Decimal_Number (Nd)'
	Other_Alphabetic 'Other_Alphabetic'
)
for g in $groups; do
	start=0
	prev=0
	indent='   '
	g2=${g#cat:}
	for (( i=1; i<=$#g2; i++ )); indent+=' '
	l=$(( $#g2 + 2 ))
	print '\n;' $names[$g]
	print -n "$g2 = "
	for line in $(uni -quiet print $g); do
		line=(${(s: :)line})
		if (( $prev == 0 )); then
			prev=$line[3]
			start=$line[3]
			continue
		fi
		if (( $prev + 1 == $line[3] )); then
			prev=$line[3]
			continue
		fi
		if [[ $start != $prev ]]; then
			x=$(print -f '%%x%x-%x / ' $start $prev)
		else
			x=$(print -f '%%x%x / ' $start)
		fi
		print -n $x
		l=$(( l + $#x ))
		if (( $l > 114 )); then
			l=0
			print
			print -n $indent
		fi

		prev=$line[3]
		start=$line[3]
	done
	print -f '%%x%x-%x\n' $start $prev
done
