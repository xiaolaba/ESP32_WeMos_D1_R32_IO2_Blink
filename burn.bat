REM uses flash mode DIO, ESP32
REM 2022-10-09, ESP32_Frequency_generation_2MHz_10MHz.ino firmware
REM burn test ok

:: To erase esp32 completely, do not rely on Arduino IDE and code upload, it has cluster and odd thing when uses FATFS, 
:: unless format SPIFFS or FATFS everytime on the fly
:: xiaolaba, 2020-MAR-02
:: Arduino 1.8.16, esptool and path,

REM %userprofile%

cls
prompt $xiao

set 

set comport=COM7
REM set esptoolpath="C:\Users\user0\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.2.1/esptool.exe"
set esptoolpath="esptool_5.1.0.exe"

set MCU=esp32
set BAUDRATE=921600
REM set BAUDRATE=512000

set project=ESP32_WeMos_D1_R32_IO2_Blink.ino


::goto flash_chip

%esptoolpath% --chip %MCU% ^
merge-bin -o "merged.bin" ^
--pad-to-size 4MB ^
--flash-mode keep ^
--flash-freq keep ^
--flash-size keep ^
0x1000 "%project%.bootloader.bin" ^
0x8000 "%project%.partitions.bin" ^
0xe000 "boot_app0.bin" ^
0x10000 "%project%.bin"


:: erase whole flash of esp32
%esptoolpath% --chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
erase_flash



REM pause

REM burn firmware
%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
--before default-reset ^
--after hard-reset ^
write-flash -z ^
--flash-mode dio ^
--flash-freq 80m ^
--flash-size detect ^
0x1000 "%project%.bootloader.bin" ^
0x8000 "%project%.partitions.bin" ^
0xe000 "boot_app0.bin" ^
0x10000 "%project%.bin"
REM 0x0 merged.bin
goto end


:flash_chip
%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
--before default-reset ^
--after hard-reset ^
write-flash -z ^
--flash-mode keep ^
--flash-freq keep ^
--flash-size keep ^
0x1000 ESP32_WeMos_D1_R32_IO2_Blink.ino.bootloader.bin ^
0x8000 ESP32_WeMos_D1_R32_IO2_Blink.ino.partitions.bin ^
0xe000 boot_app0.bin ^
0x10000 ESP32_WeMos_D1_R32_IO2_Blink.ino.bin



:end
pause