"""
Copyright 2017 Red Hat, Inc.

Red Hat licenses this file to you under the Apache License, version
2.0 (the "License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.
"""

import json
import logging
import os
import requests
import sys

from collections import OrderedDict

from probe import HttpManagementProbe
from probe.api import qualifiedClassName, BatchingProbe, Status, Test

class DmrProbe(HttpManagementProbe):
    """
    A Probe implementation that sends a batch of queries to a server using EAP's
    management interface.  Tests should provide JSON queries specific to EAP's
    management interface and should be able to handle DMR results.
    """

    def __init__(self, tests = []):
        super(DmrProbe, self).__init__(tests)

    def getTestInput(self, results, testIndex):
        return results["result"].values()[testIndex]

    def createRequest(self):
        steps = []
        for test in self.tests:
            steps.append(test.getQuery())
        return {
                    "operation": "composite",
                    "address": [],
                    "json.pretty": 1,
                    "steps": steps
                }

    def sendRequest(self, request):
        response = sendRequest(self, "management", request)

        if response.status_code != 200:
            self.logger.error("Probe request failed.  Status code: %s", response.status_code)
            raise Exception("Probe request failed, code: " + str(response.status_code) + str(url) + str(request) + str(response.json(object_pairs_hook = OrderedDict)))

        return response.json(object_pairs_hook = OrderedDict)
