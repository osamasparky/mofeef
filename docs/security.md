# Security & Data Protection Guidelines 🛡️

## 1. Token Management
- Access Tokens and Refresh Tokens are strictly stored in `FlutterSecureStorage` using hardware-backed keystore/keychain.
- No plain-text token persistence in SharedPreferences, SQLite or logs.
- Automatic 401 Unauthorized token refresh interception.

## 2. Payment Security
- Zero in-app card data processing. The app delegates transaction processing to the secure gateway URL provided by `/gateways` or `/booking/doCheckout`.

## 3. Communication Security
- HTTPS enforcement in production environments with proper SSL pinning capabilities.
