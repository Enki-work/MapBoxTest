#!/bin/bash

set -eo pipefail

xcodebuild -project MapBoxTest.xcodeproj -scheme MapBoxTest -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max' | xcpretty
