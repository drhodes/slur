python frontend.py $1 > out.hs

if [ $? -gt 0 ]; then    
	exit
fi

cat -n out.hs

ghc out.hs

if [ $? -gt 0 ]; then    
	exit
fi

./out