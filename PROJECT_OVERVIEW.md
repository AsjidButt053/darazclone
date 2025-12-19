# Daraz Clone - Flutter E-Commerce App

A complete frontend-only e-commerce mobile application built with Flutter and Material 3 design, mimicking the Daraz shopping experience.

## Features

### 1. Home / Product Catalog
- Grid view of products with images, names, and prices
- Search bar for filtering products by name/description
- Category filter chips (Electronics, Fashion, Beauty, Home, etc.)
- "Add to Cart" functionality with visual feedback
- Hero animations for smooth transitions

### 2. Product Details
- Large product image with Hero animation
- Complete product information (name, category, price, description)
- Stock availability indicator
- Quantity selector (1-10 items)
- "Add to Cart" button with total price calculation

### 3. Shopping Cart
- List of all cart items with quantities
- Update quantity or remove items
- Real-time total price calculation
- "Clear Cart" option
- "Proceed to Checkout" button

### 4. Payment Screen
- Simulated payment form with card details
- Form validation for card number, expiry, CVV
- Processing animation
- Success animation with confirmation dialog
- Auto-clear cart on successful payment

### 5. User Profile
- Display user information (Name: Asjid, Reg: FA23-BSE)
- Profile picture with camera/gallery picker
- Edit profile functionality
- Local storage using SharedPreferences

### 6. Admin Panel
- Login required (username: admin, password: 1234)
- View all products with statistics
- Add new products
- Edit existing products
- Delete products
- Real-time product management

## Technical Implementation

### Architecture
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences for user data, JSON file for products
- **Navigation**: Bottom navigation bar with 4 tabs
- **Animations**: Hero animations, scale animations, fade transitions

### Dependencies
```yaml
provider: ^6.0.5          # State management
image_picker: ^1.0.7      # Profile picture selection
shared_preferences: ^2.2.0 # Local storage
google_fonts: ^6.1.0      # Poppins font family
```

### Project Structure
```
lib/
├── main.dart                 # App entry point with theme
├── models/
│   ├── product.dart         # Product data model
│   ├── cart_item.dart       # Cart item model
│   └── user_profile.dart    # User profile model
├── providers/
│   ├── product_provider.dart # Product state management
│   ├── cart_provider.dart    # Cart state management
│   └── user_provider.dart    # User profile management
└── screens/
    ├── home_screen.dart          # Product catalog
    ├── product_detail_screen.dart # Product details
    ├── cart_screen.dart          # Shopping cart
    ├── payment_screen.dart       # Payment simulation
    ├── profile_screen.dart       # User profile
    └── admin_panel_screen.dart   # Admin CRUD
assets/
├── data/
│   └── products.json        # Sample product data (16 products)
└── images/
    └── README.md           # Instructions for adding images
```

## Design

### Theme
- **Primary Color**: #F57C00 (Daraz Orange)
- **Secondary Color**: #263238 (Dark Gray)
- **Font**: Poppins (Google Fonts)
- **Design System**: Material 3

### UI Components
- Rounded corners (12px border radius)
- Card-based layouts with subtle shadows
- Orange accent color throughout
- Clean, modern interface

## How to Run

1. Ensure Flutter is installed:
   ```bash
   flutter --version
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run on connected device or emulator:
   ```bash
   flutter run
   ```

## User Information
- **Name**: Asjid
- **Registration Number**: FA23-BSE
- **Profile Picture**: Editable via camera/gallery

## Admin Credentials
- **Username**: admin
- **Password**: 1234

## Sample Data
The app includes 16 pre-loaded products across 4 categories:
- Electronics (4 products)
- Fashion (4 products)
- Beauty (4 products)
- Home (4 products)

## Notes
- All data is stored locally (no backend required)
- Products are loaded from `assets/data/products.json`
- User profile is saved using SharedPreferences
- Cart state is managed in-memory (resets on app restart)
- Payment is simulated (no real transactions)
- Product images use placeholder icons (add real images to `assets/images/`)

## Future Enhancements
- Add image loading for products
- Persist cart data locally
- Add order history
- Implement wishlist functionality
- Add product ratings and reviews
- Add more payment methods
- Implement real-time search suggestions

## Development Notes
- Built with Flutter SDK 3.9.2+
- Uses Material 3 design principles
- Fully responsive UI
- Clean, well-commented code
- Follows Flutter best practices

---

Created for MAD Mid Lab - University Project
Student: Asjid (FA23-BSE)
