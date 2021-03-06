#!/bin/bash
#  ---------------------------------------------------------------------------
#  ---------------------------------------------------------------------------
#
#    Anyone is free to copy, modify, publish, use, compile, sell, or
#    distribute this software, either in source code form or as a compiled
#    binary, for any purpose, commercial or non-commercial, and by any
#    means.
#    
#    In jurisdictions that recognize copyright laws, the author or authors
#    of this software dedicate any and all copyright interest in the
#    software to the public domain. We make this dedication for the benefit
#    of the public at large and to the detriment of our heirs and
#    successors. We intend this dedication to be an overt act of
#    relinquishment in perpetuity of all present and future rights to this
#    software under copyright law.
#    
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
#    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#    OTHER DEALINGS IN THE SOFTWARE.
#    
#    For more information, please refer to <http://unlicense.org/>
#
#  ---------------------------------------------------------------------------
#  ---------------------------------------------------------------------------
#
# Script: git-utility-belt/src/gitutils-subdir-commit.sh
# Purpose:
# Scans a given subdirectory and gets all git repos under the subdirectory
# For each repo
# 1. Checks if any uncommitted changes (dif between local and origin). If any uncommited changes where found it prompts and asked whether you want to commit - commits if your answer is yes
# 2. Check if any local/branch is ahead of origin/branch. If local/branch is ahead it prompts and asked whether you want to do a origin push - does origin push if answer is yes
# 3. Check if any origin/branch is ahead of origin/master. If origin/branch is ahead it prompts and asked whether you want to do a pull request - does pull request if answer is yes (pull  request only currently available for bitbucket API)
	
REPOARRAY=()
gitusername=""
gitpassword=""
gitcommitmessage=""
gitpullrequesttitle=""

if [ "$1" != "" ]; then 
   cd $1 > /dev/null; 
fi

CURRENTDIR=${PWD}

echo "Scanning ${CURRENTDIR}"

for i in $(find "$CURRENTDIR" -type d -name ".git"); do
    REPOARRAY+=($i)
done



