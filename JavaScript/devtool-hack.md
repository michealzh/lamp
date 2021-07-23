```js

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>Devtool Hack</title>
</head>
<body>
  <h1>Chrome Devtool Monitor</h1>
  <div>
    result: <span id="txtResult"></span>
  </div>
  <div>
    error: <span id="txtError"></span>
  </div>
  <script>
    function formatValue(val) {
      switch (typeof val) {
      case 'string':
        return `"${val}"`

      case 'object':
        if (val === null) {
          return 'null'
        }
      }
      return val + ''
    }

    const then = Promise.prototype.then

    Promise.prototype.then = function(resolve, reject) {
      return then.call(this, ret => {
        // console.log('resolve:', ret)
        const val = ret['.repl_result']
        txtResult.textContent = formatValue(val)
        resolve(ret)
      }, err => {
        // console.log('reject:', err)
        txtError.textContent = err.message
        reject(err)
      })
    }
  </script>
</body>
</html>
```
