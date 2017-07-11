# wScriptLauncher<!-- [![BrowserStack Status](https://www.browserstack.com/automate/badge.svg?badge_key=<badge_key>)](https://www.browserstack.com/automate/public-build/<badge_key>) -->

wScriptLauncher provides simple way to run script file inside chosen platrform( browser, cloud-based testing tool, etc. ) and get output to your terminal.

## Installation
```terminal
npm install wscriptlauncher
```

## Usage
#### Platforms list:
###### Cloud-based:
* <p>
  Cloud solution for cross-browser testing on different platforms:
  </p> 
  <a href="https://www.browserstack.com/">
  <img border="0" alt="browserstack" src="https://www.browserstack.com/images/layout/browserstack-logo-600x315.png" height="100" style="display:block">
  </a>


###### Browsers:
* [Mozilla Firefox]( https://www.mozilla.org/uk/firefox/new )
* [Google Chrome](https://www.google.com/chrome)

###### Others:
* [ Electron ](https://electron.atom.io)
* [ PhantomJs ](https://phantomjs.org)
* [ Node.js ](https://nodejs.org)

#### Options
Option | Type | Optional |  Default | Description
------------------------- | -------------------------| -------------------------| :------------------------- | -------------------------
filePath |string || |path to script file
platform |string|*|chrome| sets target platfrom
headless |boolean|*|true| run in headless mode
terminatingAfter |boolean|*|true| terminate launcher after script execution
verbosity |number|*|1| sets level of details of console output

List of available values for `platform` option:

Platform | Value |
------------------------- | -------------------------
Mozilla Firefox|firefox
Google Chrome|chrome
Electron|electron
Node.js|node

#### Running

##### via Node:
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

##### via CLI:
* To print help
```terminal
launcher
```
* To run script with default setting
```terminal
launcher /path/to/file.js
```
* To run script with options, first argument must be path
```terminal
launcher /path/to/file.js platform : chrome headless : 0 terminatingAfter : 1
```
* Another way to run script with options
```terminal
launcher filePath : /path/to/file.js platform : firefox headless : 1
```
