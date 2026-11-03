# NVIDIA GTX 1650 Ti — optional, experimental

**Default EFI:** the NVIDIA card is **hidden** (`-wegnoegpu`). Apple has no driver for Turing GPUs, and the built-in screen runs on the Intel UHD 630. This is the stable setup and what you should use day to day.

**Experimental option:** `EFI/OC/config-nvidia.plist` plus the third-party **NullMoth NVIDIA driver**.

## What we saw

| | Result |
|---|---|
| Driver | NullMoth NVIDIA driver **v2.6.6** |
| Config | `config-nvidia.plist` from this repo |
| GTX 1650 Ti | ✅ shown as an **active GPU with Metal** in macOS |
| External displays (HDMI / USB-C video) | ❌ **no display output** |
| Built-in screen | stays on the Intel UHD 630 |

The default `config.plist` in this repo keeps the NVIDIA card hidden; `config-nvidia.plist` is the optional experiment.

## What the NVIDIA config changes

Compared with `config.plist`:

- `csr-active-config` = `430A0000` (SIP relaxed for unsigned kexts)
- boot-args: removes `-wegnoegpu`; adds `nvfb=1 nvaccel=1 nvfbheads=4 -nvkmsnosmooth amfi_get_out_of_my_way=0x1 amfi=0x80 nvrmsettle=10000`; `gfxrst=4`
- `Kernel → Block`: `com.apple.iokit.IONDRVSupport` (Exclude)
- `Kernel → Add`: `AMFIPass.kext` (first, after Lilu)

> **Risks:** weaker SIP and AMFI checks; the driver installs kernel extensions into `/Library/Extensions` and rebuilds macOS's kext collection; **macOS updates can break it**. The NullMoth project's issue tracker has open reports of kernel panics and sleep/wake problems on GTX 1650 *mobile* laptops. Its licence (PolyForm Noncommercial) forbids commercial use. Keep a backup of your EFI and a way to boot without it.

## Steps (only if you want to try it)

1. **Get AMFIPass 1.4.1** (not bundled here) from the Dortania OpenCore Legacy Patcher payloads: <https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera>. Unzip it to `EFI/OC/Kexts/AMFIPass.kext`.
2. **Get the driver** from the NullMoth releases: <https://github.com/nullmoth/nvidia-macos-driver/releases> (`nullmoth-nvidia-2.6.6.tar.gz` and `SHA256SUMS.txt`). Check the hash:
   ```
   shasum -a 256 nullmoth-nvidia-2.6.6.tar.gz
   ```
3. **Back up** your `EFI/OC/config.plist`, then replace it with `config-nvidia.plist` (fill in your own SMBIOS again) and restart into macOS.
4. In Terminal, extract and install (read the project's README first):
   ```
   tar -xzf nullmoth-nvidia-2.6.6.tar.gz && cd pkgroot
   shasum -a 256 -c SHA256SUMS
   sudo ./install.sh
   ```
5. Restart, then verify:
   ```
   kmutil showloaded --list-only | grep -i nullmoth
   system_profiler SPDisplaysDataType | head -30
   ```
6. **To go back:** `sudo ./uninstall.sh` (from the same `pkgroot`), restart, and restore your normal `config.plist`.

## Credits

NullMoth NVIDIA driver — <https://github.com/nullmoth/nvidia-macos-driver> (by NullMoth Systems). AMFIPass — distributed in the Dortania OpenCore Legacy Patcher payloads. Not part of this repository: they keep their own licences.
