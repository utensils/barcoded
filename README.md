# Barcoded

Barcoded intends to provide a simple API for the generation barcodes in multiple symbologies.

[![Build Status](https://travis-ci.org/doomspork/barcoded.png?branch=master)](https://travis-ci.org/doomspork/barcoded) [![Code Climate](https://codeclimate.com/github/doomspork/barcoded.png)](https://codeclimate.com/github/doomspork/barcoded) [![Coverage Status](https://coveralls.io/repos/doomspork/barcoded/badge.png?branch=master)](https://coveralls.io/r/doomspork/barcoded)

## Getting Started

1. Install the required software dependencies if you have not already:

    + Ruby 2.0+
    
    + ImageMagick 6.8+

2. At the command prompt, clone the project:

	`git clone git@github.com/doomspork/barcoded`

3. Change directory to `barcoded` and install our gems:

	`bundle install`

4. At last we are ready to get this show on the road:

	`bundle exec rackup`

## Symbologies

+ [Bookland](http://en.wikipedia.org/wiki/Bookland)
+ [Code 128](http://en.wikipedia.org/wiki/Code_128)
+ [Code 25 Interleaved 2 of 5](http://en.wikipedia.org/wiki/Interleaved_2_of_5)
+ [Code 39](http://en.wikipedia.org/wiki/Code_39)
+ [Code 93](http://en.wikipedia.org/wiki/Code_93)
+ [EAN-13](http://en.wikipedia.org/wiki/EAN-13)
+ [EAN-8](http://en.wikipedia.org/wiki/EAN-8)
+ [GS1 128](http://en.wikipedia.org/wiki/GS1-128)
+ [IATA](http://en.wikipedia.org/wiki/International_Air_Transport_Association)
+ [QR Code](http://en.wikipedia.org/wiki/QR_code)
+ [UPC-A](http://en.wikipedia.org/wiki/Universal_Product_Code)
+ [UPC/EAN Supplemental 2](http://en.wikipedia.org/wiki/EAN_2)
+ [UPC/EAN Supplemental 5](http://en.wikipedia.org/wiki/EAN_5)

## Formats

+ PNG
+ GIF
+ JPEG
+ SVG

## Why?

Businesses need barcodes and adding support to legacy systems for new symbologies can be non-trival, enter Barcoded.  Leveraging our simple API businesses can generate barcodes in multiple symbologies on-demand without ever making a code change.

## Testing

1. As simple as:

	`bundle exec rspec`

## Contributing

Feedback and features welcome!  Please make use of [Issues](https://github.com/doomspork/barcoded/issues) and [Pull Requests](https://github.com/doomspork/barcoded/pulls), all code must have accompanying specs.

## Author/Contact

Barcoded is written and maintained by [@doomspork](github.com/doomspork).

## License

The project is made available under the [MIT](http://opensource.org/licenses/MIT) License.
