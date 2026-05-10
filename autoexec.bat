startDriver TuyaMCU
tuyaMcu_setBaudRate 9600
tuyaMcu_defWiFiState 4

// Konfigurasi MQTT (HiveMQ Public)
MQTTHost broker.hivemq.com
MQTTPort 1883
MQTTUser ""
MQTTPass ""
SetMQTTClient buterfly/device/gorden/%SHORTNAME%
SetMQTTTopic buterfly/device/gorden/%SHORTNAME%

setFlag 10 1
setFlag 11 1
setFlag 51 1

startDriver NTP
ntp_setServer 216.239.35.0
ntp_timeZoneOfs 7

// Hardware Mapping
linkTuyaMCUOutputToChannel 1 4 1
setChannelType 1 OpenStopClose
setChannelLabel 1 "Control"

linkTuyaMCUOutputToChannel 101 4 3
setChannelType 3 ReadOnlyEnum
setChannelEnum 3 0:Stopped 3:Opening 4:Closing
setChannelLabel 3 "Status"

setChannelType 12 Percent
setChannelLabel 12 "Current Position"
setChannelType 13 Dimmer
setChannelLabel 13 "Set Target (%)"
setChannelType 10 TimerSeconds
setChannelLabel 10 "Last Travel Time"
setChannelType 11 TimerSeconds
setChannelLabel 11 "Calibration Max"
setChannelType 14 Toggle
setChannelLabel 14 "SAVE CALIBRATION"
setChannelType 15 ReadOnlyEnum
setChannelLabel 15 "Script Status"
setChannelType 16 Toggle
setChannelLabel 16 "MODE: CALIBRATION"
setChannelType 17 TextField
setChannelLabel 17 "SCHED: Morning (HHMM)"
setChannelType 18 TextField
setChannelLabel 18 "SCHED: Evening (HHMM)"
setChannelType 19 TextField
setChannelLabel 19 "SCHED: Days Bitmask"
setChannelType 41 Dimmer
setChannelLabel 41 "POS: Custom Open (%)"
setChannelType 42 Dimmer
setChannelLabel 42 "POS: Custom Close (%)"

delay_s 1

// Ambil nilai Kalibrasi & Posisi dari NVM
setChannel 11 $CH201
setChannel 12 $CH202
setChannel 13 $CH12
SetStartValue 12 -1

// Ambil nilai Jadwal & Mode dari NVM
setChannel 17 $CH203
setChannel 18 $CH204
setChannel 19 $CH207
setChannel 41 $CH208
setChannel 42 $CH209

// Nilai default jika memori kosong (Reset)
if $CH17==0 then backlog setChannel 17 700; setChannel 203 700
if $CH18==0 then backlog setChannel 18 1800; setChannel 204 1800
if $CH19==0 then backlog setChannel 19 127; setChannel 207 127
if $CH41==0 then backlog setChannel 41 100; setChannel 208 100

echo "System Ready - Automated Schedule Loaded"

// Jalankan Otak Penjadwal & Pelapor Status
startScript scheduler.obk init

startScript cb3s_curtain.obk
tuyaMcu_sendQueryState
