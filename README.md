json-endure
===========

`json-endure` provides helper methods to the JSON and String classes to
make-do with truncated JSON text.  It does so by closing
double-quotes, brackets and braces, whether the truncation occurs in
an array value, hash key, or hash value.  These methods may be helpful
in a case where you want to examine the first bunch of bytes of a very
large file, without downloading all of it.

It will not repair bad JSON encountered before the truncation.  All
JSON-restoration code has been implemented in Ruby.

License
-------

`json-endure` is licensed under the Creative Commons 3.0 License.
Details can be found in the file LICENSE.

License-file referencing and other doc. formatting taken from
[damiendallimore](https://github.com/damiendallimore "damiendallimore on GitHub").

Install
-------

    gem install json-endure

Usage
-----

    require 'json-endure'                              #=> true
    broken = String.new('{ "123": "90", "abc": { "30') #=> "{ \"123\": \"90\", \"abc\": { \"30"
    good_hash = JSON.endure_and_parse broken           #=> {"123"=>"90", "abc"=>{"30"=>""}}
    fixed = broken.coax_into_json!                     #=> "{ \"123\": \"90\", \"abc\": { \"30\":\"\"}}"
    broken                                             #=> "{ \"123\": \"90\", \"abc\": { \"30\":\"\"}}"

Contribute
----------

Please fork the GitHub project (https://github.com/aburnheimer/json-endure),
make any changes, commit and push to GitHub, and submit a pull request.  Including
tests for your changes would be greatly appreciated!

Resources
---------

JSON format reference

* http://www.json.org/

Contact
-------

This project was initiated by Andrew Burnheimer.

* Email:
  * aburnheimer@gmail.com
* Twitter:
  * @aburnheimer
* Github:
  * https://github.com/aburnheimer/
