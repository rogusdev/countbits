
PROFILE=...
BUCKET=...


# https://www.cyberciti.biz/faq/bash-for-loop-array/
types=( c csharp elixir go java java_1 java_2 jruby javascript javascript_1 javascript_2 php python3 ruby rust )

for TYPE in "${types[@]}"
do
    echo "$TYPE s3 bucket:"
    aws s3 ls --profile $PROFILE $BUCKET/$TYPE/

    # https://stackoverflow.com/questions/36813327/how-to-display-only-files-from-aws-s3-ls-command
    files=(`aws s3 ls --profile $PROFILE $BUCKET/$TYPE/ | awk '{print $4}'`)

    for file in "${files[@]}"
    do
        if [[ $file =~ .*_.*\.json ]]; then
            aws s3 cp --profile $PROFILE s3://$BUCKET/$TYPE/$file ./${TYPE}_${file}
            aws s3 rm --profile $PROFILE s3://$BUCKET/$TYPE/$file
        elif [[ $file = cloud-init-output.log ]]; then
            aws s3 cp --profile $PROFILE s3://$BUCKET/$TYPE/$file ./${TYPE}-$file
            aws s3 rm --profile $PROFILE s3://$BUCKET/$TYPE/$file
        fi
    done
done
