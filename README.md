# Jazor

Jazor (JSON razor) is a simple command line JSON parsing tool.

## Installation

    gem install jazor

## Usage

    jazor [options] [source] [expression ...]

### Options

See the **--help** command line option.

### Sources

The **source** argument refers to a file, URL or string containing a JSON object.
Since attempts to implement a full-featured HTTP client within Jazor would have
been futile, Jazor also accepts input from STDIN. This means if you ever need
to use an advanced HTTP option that Jazor doesn't implement, you can always use
a *real* HTTP client (e.g. [cURL](http://curl.haxx.se/)) and simply pipe the
output to Jazor.

### Expressions

Jazor accepts one or more Ruby **expressions** which are simply eval'ed within
the context of your JSON object. After Jazor parses your JSON input into native
Ruby data types (Hash, Array, etc.), these expressions are used to slice and
dice the data any way you want. The results will be "pretty printed" to STDOUT.

Note that hash keys can be accessed via standard Ruby (e.g. foo['bar'],
foo.fetch('bar'), etc.) or Javascript (e.g. foo.bar) syntax.

### Expression Testing

Expression testing (**--test**) allows you to test the "truthiness" of your
expression results. If any expression returns a "falsy" value, Jazor will exit
with a non-zero return code. This is useful for calling Jazor from within shell
scripts.

## Examples

    $ jazor http://github.com/api/v2/json/commits/list/mconigliaro/jazor/master commits.count
    16

    $ curl --silent http://github.com/api/v2/json/commits/list/mconigliaro/jazor/master | jazor commits.last.message
    initial commit

    $ jazor '{ "foo": "abc", "bar": [1, 2, 3] }' 'foo.split(//)'
    ["a", "b", "c"]

    $ jazor '{ "foo": "abc", "bar": [1, 2, 3] }' 'bar.inject { |memo,obj| memo + obj }'
    6

    $ jazor '[1, 2, 3, 4, 5]' 'select(&:even?)'
    [2, 4]

    $ jazor '[1, 2, 3, 4, 5]' 'select(&:odd?)'
    [1, 3, 5]

    $ jazor '["a", "b", "c", "d", "e"]' 'self[1..3]'
    ["b", "c", "d"]

    $ jazor '[1, 2, 3, 4, 5]' "'odds=%s; evens=%s' % [select(&:odd?).join(','), select(&:even?).join(',')]"
    odds=1,3,5; evens=2,4

## Change Log

### 0.1.4 (2012-03-05)

* Add --quirks-mode option
* Update all dependencies
* Refactoring

### 0.1.3 (2011-12-13)

* Handle HTTPS URLs
* Use .rvmrc and Bundler in project
* Convert tests from Test::Unit to RSpec

### 0.1.2 (2011-08-24)

* Apply sort after evaluating expression

### 0.1.1 (2011-08-24)

* Added sort option (Dan Hopkins)

### 0.1.0 (2011-08-23)

* Code refactoring
* Documentation rewrite
* Changed test option to a switch that operates on all expressions

### 0.0.4 (2011-01-25)

* Print help summary on absence of input
* Bug fixes

### 0.0.3 (2011-01-25)

* Bug fixes

### 0.0.2 (2011-01-24)

* Initial public release

## Licence

Copyright (C) 2012 Michael Paul Thomas Conigliaro

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Credits

* [Michael Paul Thomas Conigliaro](http://conigliaro.org): Original author
* [Daniel Hopkins](https://github.com/danielhopkins): Sorted output
