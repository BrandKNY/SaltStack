# Import salt modules
import salt.client
import logging
import urllib2
import json
import time
import requests

from boto.s3.connection import S3Connection

log = logging.getLogger(__name__)
REPOSITORY_NAME = "s3_repository"

def maintainLogstash(esHost, awsKey, awsSecretKey, retention=7, **kwargs):
	'''
	Backup all the logstash index that do not contain today's date. Remove
	the old logstash indices 
	'''
	nowDate = time.gmtime()
	retentionDate = time.gmtime(time.time() - (retention+1) * 24*3600)
	esUrl = "http://" + esHost
	if(not createRepository(esHost, awsKey, awsSecretKey)):
		log.error('Could not create the s3 repository') 
		return False

	result = requests.get(esUrl + "/_snapshot/" + REPOSITORY_NAME + "/_all")
	if(result.status_code != 200):
		log.error('Could not fetch the existing snapshot') 
		return False

	snapshots = set()
	for snapshot in result.json()['snapshots']:
		snapshots.add(snapshot['snapshot'])

	result = json.loads(urllib2.urlopen(esUrl + "/_all").read())
	for indexName in result:
		if(not indexName.startswith("logstash-")):
			log.info("Skipping non logstash index {0}".format(indexName))
			continue
		indexStrDate = indexName[indexName.find('-')+1:]

		indexDate = time.strptime(indexStrDate, "%Y.%m.%d")
		if(indexDate.tm_mon == nowDate.tm_mon and indexDate.tm_mday == nowDate.tm_mday and indexDate.tm_year == nowDate.tm_year):
			log.info("Skipping today's logstash index {0}".format(indexName))
			continue

		if(indexName not in snapshots):
			if(snaphotIndex(esHost, indexName)):
				log.info("Successfully backedup logstash index {0}".format(indexName))
			else: 
				log.error("Failed to backup logstash index {0}".format(indexName))
		else:
			log.info("Skipping backed up logstash index {0}".format(indexName))

		if(indexDate.tm_mon <= retentionDate.tm_mon and indexDate.tm_mday <= retentionDate.tm_mday and indexDate.tm_year <= retentionDate.tm_year):
			if(deleteIndex(esHost, indexName)):
				log.info("Successfully removed logstash index {0}".format(indexName))
			else: 
				log.error("Failed to removed logstash index {0}".format(indexName))

def deleteIndex(esHost, indexName):
	indexUrl = "http://" +  esHost + "/" + indexName + "?wait_for_completion=true"
	result = requests.delete(indexUrl);
	return result.status_code == 200

def snaphotIndex(esHost, indexName):
	repoData = {
		"indices": indexName
	}
	snapshotUrl = "http://" + esHost + "/_snapshot/" + REPOSITORY_NAME + "/" + indexName + "?wait_for_completion=true"
	result = requests.put(snapshotUrl, data=json.dumps(repoData));
	return result.status_code == 200

def restoreIndex(esHost, indexName):
	indexUrl = "http://" +  esHost + "/_snapshot/" + REPOSITORY_NAME + "/" + indexName + "/_restore?wait_for_completion=true"
	result = requests.post(indexUrl);
	return result.status_code == 200

def createRepository(esHost, awsKey, awsSecretKey):
	repositoryUrl =  "http://" + esHost + "/_snapshot/" + REPOSITORY_NAME
	result = requests.get(repositoryUrl)
	if(result.status_code == 200):
		log.info("Skipping create S3 elasticsearch repository")
		return True

	repoData = {
		"type": "s3",
		"settings": {
			"bucket": "appstranet",
			"region": "us-east-1",
			"access_key": awsKey,
			"secret_key": awsSecretKey,
			"base_path": "backups/elasticsearch/"
	 	}
 	}
 	log.info("Creating S3 elasticsearch repository")
	result = requests.put(repositoryUrl, data=json.dumps(repoData));
	return result.status_code == 200
		