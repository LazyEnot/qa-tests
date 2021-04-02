# Simple robot framework image

## Simple usage
To run tests simply use command:
```bash
docker run -it --shm-size=3g -v `pwd`/tests:/tests:ro -v `pwd`/reports:/out:rw --env PAGE=http://site.com/ lazyenot/qa-tests:latest
```
It is recommended to define `${PAGE}  %{PAGE}` in your robot variables and then use `${PAGE}` in test cases.

## Rerunning tests
By default it reruns failed tests 5 times, you can change this via `--env MAX_RERUNS=[number_of_reruns]` (0 to not rerun tests).

## Parallelisation
By default there is no parallelisation. To run tests in parallel just define `--env PROCESSES=[number_of_parallel_processes]`

## Virtual screen parameters
To change virtual screen parameters use environment variables:
* `SCREEN_WIDTH` (default - 1920)
* `SCREEN_HEIGHT` (default - 1080)
* `SCREEN_DEPTH` (default - 16)
