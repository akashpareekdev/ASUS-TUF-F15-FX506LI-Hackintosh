# ASUS TUF Gaming F15 (FX506LI) — OpenCore Hackintosh EFI

![OpenCore](https://img.shields.io/badge/OpenCore-1.0.8-blue)
![macOS](https://img.shields.io/badge/macOS-Sequoia%2015.8.2-lightgrey)
![Laptop](https://img.shields.io/badge/ASUS%20TUF%20F15-FX506LI-red)
![License](https://img.shields.io/badge/license-MIT-green)

A working OpenCore EFI, ACPI patches and notes for the **ASUS TUF Gaming F15 FX506LI** (i5-10300H, UHD 630 + GTX 1650 Ti, MediaTek MT7921 Wi-Fi/Bluetooth). **Wi-Fi, Ethernet, Bluetooth, touchpad, sound, brightness, battery and sleep/wake all work, and Metal is enabled** (Wi-Fi even works in the installer). We could not find a build for this exact model, so we are sharing ours together with every problem we hit and how we solved it.

**Made by Akash Pareek & Ankit Pareek**

> **Heads-up:** this is tested on **macOS Sequoia 15.8.2** only. Read [Status](#status) and [Known issues](#known-issues) before you start. Generate your **own SMBIOS** — the serial numbers in this repo are placeholders (see [docs/SMBIOS.md](docs/SMBIOS.md)).

---

## Table of contents
- [Hardware](#hardware)
- [Status](#status)
- [What is in this repo](#what-is-in-this-repo)
- [Quick start](#quick-start)
- [Kexts and versions](#kexts-and-versions)
- [ACPI patches](#acpi-patches)
- [Problems we hit and how we solved them](#problems-we-hit-and-how-we-solved-them)
- [Known issues](#known-issues)
- [Credits](#credits)
- [Disclaimer](#disclaimer)
- [License](#license)

## Hardware

| Part | Model | Notes |
|---|---|---|
| Laptop | ASUS TUF Gaming F15 **FX506LI** | BIOS `FX506LI.310` (2021-11-26) |
| CPU | Intel Core i5-10300H (Comet Lake-H, 4C/8T) | |
| iGPU | Intel UHD Graphics 630 (`8086:9BC4`) | drives the built-in 1920×1080 144 Hz panel |
| dGPU | NVIDIA GeForce GTX 1650 Ti (`10DE:1F95`) | no Apple driver — hidden by default (`-wegnoegpu`); optional experimental driver, see [docs/NVIDIA.md](docs/NVIDIA.md) |
| Wi-Fi / Bluetooth | MediaTek MT7921 (PCI `14C3:7961`, BT USB `13D3:3563`) | experimental community drivers, see below |
| Ethernet | Realtek RTL8168 (`10EC:8168`) | RealtekRTL8111 kext |
| Audio | Realtek HDA codec | AppleALC, layout `17` |
| Touchpad | I²C (ELAN/Synaptics HID) | VoodooI2C, needs the `_OSI` patch |
| RAM | 16 GB | |
| Storage | Micron 512 GB NVMe + 1 TB HDD | macOS installed on its own NVMe partition |

## Status

macOS **Sequoia 15.8.2** installed on an internal NVMe partition, dual-booting with Windows 11.

| Feature | Status |
|---|---|
| Install + boot (OpenCore 1.0.8) | ✅ confirmed |
| Intel UHD 630 graphics — **GPU acceleration with Metal** (shown in About This Mac), built-in display 1920×1080 | ✅ **works** |
| Wi-Fi (MediaTek MT7921, native menu) | ✅ **works** — also in the installer, where we used it to download macOS |
| Ethernet (Realtek RTL8168) | ✅ **works** |
| Battery (percentage and charging state) | ✅ **works** |
| Audio (speakers / headphones) | ✅ **works** |
| Touchpad (I²C) and keyboard | ✅ **works** |
| Volume / media keys | ✅ **works** |
| Brightness control | ✅ **works** |
| Bluetooth (MT7921) | ✅ **works** |
| Sleep / wake | ✅ **works** |
| USB ports | ✅ **work** with the included default map — they are **not individually mapped** yet (see Known issues) |
| Microphone | ⚠️ not verified |
| Webcam, card reader | ⚠️ not verified |
| NVIDIA GTX 1650 Ti (second GPU) | ✅⚠️ **experimental, optional** — hidden by default. With the third-party NullMoth driver it is **active with Metal**, but there is **no external display output** (HDMI / USB-C video). See [docs/NVIDIA.md](docs/NVIDIA.md) |

> We will keep this table honest. If you test more features, please open an issue or PR.

## What is in this repo

```
EFI/              OpenCore 1.0.8 EFI (BOOT + OC): config.plist, ACPI .aml, drivers, kexts
EFI/OC/config-nvidia.plist   optional, experimental NVIDIA config (see docs/NVIDIA.md)
ACPI-src/         Source (.dsl) of our SSDTs, so you can read and rebuild them
docs/             Install guide, BIOS settings, SMBIOS, ACPI notes, troubleshooting
scripts/          Helper for macOS (turn off automatic software updates)
CREDITS.md        Everyone whose work this builds on
THIRD-PARTY-NOTICES.md   Components, versions and their licences
```

## Quick start

1. Set the **BIOS** options in [docs/BIOS-SETTINGS.md](docs/BIOS-SETTINGS.md).
2. **Generate your own SMBIOS** and put it in `EFI/OC/config.plist` → `PlatformInfo → Generic` ([docs/SMBIOS.md](docs/SMBIOS.md)).
3. Build the installer USB and install macOS — full steps in [docs/INSTALL.md](docs/INSTALL.md).
4. After the first boot, copy the EFI to your internal EFI partition and (optionally) map your USB ports.
5. Run `scripts/disable-macos-updates.command` if you want to stop automatic updates from breaking the setup.

## Kexts and versions

Load order matters. All are loaded from `EFI/OC/Kexts` in this order:

| Kext | Version | Purpose |
|---|---|---|
| Lilu | 1.7.2 | patching framework |
| VirtualSMC | 1.3.8 | SMC emulation |
| WhateverGreen | 1.7.1 | iGPU patches, disable dGPU |
| AppleALC | 1.9.8 | audio |
| RestrictEvents | 1.1.6 | misc. macOS restrictions |
| ECEnabler | 1.0.6 | read 16-bit+ EC fields (battery) |
| SMCBatteryManager | 1.3.8 | battery status |
| SMCProcessor | 1.3.8 | CPU sensors |
| BrightnessKeys | 1.0.3 | brightness hotkeys |
| RealtekRTL8111 | 3.0.0 | Ethernet |
| USBToolBox + UTBDefault | 1.2.0 / 1.0 | USB (default map; replace with your own map) |
| VoodooPS2Controller (+ Keyboard) | 2.3.7 | PS/2 keyboard |
| VoodooI2C (+ GPIO, Services, Input) + VoodooI2CHID | 2.9.1 / 1.0 | I²C touchpad |
| SimpleMtkBtFw + SimpleMtkBtPatcher | 1.0.0 | MediaTek Bluetooth firmware loader |
| AirportMtkWlan | 1.5.0 | MediaTek MT7921 Wi-Fi (Sequoia 15.2+ build, native Wi-Fi menu) |

OpenCore itself: **1.0.8**. Drivers: `OpenRuntime.efi`, `OpenHfsPlus.efi`, `ResetNvramEntry.efi`.

## ACPI patches

Five small SSDTs plus one rename patch. Source is in [ACPI-src/](ACPI-src/); explanation in [docs/ACPI.md](docs/ACPI.md).

| File | What it fixes |
|---|---|
| `SSDT-PLUG.aml` | CPU power management (`\_SB.PR00`, `plugin-type`) |
| `SSDT-AWAC.aml` | enables the legacy RTC (the firmware ships the AWAC clock) |
| `SSDT-EC-USBX.aml` | stand-in `EC` device for macOS + USB power properties |
| `SSDT-PNLF.aml` | backlight device for the built-in panel |
| `SSDT-XOSI.aml` + patch `_OSI → XOSI` | tells the firmware "Windows 2015" so the I²C touchpad turns on |

## Problems we hit and how we solved them

Short version — the full write-up with settings is in [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

**Problems that actually happened to us (install and boot):**

| Problem | Solution |
|---|---|
| Installer: *"Your Mac needs a firmware update in order to install to this volume"* | `UEFI → APFS → MinDate = -1`, `MinVersion = -1` |
| OpenCore froze right after choosing the USB recovery | `UEFI → Quirks → ReleaseUsbOwnership = False` |
| OpenCore stops with *"No schema for HideSelf"* | that key no longer exists in OpenCore 1.0.x — check every key against `Docs/Sample.plist` |
| Installer media dropping out (I/O timeouts) | use a different, reliable USB stick/cable |
| Dual-boot: Windows keeps reordering the boot list, or shows two Windows entries | we boot Windows by default and use the **Esc boot menu** for OpenCore; duplicate firmware entries removed with `bcdedit /delete` |
| NVIDIA card has no Apple driver | hidden by default with `-wegnoegpu`. Optional experiment: `config-nvidia.plist` + the NullMoth driver makes it active with Metal, but gives no external display ([docs/NVIDIA.md](docs/NVIDIA.md)) |
| No Wi-Fi: MT7921 has no Apple driver | community driver **AirportMtkWlan** (Sequoia build), kernel range `24.2.0–24.99.99`, `DisableIoMapper = True` |
| Bluetooth (`13D3:3563`) not recognised by stock macOS | **SimpleMtkBtFw** + **SimpleMtkBtPatcher** (has a personality for this exact ID) |

**Issues we found in the firmware tables and handled up front** (read from the DSDT — touchpad, battery and brightness all work with these fixes):

| Issue | What the config does |
|---|---|
| I²C touchpad is only enabled for "Windows 2012+" | `_OSI → XOSI` rename + `SSDT-XOSI`, VoodooI2C |
| Battery reads 16-bit EC fields | **ECEnabler** + SMCBatteryManager |
| `AWAC` clock device, `EC0` not named `EC` | `SSDT-AWAC`, `SSDT-EC-USBX` |
| No backlight device | `SSDT-PNLF` (UID `0x13`) + WhateverGreen args `-igfxblt -igfxblr` |

## Known issues

- **External displays do not work** (HDMI and USB-C video are wired to the NVIDIA GPU). A USB-C dock with its own video output is the only route.
- The **Wi-Fi driver is experimental** (no Wi-Fi 6, no WPA3-only, no AirDrop/Handoff). It can fail on future macOS updates.
- **Turn off automatic updates** — updates can break kexts or the Wi-Fi driver.
- USB ports are not mapped; the included `UTBDefault.kext` is a placeholder.
- Only **Sequoia 15.8.2** has been tested. macOS Tahoe is untested with this EFI.

## Credits

This EFI stands on the work of many people — **please read [CREDITS.md](CREDITS.md)**. In short: Acidanthera (OpenCore, Lilu, VirtualSMC, WhateverGreen, AppleALC and more), the VoodooI2C team, Mieze, 1Revenger1, USBToolBox, laobamac / flxxxxddd / pengubow and the OpenIntelWireless project (MediaTek Wi-Fi/Bluetooth), the Dortania guides, and the authors of earlier ASUS TUF F15 EFIs.

## Disclaimer

This project is provided **as is, without warranty**. Installing macOS on non-Apple hardware may violate Apple's licence agreement; you are responsible for how you use this. No Apple software is included in this repository. Back up your data and your EFI before you try anything. *Apple, Mac, macOS and Sequoia are trademarks of Apple Inc. This project is not affiliated with or endorsed by Apple, ASUS, Intel, NVIDIA or MediaTek.*

## License

Our own work (configuration, ACPI sources, documentation and scripts) is released under the **MIT License** — see [LICENSE](LICENSE). The third-party binaries in `EFI/` keep **their own licences** — see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

---

*Made by Akash Pareek & Ankit Pareek.*
