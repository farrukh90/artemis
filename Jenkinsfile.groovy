node {
properties(
[parameters(
[choice(choices: 
[
'1.0.0', 
'2.0.0', 
'3.0.0', 
'4.0.0',
'5.0.0',
'6.0.0',
'7.0.0',
'8.0.0',
'9.0.0',
], 
description: 'Which version of the app should I deploy? ', 
name: 'Version'), 

string(defaultValue: '127.0.0.1', 
		description: 'Which environment should I build the app?', 
name: 'ENVIR', trim: true)])])

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
