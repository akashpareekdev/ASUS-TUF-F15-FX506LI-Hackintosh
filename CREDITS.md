# Credits

This EFI is only possible because of the work of the people and projects below. Huge thanks to all of them. If we missed anyone, please open an issue and we will add you right away.

## This repository
**Made by Akash Pareek & Ankit Pareek** — the assembled and tested EFI for the ASUS TUF Gaming F15 FX506LI, the ACPI SSDTs in `ACPI-src/`, the documentation and the helper script.

## Bootloader and core kexts — [Acidanthera](https://github.com/acidanthera)
- [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg) — OpenCore bootloader, `macrecovery`, sample configuration
- [Lilu](https://github.com/acidanthera/Lilu) — kext patching framework
- [VirtualSMC](https://github.com/acidanthera/VirtualSMC) — SMC emulation (SMCBatteryManager, SMCProcessor)
- [WhateverGreen](https://github.com/acidanthera/WhateverGreen) — graphics patching
- [AppleALC](https://github.com/acidanthera/AppleALC) — audio
- [RestrictEvents](https://github.com/acidanthera/RestrictEvents)
- [BrightnessKeys](https://github.com/acidanthera/BrightnessKeys)
- [VoodooPS2](https://github.com/acidanthera/VoodooPS2) — PS/2 keyboard (originally by RehabMan and contributors)
- [MacKernelSDK](https://github.com/acidanthera/MacKernelSDK) — used by the kexts below to build

## Other kexts
- [ECEnabler](https://github.com/1Revenger1/ECEnabler) — by **1Revenger1**
- [VoodooI2C](https://github.com/VoodooI2C/VoodooI2C) — by **Alexandre Daoud (alexandred)** and the VoodooI2C contributors (includes VoodooGPIO, VoodooI2CServices, VoodooInput, VoodooI2CHID)
- [RTL8111_driver_for_OS_X](https://github.com/Mieze/RTL8111_driver_for_OS_X) — Realtek Ethernet, by **Mieze**
- [USBToolBox kext](https://github.com/USBToolBox/kext) — USB mapping, by **USBToolBox**

## MediaTek MT7921 Wi-Fi and Bluetooth
- [SimpleMtkWlan](https://github.com/laobamac/SimpleMtkWlan) — original MT792x Wi-Fi driver by **laobamac (王孝慈)**
- [flxxxxddd/SimpleMtkWlan](https://github.com/flxxxxddd/SimpleMtkWlan) — the MT7921 fixes fork whose **AirportMtkWlan** build we use
- [pengubow/SimpleMtkWlan](https://github.com/pengubow/SimpleMtkWlan) — adapted AirportItlwm's native Wi-Fi front end to the MediaTek driver
- [laobamac/itlwm](https://github.com/laobamac/itlwm) and [OpenIntelWireless/itlwm](https://github.com/OpenIntelWireless/itlwm) — AirportItlwm / itlwm by **zxystd** and the OpenIntelWireless team
- [mavizao](https://github.com/mavizao) — MT7922 association/TX fixes (upstream PR #5)
- OpenBSD `mwx(4)` driver authors and the Linux [mt76](https://github.com/openwrt/mt76) developers — hardware reference for the driver
- [SimpleMtkBtFw](https://github.com/laobamac/SimpleMtkBtFw) — MediaTek Bluetooth firmware loader, by **laobamac**
- **Elias64Fr** — research on MediaTek Bluetooth support in macOS Sequoia/Tahoe ([tonymacx86 thread](https://www.tonymacx86.com/threads/wifi-6-e-bluetooth-5-x-mediatek-chipset-on-native-sequoia-tahoe.332855/))

## Guides and reference EFIs
- [Dortania — OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) and the [Vanilla Laptop Guide](https://dortania.github.io/vanilla-laptop-guide/) — the design of our SSDTs (PLUG, AWAC, EC-USBX, PNLF, XOSI) follows these guides
- [gaminghackintosh / Hackintosh-OpenCore-ASUS-FX506LH](https://github.com/gaminghackintosh/Hackintosh-OpenCore-ASUS-FX506LH) — an EFI for the sibling model FX506LH; we used it as a reference for the iGPU properties and a few boot arguments
- [VGerris / asus-tuf-15-opencore](https://github.com/VGerris/asus-tuf-15-opencore) — notes on the FX506L family (touchpad, display wiring)
- [RobyRew / ASUS-FX506LHB-Hackintosh_OpenCore](https://github.com/RobyRew/ASUS-FX506LHB-Hackintosh_OpenCore) — another FX506 guide we read for comparison

## Tools
- [Intel ACPICA (`iasl`)](https://www.intel.com/content/www/us/en/developer/topic-technology/open/acpica/download.html) — decompiling and compiling ACPI tables
- [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) by **CorpNewt** — recommended for generating your SMBIOS

## Tested but not used
- [NullMoth NVIDIA driver](https://github.com/nullmoth/nvidia-macos-driver) — we tested v2.6.6 on this laptop. It loaded but did not produce a display output here, so it is **not** part of this EFI. Thanks to its authors for the effort and for documenting laptop limitations honestly.
