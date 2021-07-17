node {
properties(
[parameters(
[choice(choices: 
[
'0.1', 
'0.2', 
'0.3', 
'0.4', 
'0.5',
'0.6',
'0.7',
'0.8',
'0.9',
], 
description: 'Which version of the app should I deploy? ', 
name: 'Version'), 
choice(choices: 
[
'174.129.49.128', 
'35.172.186.162', 
'34.228.169.242', 
'18.215.161.218'], 
description: 'Please provide an environment to build the application', 
name: 'ENVIR')])])
stage("Stage1"){
timestamps {
ws {
checkout([$class: 'GitSCM', branches: [[name: '${Version}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/farrukh90/artemis.git']]])
}
}
}
stage("Install Prerequisites"){
timestamps {
ws{
sshagent(credentials : ['ec2-user']) {
sh '''ssh -o StrictHostKeyChecking=no ec2-user@${ENVIR} sudo amazon-linux-extras install epel -y
ssh -o StrictHostKeyChecking=no ec2-user@${ENVIR} sudo yum install python-pip -y
ssh -o StrictHostKeyChecking=no ec2-user@${ENVIR} sudo pip install Flask
'''
}
}
}
}
stage("Copy Artemis"){
timestamps {
ws {
sshagent(credentials : ['ec2-user']) {
sh '''
scp -r * ec2-user@${ENVIR}:/tmp
'''
}
}
}
}
stage("Run Artemis"){
timestamps {
ws {
sshagent(credentials : ['ec2-user']) {
sh '''
ssh -o StrictHostKeyChecking=no ec2-user@${ENVIR} nohup python /tmp/artemis.py &
'''
}
}
}
}
stage("Send slack notifications"){
timestamps {
ws {
sshagent(credentials : ['ec2-user']) {
echo "Slack"
//slackSend color: '#BADA55', message: 'Hello, World!'
}
}
}
}
}
