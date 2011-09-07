

# ------------------------------------------------------------------
for file in $(ls ./pass | grep "slur");
do
	python ../frontend.py "./pass/$file" 1> /dev/null 2> /dev/null

	if [ $? -gt 0 ];
	then echo "fail: " $file		
	else echo "pass: " $file
	fi
done


