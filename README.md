# GIT UTILITY BELT

Useful utililties for helping with everyday GIT duties

## Why
As a dev working on a single project but spread over multiple repos I found wasting a lot of time. So with this in mind I set out to create a GIT UTILITY BELT to help speed up development. 
Hope this helps someone as it grows and feel free to contribute.

Currently on the belt:

<b>Script: git-utility-belt/src/gitutils-subdir-commit.sh</b><br />
<b>Purpose:</b><br />
Scans a given subdirectory and gets all git repos under the subdirectory
For each repo
1. Checks if any uncommitted changes (dif between local and origin). If any uncommited changes where found it prompts and asked whether you want to commit - commits if your answer is yes<br />
2. Check if any local/branch is ahead of origin/branch. If local/branch is ahead it prompts and asked whether you want to do a origin push - does origin push if answer is yes<br />
3. Check if any origin/branch is ahead of origin/master. If origin/branch is ahead it prompts and asked whether you want to do a pull request - does pull request if answer is yes (pull  request only currently available for bitbucket API)

## Licence
GIT UTILITY BELT is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

 GIT UTILITY BELT is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with GIT UTILITY BELT.  If not, see <http://www.gnu.org/licenses/>.
