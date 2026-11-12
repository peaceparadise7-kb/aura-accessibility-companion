/// Physical control types detected on household appliances.
enum ControlType {
  button('Button'),
  dial('Rotary Dial'),
  switchToggle('Toggle Switch'),
  display('Status Display'),
  touchPad('Capacitive Touch Pad'),
  slider('Linear Slider'),
  knob('Rotary Knob');

  final String displayName;
  const ControlType(this.displayName);

  static ControlType fromString(String value) {
    return switch (value.toLowerCase()) {
      'button' => ControlType.button,
      'dial' => ControlType.dial,
      'switch_toggle' || 'switch' => ControlType.switchToggle,
      'display' => ControlType.display,
      'touch_pad' || 'touchpad' => ControlType.touchPad,
      'slider' => ControlType.slider,
      'knob' => ControlType.knob,
      _ => ControlType.button,
    };
  }
}
