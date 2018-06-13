PROJECT1 = ec2_cron_function
PROJECT2 = ec2_cron_tasks
PROJECT3 = ec2_start
PROJECT4 = ec2_stop
FUNCTION1 = $(PROJECT1)
FUNCTION2 = $(PROJECT2)
FUNCTION3 = $(PROJECT3)
FUNCTION4 = $(PROJECT4)
REGION = ap-southeast-1
ROLE = arn:aws:iam::xxxxxxxxxxx:role/xxxxxxx_lambda_basic_execution
.phony: clean1 clean2 clean3 clean4

clean1:
	cd $(FUNCTION1); rm -f -r site-packages;\
	rm -f -r $(FUNCTION1)-env;\
	rm -f -r $(FUNCTION1).zip;\
	sleep 2

clean2:
	cd $(FUNCTION2); rm -f -r $(FUNCTION2).zip
	sleep 2

clean3:
	cd $(FUNCTION3); rm -f -r $(FUNCTION3).zip
	sleep 2

clean4:
	cd $(FUNCTION4); rm -f -r $(FUNCTION4).zip
	sleep 2

build-ec2_cron_function: clean1
	cd $(FUNCTION1);\
	zip -r $(FUNCTION1).zip . -x "*.git*" "tests/*";\
	virtualenv $(FUNCTION1)-env;\
	. $(FUNCTION1)-env/bin/activate; pip install -r requirements.txt;\
	cp -r $$VIRTUAL_ENV/lib/python2.7/site-packages/ ./
	cd $(FUNCTION1)/site-packages; zip -g -r ../$(FUNCTION1).zip .

build-ec2_cron_tasks:
	cd $(FUNCTION2);\
	zip -r $(FUNCTION2).zip . -x "*.git*" "tests/*"

build-ec2_start:
	cd $(FUNCTION3);\
	zip -r $(FUNCTION3).zip . -x "*.git*" "tests/*"

build-ec2_stop:
	cd $(FUNCTION4);\
	zip -r $(FUNCTION4).zip . -x "*.git*" "tests/*"

create-ec2_cron_function:
	aws lambda create-function \
		--handler lambda_function.lambda_handler \
		--function-name $(FUNCTION1) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION1)/$(FUNCTION1).zip \
		--role $(ROLE) \
		--runtime python2.7 \
		--timeout 120 \
		--memory-size 512 \
		--profile lambda_user \

create-ec2_cron_tasks:
	aws lambda create-function \
		--handler lambda_function.lambda_handler \
		--function-name $(FUNCTION2) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION2)/$(FUNCTION2).zip \
		--role $(ROLE) \
		--runtime python2.7 \
		--timeout 120 \
		--memory-size 512 \
		--profile lambda_user \

create-ec2_start:
	aws lambda create-function \
		--handler lambda_function.lambda_handler \
		--function-name $(FUNCTION3) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION3)/$(FUNCTION3).zip \
		--role $(ROLE) \
		--runtime python2.7 \
		--timeout 120 \
		--memory-size 512 \
		--profile lambda_user \

create-ec2_stop:
	aws lambda create-function \
		--handler lambda_function.lambda_handler \
		--function-name $(FUNCTION4) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION4)/$(FUNCTION4).zip \
		--role $(ROLE) \
		--runtime python2.7 \
		--timeout 120 \
		--memory-size 512 \
		--profile lambda_user \

update-ec2_cron_function: build-ec2_cron_function
	aws lambda update-function-code \
		--function-name $(FUNCTION1) \
		--region $(REGION) \
		--profile lambda_user \
		--zip-file fileb://$(FUNCTION1)/$(FUNCTION1).zip \
		--publish \

update-ec2_cron_tasks: build-ec2_cron_tasks
	aws lambda update-function-code \
		--function-name $(FUNCTION2) \
		--region $(REGION) \
		--profile lambda_user \
		--zip-file fileb://$(FUNCTION2)/$(FUNCTION2).zip \
		--publish \

update-ec2_start: build-ec2_start
	aws lambda update-function-code \
		--function-name $(FUNCTION3) \
		--region $(REGION) \
		--profile lambda_user \
		--zip-file fileb://$(FUNCTION3)/$(FUNCTION3).zip \
		--publish \

update-ec2_stop: build-ec2_stop
	aws lambda update-function-code \
		--function-name $(FUNCTION4) \
		--region $(REGION) \
		--profile lambda_user \
		--zip-file fileb://$(FUNCTION4)/$(FUNCTION4).zip \
		--publish \

delete-ec2_cron_function:
	aws lambda delete-function --function-name $(FUNCTION1)

delete-ec2_cron_tasks:
	aws lambda delete-function --function-name $(FUNCTION2)

delete-ec2_start:
	aws lambda delete-function --function-name $(FUNCTION3)

delete-ec2_stop:
	aws lambda delete-function --function-name $(FUNCTION4)

build: build-ec2_cron_function build-ec2_cron_tasks build-ec2_start build-ec2_stop

create : create-ec2_cron_function create-ec2_cron_tasks create-ec2_start create-ec2_stop

clean: clean1 clean2 clean3 clean4

delete: delete-ec2_cron_function delete-ec2_cron_tasks delete-ec2_start delete-ec2_stop
