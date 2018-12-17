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

import tables
import ./structures

proc `+`*[K; V: AdditiveMonoid](s, t: TableRef[K, V]): TableRef[K, V] =
  new result
  result[] = initTable[K, V]()
  for k, v in s:
    if t.hasKey(k):
      result[k] = v + t[k]
    else:
      result[k] = v
  for k, v in t:
    if not s.hasKey(k):
      result[k] = v

proc `zero`*[K, V](s: typedesc[TableRef[K, V]]): TableRef[K, V] =
  new result
  result[] = initTable[K, V]()