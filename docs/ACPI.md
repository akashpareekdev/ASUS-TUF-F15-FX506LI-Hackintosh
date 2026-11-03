# ACPI notes

Written from the firmware's own tables (`DSDT`, BIOS `FX506LI.310`). To read yours: dump the tables (Windows keeps copies under `HKLM\HARDWARE\ACPI`; `acpidump` or SSDTTime also work) and decompile with Intel's `iasl` (ACPICA), then compare.

## What we found in the DSDT

| Item | Finding |
|---|---|
| CPU scope | `\_SB.PR00` and the following Processor objects |
| iGPU | `\_SB.PCI0.GFX0`, `_ADR = 0x00020000` |
| dGPU | `\_SB.PCI0.PEG0.PEGP` |
| Embedded controller | `\_SB.PCI0.LPCB.EC0` (`PNP0C09`) — name is `EC0`, not `EC` |
| Clock | `AWAC` (`ACPI000E`), `_STA` depends on `STAS` |
| Touchpad | `\_SB.PCI0.I2C0.TPD0` — HID `ELAN1203` / `SYNA2393` / `ELAN2097`, enabled only if `OSYS ≥ 0x07DC` |
| GPIO | `\_SB.PCI0.GPI0` (not required; VoodooI2C works in polling mode) |
| Battery | `BAT1`; EC fields `MBCT`, `RCAP`, `MBVT`, `MBC2`, `DBAT`, `FRMS`, `MDCP`, `MBCP`, `MBDV`, `BTMP`, `BASN`, `MBDN`, `NMON`, `CYCL` are 16-bit or larger |
| OS check | `_OSI` is used 100+ times and sets `OSYS` from "Windows 20xx" strings |

## The SSDTs (sources in `../ACPI-src/`)

- **SSDT-PLUG** — `plugin-type = 1` on `\_SB.PR00` so macOS loads native CPU power management.
- **SSDT-AWAC** — `\_INI` sets `STAS = 1` when the OS is Darwin, disabling AWAC so the real RTC is used.
- **SSDT-EC-USBX** — creates an `EC` device (`ACID0001`, enabled only for macOS) in `LPCB`, and the `USBX` device with the USB power properties.
- **SSDT-PNLF** — `PNLF` backlight device (`APP0002`, `UID 0x13`) under `GFX0`.
- **SSDT-XOSI** — new method `XOSI(Arg0)`: for Darwin it returns true for the Windows versions up to "Windows 2015", otherwise it forwards to the real `_OSI`.

## The rename patch

`ACPI → Patch`: Comment *_OSI to XOSI*, **Find** `5F4F5349` → **Replace** `584F5349`. OpenCore applies patches to the firmware's own tables, not to the SSDTs it adds, so `SSDT-XOSI` and the other SSDTs can still call `_OSI` normally.
