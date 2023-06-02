# bash_utils

Some usefull functions, variables, configurations and tests/example to re-use in other scripts.
This repo is meant to centralize and version tools, scripts, function, variables, configurations, defaults, etc. so that I can easily reuse them latter.

If it is the first time for you about this entire repo notice that the "settler" project may help you setup everything.


Notice that the repo is divided into two major directories: "tools" and "libs".

"Libs" are supposed to not do anything meaningful on their own. They should need input to produce any output. There shouldn't be any logic in these files. 

"Tools" depend on libs and should provide the data in the expected fashion to produce an output. This is were any logic should be.