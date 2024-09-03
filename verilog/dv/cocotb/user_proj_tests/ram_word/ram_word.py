# SPDX-FileCopyrightText: 2023 Efabless Corporation

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SPDX-License-Identifier: Apache-2.0


from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb 

@cocotb.test()
@report_test
async def ram_word(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=899394)

    cocotb.log.info(f"[TEST] Start ram_word test")  
    
    await caravelEnv.wait_mgmt_gpio(1) # wait until writing 7 through la 
    if caravelEnv.monitor_gpio(33, 32).integer == 0b10:
        cocotb.log.info (f"[TEST] Pass the gpio value is '{hex(caravelEnv.monitor_gpio(33, 32).integer)}'")
    elif caravelEnv.monitor_gpio(33, 32).integer == 0b01:
        cocotb.log.error (f"[TEST] fail in reading memory value")  
    else:
        cocotb.log.error (f"[TEST] Fail the gpio value is unknown :'{bin(caravelEnv.monitor_gpio(33, 32).integer)}' expected {bin(0b10)} or {bin(0b01)}")    
