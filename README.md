# Test Ports on Remote Servers

## Options

* `LOG_ENABLED` - `0` or `1`
* `ERR_LOG_ENABLED` - `0` or `1`

## File format

```csv
google.com 443
cloudflare.com 80,443

```

## Example

Crontab every 30 seconds:
```shell
* * * * * /path/test-ports/test-ports.sh my.csv
* * * * *  sleep 30; /path/test-ports/test-ports.sh my.csv
```