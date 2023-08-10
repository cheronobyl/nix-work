{
  services.klipper = {
    user = "root";
    group = "root";
    enable = true;
    
    firmwares = {
      mcu = {
        enable = true;
        configFile = ./cr10v3.cfg;
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
      };
    };

    settings = {
      printer = {
        kinematics = "cartesian";
        max_velocity = 300;
        max_accel = 1600;
        max_z_velocity = 5;
        max_z_accel = 100;
      };

      input_shaper = {
        shaper_freq_x = "30.0";
        shaper_type_x = "mzv";
        shaper_freq_y = "23.6";
        shaper_type_y = "mzv";
      };

      mcu = {
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
      };

      display = {
        lcd_type = "st7920";
        cs_pin = "PH1";  #ar16
        sclk_pin = "PA1"; #ar23
        sid_pin = "PH0";  #ar17
        encoder_pins = "^PC4, ^PC6"; #^ar33, ^ar31
        click_pin = "^!PC2"; #^!ar35
      };

      stepper_x = {
        step_pin = "PF0";
        dir_pin = "PF1";
        enable_pin = "!PD7";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PE5";
        position_endstop = 0;
        position_max = 300;
        homing_speed = 50;
      };

      stepper_y = {
        step_pin = "PF6";
        dir_pin = "PF7";
        enable_pin = "!PF2";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PJ1";
        position_endstop = 0;
        position_max = 300;
        homing_speed = 50;
      };

      stepper_z = {
        step_pin = "PL3";
        dir_pin = "!PL1";
        enable_pin = "!PK0";
        microsteps = 16;
        rotation_distance = 8;
        endstop_pin = "probe:z_virtual_endstop";
        position_min = -4;
        position_max = 400;
      };

      extruder = {
        step_pin = "PA4";
        dir_pin = "!PA6";
        enable_pin = "!PA2";
        microsteps = 16;
        rotation_distance = "7.961875";
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        heater_pin = "PB4";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PK5";
        control = "pid";
        pid_kp =  20.788;
        pid_ki = 1.004;
        pid_kd = 107.580;
        min_temp = 0;
        max_temp = 300;
        pressure_advance = 0.06425; # measure 4/23/23 using Tower method
        #max_extrude_only_distance = 101; #temp for setting distance
      };

      heater_bed = {
        heater_pin = "PH5";
        sensor_type = "ATC Semitec 104GT-2";
        sensor_pin = "PK6";
        control = "pid";
        pid_kp = 74.797;
        pid_ki = 1.039;
        pid_kd = 1346.352;
        min_temp = 0;
        max_temp = 130;
      };

      fan.pin = "PH6";

      bltouch = {
        sensor_pin = "^PD2";
        control_pin = "PB5";
        set_output_mode = "5V";
        pin_move_time = 0.4;
        stow_on_each_sample = false;
        probe_with_touch_mode = true;
        x_offset = 45.75;
        y_offset = -3.40;
        z_offset = 1.150;
        samples = 2;
        sample_retract_dist = 2;
        samples_result = "average";
      };

      bed_mesh = {
        speed = 50;
        horizontal_move_z = 6;
        mesh_min = "46.50,0.75";
        mesh_max = "295.85,295.85";
        probe_count = 6;
        algorithm = "bicubic";
      };

      pause_resume.recover_velocity = 50;
      "filament_switch_sensor fil_runout_sensor" = {
        pause_on_runout = false;
        switch_pin = "PE4";
      };

      safe_z_home = {
        home_xy_position = "150,150";
        speed = "50.0";
        z_hop = "5";
        z_hop_speed = "15.0";
      };

      bed_screws = {
        screw1 = "33,29";
        screw1_name = "front left screw";
        screw2 = "273,29";
        screw2_name = "front right screw";
        screw3 = "273,269";
        screw3_name ="rear right screw";
        screw4 = "33,269";
        screw4_name = "rear left screw";
      };

      screws_tilt_adjust = {
        screw1 = "5,29";
        screw1_name = "front left screw";
        screw2 = "228,29";
        screw2_name = "front right screw";
        screw3 = "228,269";
        screw3_name = "rear right screw";
        screw4 = "5,269";
        screw4_name = "rear left screw";
        speed = 50;
        horizontal_move_z = 10;
        screw_thread = "CW-M3";
      };
      
      # Required config for Fluidd
      virtual_sdcard.path = "/home/fluidd/gcode-files";
      pause_resume = { };
      display_status = { };

      # Uncomment to enable ADXLMCU devices for resonance compensation calibration
      # "include adxlmcu.cfg" = {};

      # GCode Macros

      "gcode_macro G29".gcode = "BED_MESH_CALIBRATE";

      "gcode_macro PRINT_START".gcode = "
         {% set BED_TEMP = params.BED_TEMP|default(60)|float %}	
         {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(190)|float %}
         M140 S{BED_TEMP}             ; start heating bed
         M104 S{EXTRUDER_TEMP}        ; start heating hotend
         G21                          ; metric values
         G90                          ; absolute pos
         M82                          ; set extruder to absolute mode
         G28                          ; home
         G29                          ; auto bed leveling
         G1 X5 Y5 Z1 F2000            ; move to origin
         G92 E0                       ; reset extrusion
         M190 S{BED_TEMP}             ; wait on bed temp
         M109 S{EXTRUDER_TEMP}        ; wait on hotend temp
         G1 Z0                        ; move nozzle to bed
         G1 X80 E12 F500              ; begin nozzle priming
         G1 X140 E15 F500             ; end nozzle priming
         G92 E0                       ; reset extrusion
         M117 Printing...
      ";

      "gcode_macro PRINT_END".gcode = "
         M104 S0     ; turn off extruder
         M140 S0     ; turn off bed
         G91         ; relative positioning
         G1 E-1 F300 ; retract the filament a bit
         G1 Z20      ; jump the Z a tad
	       G90	       ; absolute coordinates
         G1 X0 Y280  ; move Y axis away
         M107        ; turn off fan
         M84         ; disable motors
         M109 R50    ; wait for extruder to cool to 50C
         M81         ; turn off psu
	       M117 Print finished!
      ";

      "gcode_macro PAUSE" = {
        description = "Pause the actual running print";
        rename_existing = "PAUSE_BASE";
        gcode = "
        ##### set defaults #####
        {% set x = params.X|default(200) %}
        {% set y = params.Y|default(200) %}
         {% set z = params.Z|default(10)|float %}
        {% set e = params.E|default(5) %}
        ##### calculate save lift position #####
        {% set max_z = printer.toolhead.axis_maximum.z|float %}
        {% set act_z = printer.toolhead.position.z|float %}
        {% set lift_z = z|abs %}
        {% if act_z < (max_z - lift_z) %}
            {% set z_safe = lift_z %}
        {% else %}
            {% set z_safe = max_z - act_z %}
        {% endif %}
        ##### end of definitions #####
        PAUSE_BASE
        G91
        {% if printer.extruder.can_extrude|lower == 'true' %}
          G1 E-{e} F2100
        {% else %}
          {action_respond_info(\"Extruder not hot enough\")}
        {% endif %}
        {% if \"xyz\" in printer.toolhead.homed_axes %}
          G1 Z{z_safe}
          G90
          G1 X{x} Y{y} F6000
        {% else %}
          {action_respond_info(\"Printer not homed\")}
        {% endif %}
        ";
      };

      "gcode_macro RESUME" = {
        description = "Resume the actual running print";
        rename_existing = "RESUME_BASE";
        gcode = "
        ##### set defaults #####
        {% set e = params.E|default(5) %}
        #### get VELOCITY parameter if specified ####
        {% if 'VELOCITY' in params|upper %}
            {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}
        {%else %}
            {% set get_params = \" \" %}
        {% endif %}
        ##### end of definitions #####
        G91
        {% if printer.extruder.can_extrude|lower == 'true' %}
            G1 E{e} F2100
        {% else %}
            {action_respond_info(\"Extruder not hot enough\")}
        {% endif %}  
        RESUME_BASE {get_params}
        ";
      };

      "gcode_macro CANCEL_PRINT" = {
        description = "Cancel the actual running print";
        rename_existing = "CANCEL_PRINT_BASE";
        gcode = "
        TURN_OFF_HEATERS
        CANCEL_PRINT_BASE
        ";
      };

      "gcode_macro CENTER_Z_PROBE" = {
        description = "Place the Z Probe over the center of the bed";
        gcode = "
        G1 X104.25 Y153.40 G1 F7800 TURN_OFF_HEATERS
        ";
      };

    };
  };
} 

