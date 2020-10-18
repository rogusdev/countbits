types=( c csharp elixir go java java_1 java_2 jruby javascript javascript_1 javascript_2 php python3 ruby rust )

for TYPE in "${types[@]}"
do
    echo "$TYPE countbits average:"
    echo $(cat ${TYPE}_countbits_*_out.txt | jq '.average')
    echo "$TYPE fibonacci time:"
    echo $(sed -n 3p ${TYPE}_fibonacci_*_out.txt)
done
