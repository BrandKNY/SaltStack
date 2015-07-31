# Import salt modules
import salt.client
import logging
import time

import boto.swf.layer1

log = logging.getLogger(__name__)

def running(
		awsKey,
		awsSecretKey, 
		domain, 
		workflowId, 
		workflowName, 
		workflowVersion, 
		taskList=None, 
		childPolicy=None, 
		executionStartToCloseTimeout=None, 
		input=None, 
		tagList=None, 
		taskStartToCloseTimeout=None,
		**kwargs):

	swf = boto.swf.layer1.Layer1(awsKey, awsSecretKey)
	rawWorflows = swf.list_open_workflow_executions(domain, time.time()-30*24*3600, workflow_name=workflowName)
	for workflow in rawWorflows['executionInfos'] :
		if(workflow['execution']['workflowId'] == workflowId):
			log.info("Workflow {0} is already running".format(workflowId))
			return True

	if(input.startswith("\\")):
		input = input[1:]

	swf.start_workflow_execution(
		domain,
		workflowId,
		workflowName, 
		workflowVersion, 
		task_list=taskList, 
		child_policy=childPolicy, 
		execution_start_to_close_timeout=executionStartToCloseTimeout, 
		input=input, 
		tag_list=tagList, 
		task_start_to_close_timeout=taskStartToCloseTimeout
	)
	log.info("Started a new workflow {0}".format(workflowId))
	return True

