json-endure
===========

`json-endure` provides helper methods to the JSON and String classes to
make-do with interrupted JSON text.  It does so by closing
double-quotes, brackets and braces, whether the interruption occurs in
an array value, hash key, or hash value.  These methods may be helpful
in a case where you want to examine the first bunch of bytes of a very
large file, without downloading all of it.

It will not repair bad JSON encountered before the interruption.

License
-------

`json-endure` is licensed under the Creative Commons 3.0 License.
Details can be found in the file LICENSE.

License-file referencing and other doc. formatting taken from
damiendallimore.

Quick Start
-----------

1.	Save the string.rb and array.rb files somewhere in your source tree.
2.	Include a line that says `load "string.rb"` in one of your files.

Soon enough, I will have this made into a gem to make it loads more
convenient.

Contribute
----------

Get `json-endure` from GitHub (https://github.com/) and clone the
resources to your computer. For example, use the following command: 

>  git clone https://github.com/aburnheimer/json-endure.git

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
