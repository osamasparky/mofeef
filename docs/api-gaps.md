# API Gaps & Mismatch Log 📝

This document records any feature that exists in Figma or the UI where specific backend endpoints or fields have limitations.

---

### Item 1: Wallet System
- **Figma**: Wallet Screen exists with Available Balance, Top-up, Transfer, and Transactions list.
- **API Status**: The primary API focuses on Services Booking (Tours, Museums, Events, Cars, Guides) and Shop Cart Orders. A dedicated `/wallet/balance` or `/wallet/top-up` endpoint is not explicitly defined in the collection.
- **Handling**: The UI is fully built following Figma design tokens. Wallet state is handled gracefully with clear indicators and mock balance integration until backend wallet endpoint is deployed.

---

### Item 2: Guide Booking Parameters
- **Figma & Discovery**: Guide details show profile, hourly rates, and expertise.
- **API Status**: Guide enquiry / booking endpoint delegates to `/booking/addToCart` with `service_type: 'guide'`.
- **Handling**: Implemented using the standard booking service engine.
