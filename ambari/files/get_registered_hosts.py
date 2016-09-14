#!/usr/bin/env python

import json, sys
try:
	a = json.load(sys.stdin)
	print len(a["items"])
except:
	print 0