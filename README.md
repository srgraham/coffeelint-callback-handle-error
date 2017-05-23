# coffeelint-callback-handle-error

CoffeeLint rule that finds instances of error objects passed through a callback
function without being handled.

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

To get started, insert this configuration somewhere in your `coffeelint.json`
file:

```json
"callback_handle_error": {
  "module": "coffeelint-callback-handle-error"
}
```

## Configuration

This plugin has one custom configurable option.

### `patterns`: `["^err(or)?", "[Ee]rr(or)?$"]`

A list of regular expressions used to match parameter names for detecting error
objects in function parameters.

The default setting looks for any variable which starts with "err"/"error" or ends with "err"/"Err" or
"error"/"Error".
