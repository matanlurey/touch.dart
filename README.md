# touch

Browser abstraction for Touch and Mouse.

**Warning**: This is not an official Google or Dart project.

## Usage

```dart
import 'dart:html';

import 'package:touch/touch.dart' as touch;

void main() {
  var div = document.querySelector('#element');
  new touch.Listener()
      ..onStart.listen((_) {
    
      })
      ..onMove.listen((_) {
    
      })
      ..onEnd.listen((_) {
    
      });
}
```
