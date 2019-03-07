.PHONY: deploy start stop

deploy/%:
  aws cloudformation deploy --template-file stack.yml --stack-name todobackend-$* \
    --parameter-overrides $$(cat $*.json | jq -r '.Parameters|to_entries[]|.key+"="+.value') \
    --capabilities CAPABILITY_NAMED_IAM

start:
	aws autoscaling set-desired-capacity --auto-scaling-group-name todobackend-ApplicationAutoscaling-F72S0547ZT80 --desired-capacity 1
	aws rds start-db-instance --db-instance-identifier todobackend

stop:
	aws autoscaling set-desired-capacity --auto-scaling-group-name todobackend-ApplicationAutoscaling-F72S0547ZT80 --desired-capacity 0
	aws rds stop-db-instance --db-instance-identifier todobackend
