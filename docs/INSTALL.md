# Install guide

Tested path: **macOS Sequoia 15.8.2**, installed on its own partition of the internal NVMe, using a USB stick for OpenCore and the recovery image.

> Back up everything first. This guide never touches your Windows partition, but a mistake in Disk Utility can erase the wrong disk.

## 1. Prepare

- A USB stick (8 GB or more, a **reliable** one — we had installs fail on a drive that was timing out).
- A way online during the install (the installer downloads about 13 GB). **Both Ethernet and Wi-Fi worked for us in the installer** — the included MediaTek driver is loaded there too, and we downloaded macOS over Wi-Fi. Ethernet is still the safer choice if you have a cable.
- Free space for macOS: shrink Windows or use a separate partition (~100 GB or more). Leave it as an empty partition; macOS will format it.
- Set the BIOS options: [BIOS-SETTINGS.md](BIOS-SETTINGS.md).
- Generate your SMBIOS: [SMBIOS.md](SMBIOS.md).

## 2. Download the Sequoia recovery image

Use OpenCore's `macrecovery` (in the OpenCorePkg release, `Utilities/macrecovery`). Needs Python 3.

```
python macrecovery.py -b Mac-7BA5B2D9E42DDD94 -m 00000000000000000 download
```

This produces `com.apple.recovery.boot` containing `BaseSystem.dmg` and `BaseSystem.chunklist` (about 850 MB).

## 3. Build the USB

1. Format the stick as **GPT** with a **FAT32** partition (2 GB is enough).
2. Copy the `EFI` folder from this repo (with your SMBIOS filled in) to the root of the FAT32 partition. GitHub does not store empty folders, so also create two empty folders if they are missing: `EFI/OC/Tools` and `EFI/OC/Resources`.
3. Copy the `com.apple.recovery.boot` folder to the root of the same partition.

## 4. Install

1. Boot the USB: tap **Esc** (boot menu) at power-on and choose the USB (UEFI) entry.
2. In OpenCore choose **macOS Base System**. The first screens are slow (the recovery image is loaded into memory); wait a few minutes.
3. Open **Disk Utility**, show all devices, and erase **only** your empty macOS partition as **APFS**, GUID.
4. Choose **Reinstall macOS Sequoia** and install onto that partition. It downloads about 13 GB and restarts several times; each time choose the macOS installer / Macintosh HD entry, never the Base System.

If you get *"Your Mac needs a firmware update…"*, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (it is already fixed in this config).

## 5. After the first boot

1. Mount your internal EFI partition and copy the same `EFI` folder to it, so you no longer need the USB.
2. Turn off automatic updates: `bash scripts/disable-macos-updates.command` (asks for your password; `--undo` reverses it).
3. Map your USB ports (USBToolBox) and replace `UTBDefault.kext` with your own map.
4. Remove `-v` from `boot-args` once everything is stable.
5. Optional: change `Misc → Debug → Target` from `67` to `3` to stop OpenCore from writing log files to the EFI partition.
6. `Misc → Boot → Timeout` is `0` in this EFI: OpenCore waits at its menu until you choose (set it to e.g. `5` if you want it to boot the default entry automatically).

## 6. Dual boot with Windows

Windows reorders its own boot entries, which can push OpenCore down the list. What worked for us: leave **Windows as the default** and press **Esc** at power-on to pick OpenCore when you want macOS. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md#dual-boot) for the details.
