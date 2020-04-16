#!/bin/bash

set -eo pipefail

xcodebuild -project MapBoxTest.xcodeproj \
            -scheme MapBoxTest\ iOS \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty
