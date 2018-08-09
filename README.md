# wScriptLauncher [![Build Status](https://travis-ci.org/Wandalen/wScriptLauncher.svg?branch=master)](https://travis-ci.org/Wandalen/wScriptLauncher) [![BrowserStack Status](https://www.browserstack.com/automate/badge.svg?badge_key=<badge_key>)](https://www.browserstack.com/automate/public-build/<badge_key>)

wScriptLauncher provides a simple human-machine, machine-machine interfaces to run a script file on a platform of interest and get output to your terminal. The platform could be remote or local, browser or native. Platforms list could be extended by an implementation of a new custom platform provider.

## Implemented platforms :
> Name - platform option value

* [Mozilla Firefox]( https://www.mozilla.org/uk/firefox/new ) - firefox
* [Google Chrome](https://www.google.com/chrome) - chrome
* [ Electron ](https://electron.atom.io) - electron
* [ PhantomJs ](https://phantomjs.org) - phantomjs
* [ Node.js ](https://nodejs.org) - node
* [Browserstack]( https://www.browserstack.com ) - browserstack

## Installation
```terminal
npm install wscriptlauncher
```

## Usage options
Option | Type | Optional |  Default | Description
------------------------- | -------------------------| -------------------------| :------------------------- | -------------------------
filePath |string || |path to script file
platform |string|*|chrome| sets target platfrom
headless |boolean|*|true| run in headless mode
terminatingAfter |boolean|*|true| terminate launcher after script execution
verbosity |number|*|1| sets level of details of console output

## Usage with Nodejs:

```javascript
var _ = wTools;

/* Initialize launcher with provided options object */

var launcher = wScriptLauncher
({
  filePath : '/path/to/file',
  headless : true,
  platform : 'chrome',
  terminatingAfter : true,
  verbosity : 1
});

/* Run our script file on target platform by calling launch, it
   returns wConsequence object which gives us a message with platform provider
   when all work will be done. More about wConsequence - https://github.com/Wandalen/wConsequence
*/

launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw _.errLog( err );

  console.log( provider );
});
```
[Sample here.](https://github.com/Wandalen/wScriptLauncher/blob/master/sample/ScriptLauncher.js)

## Usage with command line:

To print help:
```terminal
launcher
```
To run script with default setting:
```terminal
launcher /path/to/file.js
```
To run script with options, first argument must be path:
```terminal
launcher /path/to/file.js platform : chrome headless : 0 terminatingAfter : 1
```
Another way to run script with options:
```terminal
launcher filePath : /path/to/file.js platform : firefox headless : 1
```
## Acknowledgements
We would like to thank [Browserstack]( https://www.browserstack.com ) for support!
<p align="left">
<a href="https://www.browserstack.com">
  <img src="https://www.browserstack.com/images/layout/browserstack-logo-600x315.png" height="80" />
</a>
</p>















