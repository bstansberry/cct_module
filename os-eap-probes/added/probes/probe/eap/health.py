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

class HealthProbe(HttpManagementProbe):
    """
    A Probe implementation that sends a MicroProfile Health Check request to a server 
    using EAP's management interface.
    """

    def __init__(self, tests = []):
        super(HealthProbe, self).__init__(
            [
                HealthCheckTest()
            ]
        )

    def getTestInput(self, results, testIndex):
        return results

    def createRequest(self):
        return {}

    def sendRequest(self, request):
        return sendRequest(self, "health",request)

class HealthCheckTest(Test):
    """
    Checks the status of the server.
    """

    def __init__(self):
        super(HealthCheckTest, self).__init__(
            {
            }
        )

    def evaluate(self, results):


        if response.status_code == 200:
            return (Status.READY, response.json(object_pairs_hook = OrderedDict))
        if response.status_code == 503:
            return (Status.NOT_READY, response.json(object_pairs_hook = OrderedDict))
        if response.status_code == 501:
            return (Status.FAILURE, response.json(object_pairs_hook = OrderedDict))
        if response.status_code == 404:
            """
            Treat a 404 as indicating the health-check subsystem is not installed, which is valid,
            but we can only say READY and rely on other probes.
            """
            if self.logger.isEnabledFor(logging.DEBUG):
                self.logger.debug("Probe request = %s", json.dumps(request, indent=4, separators=(',', ': ')))
            return (Status.READY, {})

        """
        Other response codes are not defined in the Healh Check spec, so are exception cases
        """
        self.logger.error("Probe request failed.  Status code: %s", response.status_code)
        raise Exception("Probe request failed, code: " + str(response.status_code) + str(url) + str(request) + str(response.json(object_pairs_hook = OrderedDict)))
        
