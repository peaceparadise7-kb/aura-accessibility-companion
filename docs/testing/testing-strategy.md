# AURA Multi-Tier Testing Strategy

## 1. Testing Pyramid

```
                / \
               /   \
              / E2E \           Native Device Integration (Physical Cameras & ARCore/ARKit)
             /-------\
            / Widget  \         Flutter Widget & Accessibility Semantics Tests
           /-----------\
          /  Contracts  \       Cross-Platform Event Serialization Tests (Swift/Kotlin/Dart)
         /---------------\
        /    Unit Tests   \     Domain Use Cases, Result Monads, Profile Parsers, Backend APIs
       /-------------------\
```

---

## 2. Test Execution Commands

### Mobile Unit & Widget Tests
```bash
cd apps/mobile
flutter test --coverage
```

### Backend Tests
```bash
pytest backend/tests -v
```

### Contract & Schema Validation
```bash
python infrastructure/ci/validate_schemas.py
```

### Native iOS Tests (macOS runner)
```bash
cd native/ios_ar
swift test
```

### Native Android Unit Tests
```bash
cd native/android_ar
./gradlew test
```
