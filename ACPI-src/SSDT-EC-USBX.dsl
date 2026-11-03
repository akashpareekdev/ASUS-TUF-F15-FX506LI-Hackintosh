DefinitionBlock ("", "SSDT", 2, "HKINTO", "ECUSBX", 0x00001000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (\_SB.PCI0.LPCB)
    {
        // macOS wants an EC named "EC"; this laptop's real EC is EC0, so give macOS a stand-in
        Device (EC)
        {
            Name (_HID, "ACID0001")
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }

    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)
            Method (_DSM, 4, NotSerialized)
            {
                If (!Arg2)
                {
                    Return (Buffer (One) { 0x03 })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPortCurrentLimit", 0x0BB8,
                    "kUSBWakePortCurrentLimit",  0x0BB8,
                    "kUSBSleepPowerSupply",      0x2580,
                    "kUSBWakePowerSupply",       0x2580
                })
            }
        }
    }
}