for LINE in "${REPOARRAY[@]}"; do
    cd $1 > /dev/null;
    LINE=${LINE/.git/}
    #echo ">>> $LINE"
    d="$LINE"
	if [ -d "$d" ]; then
		if [ -e "$d/.ignore" ]; then 
			echo -e "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
		else

			cd $d > /dev/null
			if [ -d ".git" ]; then
			
				GITREPOURL=""
				REPONAMEURL=$(git remote show -n origin | grep -i fetch | cut -d: -f2-)
				REPONAMEURL="$(echo "$REPONAMEURL" | tr -d ' ')"
				if [[ ${REPONAMEURL} != *".git"* ]];then
					DD="${REPONAMEURL}.git"
				fi				
				REPONAME=$(basename $REPONAMEURL)
				if [[ ${REPONAME} == *".git"* ]];then
					REPONAME="${REPONAME//.git}"					
				fi				
				REPONAMEURLOLD=${REPONAMEURL}
				REPONAMEURL="$(echo ${REPONAMEURL} | replace '//' '')"
				IFS=':' read -ra NAMES <<< "${REPONAMEURL}"	
				GITREPOURLPREPEND=${NAMES[0]}
				REPONAMEURL=${NAMES[1]}
				
				IFS='@' read -ra NAMES <<< "$REPONAMEURL"
				
				if [[ ${REPONAMEURL} != *"@"* ]];then
					GITREPOURL=${NAMES[0]}
				else
				   GITREPOURL=${NAMES[1]}
				fi
				
				
				IFS='\/' read -ra NAMES string <<< "$GITREPOURL"
				PRSLUG="${NAMES[1]}/${NAMES[2]}"
				PRSLUG="${PRSLUG//.git}"
				
				BRANCH=$(git rev-parse --abbrev-ref HEAD)
				echo "------------------------------------------"
				echo "------------------------------------------"
				echo "  "
				echo "DIR: `pwd`"
				echo "REPO: $REPONAME"
				echo "REPOURL: $REPONAMEURL"
				echo "PR SLUG: $PRSLUG"
				echo "BRANCH: $BRANCH"
				echo "  "
				echo "  "
				
				
				echo "*** Enter GIT Repo Auth Details (if not already)";
	
				if [ -z "$gitusername" ]; then 
				   echo "Please enter the git repo username: "
				   read input_gitusername
				   gitusername=$input_gitusername
				else
				   echo "!!!! using git username: $gitusername"
				fi

				if [ -z "$gitpassword" ]; then 
				   echo "Please enter the git repo password: "
				   read input_gitpassword
				   gitpassword=$input_gitpassword
				else
				   echo "!!!! using git pasword: $gitpassword"
				fi

				
				echo ""
				echo "*** Fetching Origin (refreshing local)";
				
				GITREPOURL="$gitusername:$gitpassword@$GITREPOURL"
				NEWGITREPOURL="${GITREPOURLPREPEND}://${GITREPOURL}"
				echo ${NEWGITREPOURL}
				echo ${REPONAMEURL}
				git remote set-url origin "${NEWGITREPOURL}"
				git fetch origin
				git remote set-url origin "${REPONAMEURLOLD}"
				
				echo ""
				echo "*** Checking for any uncommitted changes";
				
				if [ -n "$(git status --porcelain)" ]; then 
					
					echo "*** There are uncommited changes";
					echo -n "Would you like to commit changes (y/n)? " 
					read answer
					if echo "$answer" | grep -iq "^y"; then
						if [ -z "$gitcommitmessage" ]; then 
						   echo "Please enter the git repo commit message: "
						   read input_gitcommitmessage
						   gitcommitmessage=$input_gitcommitmessage
							
						else
						   echo "!!!! using git commit message: $gitcommitmessage"
						fi
						git remote set-url origin "${NEWGITREPOURL}"
						git commit -a -m "${gitcommitmessage}"
						git fetch origin
						git remote set-url origin "${REPONAMEURLOLD}"

					else
						echo "!!!! Changes not being commited"
					fi 	  
				else 
					echo "--- no changes to commit";
				fi

				echo ""
				echo "*** Checking if a origin push is neccesary - REPO: ${REPONAME}:";
				
				ahead=$(git rev-list --count origin/${BRANCH}..${BRANCH})
				behind=$(git rev-list --count ${BRANCH}..origin/${BRANCH})

				echo "--- Checking local/${BRANCH} ahead of origin/${BRANCH} - ${ahead} ahead"
				echo "--- Checking local/${BRANCH} behind of origin/${BRANCH} - ${behind} behind"
				
				if [ "$ahead" -gt 0 ];then
					echo "-- It seems that the local branch is ${ahead} commit ahead - Lets push to origin"
					git remote set-url origin "${NEWGITREPOURL}"
					git push origin
					git fetch origin
					git remote set-url origin "${REPONAMEURLOLD}"			
				fi
				
				echo ""
				echo "*** Checking if a pull request push is neccesary - REPO: ${REPONAME}";
				
				ahead=$(git rev-list --count origin/master..origin/${BRANCH})
				behind=$(git rev-list --count origin/${BRANCH}..origin/master)

				echo "---Checking origin/${BRANCH} ahead of origin/master - ${ahead} ahead"
				echo "---Checking origin/${BRANCH} behind of origin/master - ${behind} behind"
				
				if [ "$ahead" -gt 0 ];then
					gitpullrequesttitle="Merge ${BRANCH} to master - ${ahead} commits ahead"
					PR="{ \"title\": \"${gitpullrequesttitle}\", \"description\": \"${gitpullrequesttitle}\", \"source\": { \"branch\": { \"name\": \"${BRANCH}\" } }, \"destination\": { \"branch\": { \"name\": \"master\" } }, \"reviewers\": [ { \"username\": \"wsr.junk@gmail.com\" } ], \"close_source_branch\": false }";
					
					
					PRURL="https://api.bitbucket.org/2.0/repositories/${PRSLUG}/pullrequests/"
					echo "************************************"; 
					echo "*** origin/${BRANCH} is ${ahead} commits from origin/master";
					echo "************************************";
					echo -n "Would you like to create a pull request (y/n)? " 
					read answer
					if echo "$answer" | grep -iq "^y"; then
						
						curl -X POST -H "Content-Type: application/json" -u ${gitusername}:${gitpassword} \
							https://api.bitbucket.org/2.0/repositories/${PRSLUG}/pullrequests/ \
							-d "${PR}"

					else
						echo "!!!! Changes not being commited"
					fi 
					
				fi
				
				sleep 1

				echo ""	
				echo "------------------------------------------"
			fi      
		fi
	fi
    
done


