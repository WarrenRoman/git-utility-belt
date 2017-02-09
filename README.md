# GIT UTILITY BELT

Useful utililties for helping with everyday GIT duties

## Why
As a dev working on a single project but spread over multiple repos I found wasting a lot of time. So with this in mind I set out to create a GIT UTILITY BELT to help speed up development. 
Hope this helps someone as it grows and feel free to contribute.

## Currently on the belt:
<b>Script: git-utility-belt/src/gitutils-subdir-commit.sh</b><br />
<b>Purpose:</b><br />
Scans a given subdirectory and gets all git repos under the subdirectory
For each repo
1. Checks if any uncommitted changes (dif between local and origin). If any uncommited changes where found it prompts and asked whether you want to commit - commits if your answer is yes<br />
2. Check if any local/branch is ahead of origin/branch. If local/branch is ahead it prompts and asked whether you want to do a origin push - does origin push if answer is yes<br />
3. Check if any origin/branch is ahead of origin/master. If origin/branch is ahead it prompts and asked whether you want to do a pull request - does pull request if answer is yes (pull  request only currently available for bitbucket API)

## Licence
Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
