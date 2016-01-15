# coffeelint-callback-handle-error
CoffeeLint rule that finds instances of error objects passed through a callback not being handled. Error variables are determined with regex and must match this heregex:
```coffee
///
  (^err(or)?$)
  | (_err(or)?$)
  | (^err(or)?_)
///i
```

Ex: Any of these code blocks do not handle their error variable:
```coffeescript
fs.stat '/invalid/path/to/file', (err, stats)->
  console.log stats
  return
```

```coffeescript
fs.stat '/invalid/path/to/file', (err, stats)->
  # this err is not handled and is instead overwritten by the next stat

  fs.stat '/some/other/invalid/file', (err, stats2)->
    if err
      console.log err
    return
  return
```

These examples will pass, since their error variables are handled:
```coffeescript
fs.stat '/invalid/path/to/file', (err, stats)->
  if err
    console.log err
  return
```

```coffeescript
doStuff 123, (callback)->
  fs.stat '/invalid/path/to/file', (err, stats)->
    callback err
    return
  return
```

## Installation
```sh
npm install coffeelint-callback-handle-error
```
## Usage

Add the following configuration to coffeelint.json:

```json
"callback_handle_error": {
  "module": "coffeelint-callback-handle-error"
}
```
## Configuration

There are currently no configuration options.
