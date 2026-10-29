# Albera Perfume — Flutter Ecommerce App

Premium, responsive fragrance ecommerce application designed for India, Middle East and Asia-Pacific markets.

## Features

- Premium fragrance storefront
- Responsive mobile-first UI
- Home, categories, search and product details
- Wishlist
- Cart
- Checkout and address management
- Order history and tracking UI
- Profile
- English / Hindi / Arabic-ready localization
- RTL-ready Arabic presentation
- INR/AED/SAR and other currency-ready configuration
- REST API service layer
- Secure token storage
- Local cart/wishlist persistence
- Loading, error and empty states
- Professional feature-based architecture

## Project architecture

```text
lib/
├── app/
├── core/
├── data/
├── features/
├── localization/
└── main.dart
```

## Run

1. Install Flutter 3.24+.
2. Copy `.env.example` to `.env`.
3. Set `API_BASE_URL`.
4. Run:

```bash
flutter pub get
flutter run
```

For release Android:

```bash
flutter build appbundle --release
```

For APK:

```bash
flutter build apk --release
```

## Backend

The app is intentionally API-ready. Replace the endpoints in `lib/core/network/api_client.dart` or connect them to your Node.js backend.

Recommended production backend endpoints:

- POST /auth/login
- POST /auth/register
- GET /products
- GET /products/:id
- GET /categories
- POST /orders
- GET /orders
- GET /orders/:id
- POST /wishlist
- GET /wishlist
- POST /payments/create-order
- POST /payments/verify

## Branding

Replace files under `assets/images/` with the official Albera logo, banners and product photos.
