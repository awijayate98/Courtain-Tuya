startDriver TuyaMCU
tuyaMcu_setBaudRate 9600
tuyaMcu_defWiFiState 4

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

delay_s 1

// Ambil nilai Kalibrasi dari CH201 ke CH11
setChannel 11 $CH201
// Ambil nilai Posisi Terakhir dari CH202 ke CH12
setChannel 12 $CH202
setChannel 13 $CH12
SetStartValue 12 -1

// --- JADWAL OTOMATIS (Format: Jam Hari ID Perintah) ---
// ID 1 untuk Pagi, ID 2 untuk Sore
addClockEvent 07:00 1234567 1 setChannel 13 100
addClockEvent 18:00 1234567 2 setChannel 13 0

echo "Automated Schedule Loaded"

startScript cb3s_curtain.obk
tuyaMcu_sendQueryState