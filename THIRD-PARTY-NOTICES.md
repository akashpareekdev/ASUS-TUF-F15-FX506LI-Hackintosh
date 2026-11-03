# Third-party notices

The `EFI/` folder contains **unmodified binaries** from the projects below. They are **not** covered by this repository's MIT licence; each keeps its own licence and copyright. Please read the licence in each project's repository before redistributing or using them commercially.

| Component | Version in this EFI | Source | Licence |
|---|---|---|---|
| OpenCorePkg (`OpenCore.efi`, `BOOTx64.efi`, `OpenRuntime.efi`, `OpenHfsPlus.efi`, `ResetNvramEntry.efi`) | 1.0.8 | https://github.com/acidanthera/OpenCorePkg | BSD-3-Clause |
| Lilu | 1.7.2 | https://github.com/acidanthera/Lilu | see repository |
| VirtualSMC (+ SMCBatteryManager, SMCProcessor) | 1.3.8 | https://github.com/acidanthera/VirtualSMC | see repository |
| WhateverGreen | 1.7.1 | https://github.com/acidanthera/WhateverGreen | see repository |
| AppleALC | 1.9.8 | https://github.com/acidanthera/AppleALC | see repository |
| RestrictEvents | 1.1.6 | https://github.com/acidanthera/RestrictEvents | see repository |
| BrightnessKeys | 1.0.3 | https://github.com/acidanthera/BrightnessKeys | see repository |
| VoodooPS2Controller | 2.3.7 | https://github.com/acidanthera/VoodooPS2 | see repository |
| ECEnabler | 1.0.6 | https://github.com/1Revenger1/ECEnabler | see repository |
| VoodooI2C (+ plug-ins) / VoodooI2CHID | 2.9.1 / 1.0 | https://github.com/VoodooI2C/VoodooI2C | see repository |
| RealtekRTL8111 | 3.0.0 | https://github.com/Mieze/RTL8111_driver_for_OS_X | see repository |
| USBToolBox / UTBDefault | 1.2.0 / 1.0 | https://github.com/USBToolBox/kext | see repository |
| SimpleMtkBtFw / SimpleMtkBtPatcher | 1.0.0 | https://github.com/laobamac/SimpleMtkBtFw | GPL-3.0 |
| AirportMtkWlan (built from the SimpleMtkWlan fork) | 1.5.0 | https://github.com/flxxxxddd/SimpleMtkWlan | GPL-2.0 (some files carry additional upstream notices) |

**Firmware:** the Wi-Fi/Bluetooth kexts embed MediaTek firmware, which their projects state is redistributed under the MediaTek firmware licence (as in `linux-firmware`).

**Source code:** for GPL components, the corresponding source is available in the linked repositories.

**Takedown / corrections:** if you are a rights holder and want a file removed or a notice corrected, open an issue and we will act on it promptly.

## Our own files (MIT)

`EFI/OC/config.plist`, `EFI/OC/ACPI/*.aml`, `ACPI-src/*.dsl`, `docs/`, `scripts/` and this repository's text are © 2026 Akash Pareek & Ankit Pareek, released under the MIT License (see `LICENSE`).
