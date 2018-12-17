# Copyright 2016-18 UniCredit S.p.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mode = ScriptMode.Verbose

packageName   = "emmy"
version       = "0.1.0"
author        = "Andrea Ferretti"
description   = "Algebra for Nim"
license       = "Apache2"
skipDirs      = @["tests"]
skipFiles     = @["emmy.html", "emmy.png"]

requires "nim >= 0.19", "bigints >= 0.4.2", "stint >= 0.0.1"

--forceBuild

task tests, "run emmy tests":
  --hints: off
  --linedir: on
  --stacktrace: on
  --linetrace: on
  --debuginfo
  --path: "."
  --run
  --define: reportConceptFailures
  setCommand "c", "tests/all.nim"

task test, "run emmy tests":
  setCommand "tests"