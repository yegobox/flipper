#!/bin/bash
for i in {1..1000}; do flutter test --dart-define=Test=true; done
