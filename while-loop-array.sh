#!/bin/bash

echo "
=== Loop through array with random indexes using while loop ===
"

items[5]='Hey,'
items[9]='You!'
items[17]='Current time is:'
items[20]=`date`;

item_count=${#items[@]};

indexes=${!items[@]}; #String: 5 9 17 20.

echo "Indexes: $indexes.
";

# Convert indexes into an array;
indexes=($indexes);

echo "Items:";
counter=0;
while [ "$counter" -lt $item_count ]; do
	index=${indexes[$counter]};
	item=${items[$index]};
	echo "items[$index] = $item";
	((counter++))
done

echo "
More info:
* http://tldp.org/LDP/abs/html/arrays.html
* https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html 
* https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html
* http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-7.html
";