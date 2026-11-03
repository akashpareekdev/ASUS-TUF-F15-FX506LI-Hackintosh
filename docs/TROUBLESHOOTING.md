# Troubleshooting — problems we hit and how we solved them

Everything below happened to us while building this EFI. Setting names are the ones in OpenCore 1.0.8's `config.plist`.

## Installer: "Your Mac needs a firmware update in order to install to this volume"

**Symptom:** the Sequoia installer lists the target disk but refuses it and suggests a Mac OS Extended volume.

**Cause:** OpenCore's APFS driver version/date check rejects the newer APFS format the installer created.

**Fix:** `UEFI → APFS → MinDate = -1` and `MinVersion = -1` (already set in this EFI). Fallback: erase the target as *Mac OS Extended (Journaled)* and let the installer convert it.

## OpenCore froze right after choosing "macOS Base System" from the USB

**Cause:** `UEFI → Quirks → ReleaseUsbOwnership = True` can hang a boot that is running *from* a USB drive.

**Fix:** set it to `False` (done). The first screens are slow anyway: the 850 MB recovery image is loaded into RAM, so wait a few minutes.

## OpenCore stops with "No schema for HideSelf at Misc → Boot"

**Cause:** that key existed in older OpenCore versions and was removed; OpenCore 1.0.x validates strictly and refuses to start.

**Fix:** delete the key. In general, compare every key you add against `Docs/Sample.plist` of your OpenCore version (`ocvalidate` does this too).

## Wi-Fi: MediaTek MT7921 has no Apple driver

**What we used:** the community driver **AirportMtkWlan** (Sequoia build). It presents the card as a normal Wi-Fi interface (native menu, no helper app).

**Settings that matter:**
- Kext load range `MinKernel = 24.2.0`, `MaxKernel = 24.99.99` (each build only fits one macOS generation; the wrong one panics).
- `Kernel → Quirks → DisableIoMapper = True` (the driver does not support DMA remapping).
- Do **not** add OCLP "modern wireless" patches or touch `IOSkywalkFamily`.
- Make sure nothing hides the card (no `vendor-id`/`device-id = 0xFFFF` SSDT).

**Result:** Wi-Fi works for us, including **inside the macOS installer** (we downloaded macOS over it) and from the native Wi-Fi menu after install.

**Limits:** no Wi-Fi 6, no WPA3-only networks, no AirDrop/Handoff. It is experimental — read the project's README for the current status.

## Bluetooth: MT7921 (`13D3:3563`) not recognised

**Fix:** **SimpleMtkBtFw.kext** + **SimpleMtkBtPatcher.kext** (in this order, after Lilu). SimpleMtkBtFw has a personality for exactly `13D3:3563`. Do not add another Bluetooth firmware loader for the same device.

## Touchpad (I²C) — needs the `_OSI` patch

*Found by reading the DSDT; we handled it up front.*

**Cause (from the DSDT):** the firmware only enables the I²C device when it sees Windows 2012 or newer (`OSYS ≥ 0x07DC`); macOS does not report that.

**Fix:** ACPI patch `_OSI → XOSI` (Find `5F4F5349`, Replace `584F5349`) plus `SSDT-XOSI.aml`, which answers "Windows 2015" for macOS. Then VoodooI2C + VoodooI2CHID. See [ACPI.md](ACPI.md).

## Battery (16-bit EC fields)

*Found by reading the DSDT; we handled it up front.*

**Cause (from the DSDT):** the embedded controller exposes 16-bit and larger fields (`MBCT`, `RCAP`, `MBVT`, …), which macOS cannot read byte-by-byte.

**Fix:** **ECEnabler** (before SMCBatteryManager). No per-field ACPI patching needed.

## Clock / RTC

The firmware ships the newer `AWAC` clock device, which macOS cannot use. `SSDT-AWAC.aml` sets `STAS = 1` for macOS so the legacy RTC is used.

## Embedded controller name

macOS expects an EC called `EC`; this laptop's real one is `EC0`. `SSDT-EC-USBX.aml` adds a stand-in `EC` (macOS only) and the `USBX` power properties.

## Backlight

The firmware tables have no backlight device. `SSDT-PNLF.aml` adds one (`UID 0x13`); WhateverGreen gets `-igfxblt -igfxblr`; BrightnessKeys handles the hotkeys. (Brightness control still needs verification.)

## NVIDIA GTX 1650 Ti

macOS has no driver for Turing GPUs, and the dGPU is not connected to the built-in panel. It is hidden with `-wegnoegpu`.

We also tried the experimental third-party **NullMoth NVIDIA driver** (v2.6.6): the four kexts loaded, but the card produced **no display output** (HDMI did not work) on this model, and the desktop stayed on the Intel GPU, so we removed it. The driver also requires weakening SIP/AMFI, which we do not recommend for a daily system.

**Result:** HDMI and USB-C video-out do not work on this laptop in macOS; the built-in screen runs on the UHD 630.

## USB ports

macOS supports 15 ports per controller and this laptop exposes more. This EFI ships `USBToolBox.kext` + `UTBDefault.kext` as a placeholder. Map your ports with USBToolBox after the first boot and use your own map.

## <a name="dual-boot"></a>Dual boot: boot list keeps changing / Windows listed twice

- Windows (and sometimes the BIOS) rewrites the firmware boot order, which can push OpenCore below Windows.
- This laptop had **two EFI partitions with Windows boot files** (our 200 MB one and an extra 1 GB one), so the firmware boot menu listed Windows twice.

What worked for us:
- Keep **Windows as default** and press **Esc** to pick OpenCore (the entry survives; the order does not matter).
- Add OpenCore as a boot entry that starts OpenCore's loader (`BOOTx64.efi`), not `OpenCore.efi` directly.
- Remove the duplicate Windows firmware entry (only the boot-list record, no files): `bcdedit /enum firmware` to find it, then `bcdedit /delete {id}`. Keep a backup (`bcdedit /export`) first.
- If you keep OpenCore on the Windows ESP, do not wipe anything there; add only an `OC` folder.

## Install media problems

One of our USB drives threw I/O timeouts (`The semaphore timeout period has expired`) in the middle of the install. If the install stops partway or the drive disconnects, try another stick, cable, or port — plug it straight into the laptop, not a hub.

## Disable macOS software updates

Run `scripts/disable-macos-updates.command` in macOS (asks for your password). It turns off automatic update settings, blocks Apple's update servers in `/etc/hosts` and tries to stop the update service (the last part may be refused with SIP enabled). `--undo` reverses it. OpenCore's `BlacklistAppleUpdate = True` also blocks Apple firmware updates.
