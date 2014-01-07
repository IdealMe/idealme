#!/bin/bash

cd /usr/local/src/
tar xvfj {{ phantomjs_tarball }}
cd {{ phantomjs_tardir }}
cp bin/phantomjs {{ phantomjs_path }}/bin

