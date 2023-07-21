{
  mcu_adxl = {
    serial = "/dev/serial/by-id/usb-Klipper_rp2040_E66198F1CF801D27-if00";
  }
 
  adxl345 = {
    cs_pin = "adxl:gpio1";
    spi_bus = "spi0a";
  }

  resonance_tester = {
    accel_chip = "adxl345";
    probe_points = "150,150,20";
  }

}