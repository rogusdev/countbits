NOW=`date +%Y%m%d%H%M%S`

OUTFILE=${BENCHMARK}_${NOW}_out.txt
./$BENCHMARK $ARGS > $OUTFILE

aws s3 cp $OUTFILE s3://$BUCKET/$TYPE/
aws s3 cp /var/log/cloud-init-output.log s3://$BUCKET/$TYPE/${BENCHMARK}_${NOW}_init.log

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now
