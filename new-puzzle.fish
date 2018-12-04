#!/usr/bin/env fish

set next_day (math 1 + (count *.playground))
set playground (printf Day%02d.playground $next_day)

mkdir $playground

if contains -- --download-input $argv
  set -l url https://adventofcode.com/2018/day/$next_day/input
  set -l cookie session=(cat AOC_SESSION_COOKIE)
  mkdir $playground/Resources
  curl $url --cookie $cookie > $playground/Resources/Input.txt
end


echo > $playground/contents.xcplayground '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<playground version="5.0" target-platform="macos" executeOnSourceChanges="false">
    <timeline fileName="timeline.xctimeline"/>
</playground>'


echo > $playground/Contents.swift 'import Foundation

let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
let inputLines = inputString.split(separator: "\n")

'


set workspace ./AdventOfCode.xcworkspace/contents.xcworkspacedata
echo > $workspace '<?xml version="1.0" encoding="UTF-8"?>
<Workspace version="1.0">'
for playground in *.playground
  echo >> $workspace "<FileRef location=\"group:$playground\"></FileRef>"
end
echo >> $workspace '</Workspace>'


xed ./AdventOfCode.xcworkspace
