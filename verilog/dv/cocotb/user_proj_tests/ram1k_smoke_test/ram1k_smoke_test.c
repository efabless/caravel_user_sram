// SPDX-FileCopyrightText: 2023 Efabless Corporation

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#define USER_ADDR_SPACE_C_HEADER_FILE  // TODO disable using the other file until tag is updated and https://github.com/efabless/caravel_mgmt_soc_litex/pull/137 is merged

#include <firmware_apis.h>
#include <custom_user_space.h>

void main(){
    // Enable managment gpio as output to use as indicator for finishing configuration  
    GPIOs_configure(32,GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_configure(33,GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_loadConfigs();
    User_enableIF(1);
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    GPIOs_writeHigh(0b10);

    // word
    int values[3] = {0x8e277123,0x8d24DFa7,0x184f9c7};
    int adresses[3] = {0,1,50};
    for (int i = 0; i < 3; i++){
        USER_writeWord(values[i],adresses[i]);
    }
    for (int i = 0; i < 3; i++){
        int data = USER_readWord(adresses[i]);
        if (data != values[i]) {
            GPIOs_writeHigh(0b01); // failure
            ManagmentGpio_write(1); // finish test
            return;
        }
    }
    
    // half word 
    short values_half[6] = {0x5771, 0x431F, 0x12A7, 0x1234, 0x5678, 0x9ABC};
    int adresses_half[6] = {212, 413, 82, 654, 31, 678};
    for (int first_half = 0; first_half < 2; first_half++){
        int initial = first_half * 3;
        for (int i = initial; i < 3+initial; i++){
            USER_writeHalfWord(values_half[i],adresses_half[i], first_half);
        }
        // GPIOs_writeHigh(0b10);
        for (int i = initial; i < 3+initial; i++){
            short data = USER_readHalfWord(adresses_half[i], first_half);
            if (data != values_half[i]) {
                GPIOs_writeHigh(0b01); // failure
                ManagmentGpio_write(1); // finish test
                return;
            }
        }
    }
    // byte
    char values_byte[12] = {0x2a, 0x85, 0x7b, 0x31, 0x4a, 0x67, 0xd9, 0x2e, 0x14, 0x5c, 0x73, 0xb7};
    int adresses_byte[12] = {26, 513, 231, 501, 710, 121, 938, 640, 323, 411, 62, 477};
    for (int byte_num = 0; byte_num < 3; byte_num++){
        int initial = byte_num * 3;
        for (int i = initial; i < 3+initial; i++){
            USER_writeByte(values_byte[i],adresses_byte[i], byte_num);
        }
        for (int i = initial; i < 3+initial; i++){
            char data = USER_readByte(adresses_byte[i], byte_num);
            if (data != values_byte[i]) {
                GPIOs_writeHigh(0b01); // failure
                ManagmentGpio_write(1); // finish test
                return;
            }
        }
    }

    // try write read
    int values_wr[3] = {0x12345678, 0x98765432, 0xbaadf00d};
    int adresses_wr[3] = {23, 422, 578};
    for (int i = 0; i < 3; i++){
        USER_writeWord(values_wr[i],adresses_wr[i]);
        int data = USER_readWord(adresses_wr[i]);
        if (data != values_wr[i]) {
            GPIOs_writeHigh(0b01); // failure
            ManagmentGpio_write(1); // finish test
            return;
        }
    }
    ManagmentGpio_write(1); // finish test

}